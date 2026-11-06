#!/usr/bin/env sh
# Build the installable artifacts for every supported install route.
#
#   sh build-zip.sh          skill archive  -> dist/startup-board-pro.zip
#   sh build-zip.sh plugin   plugin archive -> dist/startup-board-pro-plugin.zip
#   sh build-zip.sh gpt      custom-GPT set -> dist/startup-board-pro-gpt/
#
# Why three. The Claude app's skill uploader REFUSES an archive containing
# .claude-plugin/plugin.json; its plugin uploader REQUIRES that file at the
# archive root. One archive cannot satisfy both, so the manifest is the only
# difference between the first two. Codex reads a plain folder
# (~/.agents/skills/<name>/), so the skill archive serves it unzipped.
# A custom GPT takes neither: it caps instructions at 8000 characters and
# knowledge at 20 files, so gpt mode emits a condensed, merged bundle.
#
# Why not PowerShell. Compress-Archive on Windows PowerShell 5.1 writes "\"
# as the entry separator, against ZIP spec 4.4.17.1 which requires "/".
# Info-ZIP unzip repairs that on read, so a build verified with Expand-Archive
# or with unzip looks clean, while macOS Archive Utility extracts one flat
# file named "references\fit-ladder.md" and every link in SKILL.md dies.
# bsdtar/libarchive writes "/" and ships with Windows 10+, macOS 10.15+ and
# most Linux. Info-ZIP zip is the fallback. If neither is here, this script
# refuses: a wrong archive is worse than no archive.
set -u
# This script sits at the repo root; the folder it packages is pro/.
# CDPATH= so `cd` cannot print a directory and corrupt ROOT. A set CDPATH is
# rare, but it only has to bite once and the failure would be silent.
CDPATH=

# An unknown mode must refuse rather than fall through to the default: a typo
# would otherwise rebuild the skill archive and report success, and the person
# would upload the one archive their target rejects.
MODE="${1:-skill}"
case "$MODE" in
  skill|plugin|gpt) ;;
  *) echo "FAIL: unknown mode \"$MODE\"; use skill (default), plugin or gpt" >&2; exit 1 ;;
esac

ROOT="$(cd "$(dirname "$0")/pro" && pwd)" || { echo "FAIL: cannot resolve pro/ beside $0 — the builder must sit next to the folder it packages" >&2; exit 1; }
REPO="$(cd "$(dirname "$0")" && pwd)"

case "$MODE" in
  skill)  OUT="$ROOT/dist/startup-board-pro.zip" ;;
  plugin) OUT="$ROOT/dist/startup-board-pro-plugin.zip" ;;
  gpt)    OUT="$ROOT/dist/startup-board-pro-gpt" ;;
esac

# Top-level members of the skill folder. What is left out inside them is
# decided by payload-exclude.txt (below), which evals/check.sh also reads.
MEMBERS="SKILL.md INSTALL.md LICENSE CHANGELOG.md README-PRO.md evals phases references"
[ "$MODE" = plugin ] && MEMBERS="$MEMBERS .claude-plugin"

# The one exclusion list, shared with the guard. Missing or empty means refuse:
# building with a different list than the guard uses is the bug it prevents.
EXCLUDE_FILE="$REPO/payload-exclude.txt"
[ -f "$EXCLUDE_FILE" ] || { echo "FAIL: exclusion list $EXCLUDE_FILE is missing; nothing was built" >&2; exit 1; }
PATTERNS=$(sed 's/#.*//; s/^[[:space:]]*//; s/[[:space:]]*$//' "$EXCLUDE_FILE" | grep -v '^$')
# The manifest is excluded for the skill archive only. Plugin mode drops that
# one pattern and keeps every other exclusion, so the two archives cannot
# drift apart in any other respect.
if [ "$MODE" = plugin ]; then
  PATTERNS=$(printf '%s\n' "$PATTERNS" | grep -vxF '.claude-plugin/*')
fi
[ -n "$PATTERNS" ] || { echo "FAIL: $EXCLUDE_FILE holds no patterns; nothing was built" >&2; exit 1; }

for _m in $MEMBERS; do
  [ -e "$ROOT/$_m" ] || { echo "FAIL: $_m is missing from $ROOT; nothing was built" >&2; exit 1; }
done

