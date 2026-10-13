#!/usr/bin/env sh
# Build the installable zip for install routes 1 and 2.
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
ROOT="$(cd "$(dirname "$0")/pro" && pwd)" || { echo "FAIL: cannot resolve pro/ beside $0 — the builder must sit next to the folder it packages" >&2; exit 1; }
OUT="$ROOT/dist/startup-board-pro.zip"

# Top-level members of the skill folder. What is left out inside them is
# decided by payload-exclude.txt (below), which evals/check.sh also reads.
MEMBERS="SKILL.md INSTALL.md LICENSE CHANGELOG.md README-PRO.md .claude-plugin evals phases references"

# The one exclusion list, shared with the guard. Missing or empty means refuse:
# building with a different list than the guard uses is the bug it prevents.
EXCLUDE_FILE="$(cd "$(dirname "$0")" && pwd)/payload-exclude.txt"
[ -f "$EXCLUDE_FILE" ] || { echo "FAIL: exclusion list $EXCLUDE_FILE is missing; nothing was built" >&2; exit 1; }
PATTERNS=$(sed 's/#.*//; s/^[[:space:]]*//; s/[[:space:]]*$//' "$EXCLUDE_FILE" | grep -v '^$')
[ -n "$PATTERNS" ] || { echo "FAIL: $EXCLUDE_FILE holds no patterns; nothing was built" >&2; exit 1; }

for _m in $MEMBERS; do
  [ -e "$ROOT/$_m" ] || { echo "FAIL: $_m is missing from $ROOT; nothing was built" >&2; exit 1; }
done

# A libarchive tar, by any of its names. GNU tar is also called "tar" and
# cannot write zip at all, so check what answers rather than trusting the name.
TAR=""
for _c in bsdtar tar /c/Windows/System32/tar.exe /usr/bin/bsdtar; do
  command -v "$_c" >/dev/null 2>&1 || continue
  # Capture the banner once: the probe needs it, and so does the build line.
  _ver=$("$_c" --version 2>/dev/null | head -1)
  case "$_ver" in *[Bb]sdtar*|*libarchive*) TAR="$_c"; TAR_VER="$_ver"; break ;; esac
done

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
else
  echo "FAIL: no spec-compliant zip writer found. Need bsdtar (libarchive) or Info-ZIP zip." >&2
  echo "      Windows 10+ ships bsdtar at C:\\Windows\\System32\\tar.exe; macOS 10.15+ ships it as tar." >&2
  echo "      Do NOT substitute PowerShell Compress-Archive: it writes backslash separators." >&2
  exit 1
fi

# A writer that exits 0 without producing a file would otherwise sail through:
# check_zip with no path argument treats an absent archive as an absent build
# artifact and prints ok. Assert the output before trusting the guard.
[ -s "$OUT" ] || { echo "FAIL: the writer exited 0 but $OUT is missing or empty" >&2; rm -f "$OUT"; exit 1; }
echo "wrote $OUT"
# The build is not finished until the guard passes.
sh "$ROOT/evals/check.sh" zip