# ---- the archive writer ---------------------------------------------------
# A libarchive tar, by any of its names. GNU tar is also called "tar" and
# cannot write zip at all, so check what answers rather than trusting the name.
# Detected before gpt mode because that mode ships an archive too.
TAR=""
for _c in bsdtar tar /c/Windows/System32/tar.exe /usr/bin/bsdtar; do
  command -v "$_c" >/dev/null 2>&1 || continue
  # Capture the banner once: the probe needs it, and so does the build line.
  _ver=$("$_c" --version 2>/dev/null | head -1)
  case "$_ver" in *[Bb]sdtar*|*libarchive*) TAR="$_c"; TAR_VER="$_ver"; break ;; esac
done
if [ -z "$TAR" ] && ! command -v zip >/dev/null 2>&1; then
  echo "FAIL: no spec-compliant zip writer found. Need bsdtar (libarchive) or Info-ZIP zip." >&2
  echo "      Windows 10+ ships bsdtar at C:\\Windows\\System32\\tar.exe; macOS 10.15+ ships it as tar." >&2
  echo "      Do NOT substitute PowerShell Compress-Archive: it writes backslash separators." >&2
  exit 1
fi

# ---- gpt mode -------------------------------------------------------------
# A custom GPT has no filesystem: the phase and reference files it would
# follow links into have to arrive as uploaded knowledge. ChatGPT caps that at
# 20 files, and the payload is 40 markdown files, so they are merged by
# directory. evals/ is dropped: it is the test suite, which no founder reads
# and which would burn most of the file budget.
if [ "$MODE" = gpt ]; then
  SRC_INSTR="$REPO/gpt/instructions.md"
  [ -f "$SRC_INSTR" ] || { echo "FAIL: $SRC_INSTR is missing; gpt mode needs the condensed instructions" >&2; exit 1; }
  rm -rf "$OUT"
  mkdir -p "$OUT/knowledge" || exit 1
  cp "$SRC_INSTR" "$OUT/instructions.txt" || exit 1

  # Assert the cap rather than trusting the author to have counted. 8000 is
  # the limit the GPT builder enforces on save; a bundle that cannot be pasted
  # in is not a build artifact, it is a trap.
  _chars=$(wc -c < "$OUT/instructions.txt" | tr -d ' ')
  if [ "${_chars:-99999}" -gt 8000 ]; then
    echo "FAIL: instructions.txt is $_chars characters; the GPT builder rejects over 8000" >&2
    rm -rf "$OUT"; exit 1
  fi

  # payload-exclude.txt governs this mode too. Nothing it excludes currently
  # sits under phases/ or references/, but a list obeyed by two modes out of
  # three is not one list, and the next exclusion added there would ship to a
  # GPT unnoticed.
  _excluded() {
    while IFS= read -r _p; do
      case "$1" in $_p) return 0 ;; esac
    done <<EOF_X
$PATTERNS
EOF_X
    return 1
  }

  # Each bundle names the source path of every part it carries, so a pointer
  # like "phases/05-verdict.md" in the instructions still resolves by eye.
  # Every write is checked: a bundle truncated by a full disk would otherwise
  # reach a founder looking complete.
  _parts=0
  _bundle() {
    _dest="$OUT/knowledge/$1"; shift
    : > "$_dest" || { echo "FAIL: cannot write $_dest" >&2; rm -rf "$OUT"; exit 1; }
    for _f in "$@"; do
      # An unmatched glob arrives as its own literal pattern; a file that
      # vanished mid-build arrives as a path that no longer resolves. Neither
      # may pass quietly, so the empty-bundle check is not the only net.
      if [ ! -f "$_f" ]; then
        case "$_f" in
          *'*'*) echo "FAIL: no files matched $_f; bundle $1 would be short" >&2 ;;
          *)     echo "FAIL: $_f disappeared while bundling $1" >&2 ;;
        esac
        rm -rf "$OUT"; exit 1
      fi
      _rel="${_f#"$ROOT"/}"
      _excluded "$_rel" && continue
      printf '\n\n===== %s =====\n\n' "$_rel" >> "$_dest" || { echo "FAIL: cannot append to $_dest" >&2; rm -rf "$OUT"; exit 1; }
      cat "$_f" >> "$_dest" || { echo "FAIL: cannot append $_rel to $_dest" >&2; rm -rf "$OUT"; exit 1; }
      _parts=$((_parts+1))
    done
    [ -s "$_dest" ] || { echo "FAIL: knowledge bundle $1 came out empty" >&2; rm -rf "$OUT"; exit 1; }
  }
  _bundle phases.md               "$ROOT"/phases/*.md
  _bundle references-core.md      "$ROOT"/references/*.md
  _bundle references-advisors.md  "$ROOT"/references/advisors/*.md
  _bundle references-artifacts.md "$ROOT"/references/artifacts/*.md

  # The zip modes end in the guard; this mode has none, so it verifies itself.
  # Count what the source tree offers after exclusions and require the bundles
  # to carry exactly that. A glob that quietly matched a subset dies here.
  _want=0
  for _f in $(cd "$ROOT" && find phases references -name '*.md' -type f); do
    _excluded "${_f#./}" || _want=$((_want+1))
  done
  if [ "$_parts" -ne "$_want" ]; then
    echo "FAIL: bundled $_parts parts but the source tree offers $_want after exclusions" >&2
    rm -rf "$OUT"; exit 1
  fi

  _kn=$(find "$OUT/knowledge" -type f | wc -l | tr -d ' ')
  if [ "${_kn:-99}" -gt 20 ]; then
    echo "FAIL: $_kn knowledge files; a custom GPT accepts at most 20" >&2
    rm -rf "$OUT"; exit 1
  fi
  # The folder is what a person uploads file by file in the GPT builder; the
  # archive is what a download link can point at. Both come out of this one
  # build, so a link and a folder can never describe different versions.
  GPTZIP="$ROOT/dist/startup-board-pro-gpt.zip"
  rm -f "$GPTZIP"
  if [ -n "$TAR" ]; then
    ( cd "$OUT" && "$TAR" -a -c -f "$GPTZIP" instructions.txt knowledge ) \
      || { echo "FAIL: could not write $GPTZIP" >&2; rm -f "$GPTZIP"; rm -rf "$OUT"; exit 1; }
  else
    ( cd "$OUT" && zip -q -r -X "$GPTZIP" instructions.txt knowledge ) \
      || { echo "FAIL: could not write $GPTZIP" >&2; rm -f "$GPTZIP"; rm -rf "$OUT"; exit 1; }
  fi
  [ -s "$GPTZIP" ] || { echo "FAIL: the writer exited 0 but $GPTZIP is missing or empty" >&2; rm -f "$GPTZIP"; rm -rf "$OUT"; exit 1; }

  echo "wrote $OUT ($_chars characters of instructions, $_kn knowledge files, $_parts parts)"
  echo "wrote $GPTZIP"
  exit 0
fi

# ---- zip modes ------------------------------------------------------------
mkdir -p "$ROOT/dist" || exit 1
# zip -r appends to an existing archive, so a file deleted from the source
# would survive a rebuild. Remove the output first, on every path.
rm -f "$OUT"

cd "$ROOT" || exit 1
if [ -n "$TAR" ]; then
  echo "building with $(printf '%s' "$TAR_VER" | cut -d' ' -f1-2)"
  set --
  while IFS= read -r _p; do set -- "$@" "--exclude=$_p"; done <<EOF_PATTERNS
$PATTERNS
EOF_PATTERNS
  "$TAR" -a -c -f "$OUT" "$@" $MEMBERS || { echo "FAIL: archive write failed; removing partial output" >&2; rm -f "$OUT"; exit 1; }
elif command -v zip >/dev/null 2>&1; then
  echo "building with Info-ZIP zip"
  set --
  while IFS= read -r _p; do set -- "$@" "$_p"; done <<EOF_PATTERNS
$PATTERNS
EOF_PATTERNS
  zip -q -r -X "$OUT" $MEMBERS -x "$@" || { echo "FAIL: archive write failed; removing partial output" >&2; rm -f "$OUT"; exit 1; }
fi

# A writer that exits 0 without producing a file would otherwise sail through:
# check_zip with no path argument treats an absent archive as an absent build
# artifact and prints ok. Assert the output before trusting the guard.
[ -s "$OUT" ] || { echo "FAIL: the writer exited 0 but $OUT is missing or empty" >&2; rm -f "$OUT"; exit 1; }
echo "wrote $OUT"
# The build is not finished until the guard passes. Plugin mode tells the
# guard to expect the manifest, so both archives are checked against the one
# shared exclusion list.
if [ "$MODE" = plugin ]; then
  SBP_ZIP_WITH_MANIFEST=1 sh "$ROOT/evals/check.sh" zip "$OUT"
else
  sh "$ROOT/evals/check.sh" zip "$OUT"
fi
