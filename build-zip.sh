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
ROOT="$(cd "$(dirname "$0")/pro" && pwd)" || exit 1
OUT="$ROOT/dist/startup-board-pro.zip"

# Everything in the skill folder except the dist/ output directory and the
# internal audit. Matches the payload assertion in evals/check.sh.
MEMBERS="SKILL.md INSTALL.md LICENSE CHANGELOG.md README-PRO.md .claude-plugin evals phases references"

for _m in $MEMBERS; do
  [ -e "$ROOT/$_m" ] || { echo "FAIL: $_m is missing from $ROOT; nothing was built" >&2; exit 1; }
done

# A libarchive tar, by any of its names. GNU tar is also called "tar" and
# cannot write zip at all, so check what answers rather than trusting the name.
TAR=""
for _c in bsdtar tar /c/Windows/System32/tar.exe /usr/bin/bsdtar; do
  command -v "$_c" >/dev/null 2>&1 || continue
  if "$_c" --version 2>/dev/null | grep -qiE 'bsdtar|libarchive'; then TAR="$_c"; break; fi
done

mkdir -p "$ROOT/dist" || exit 1
# zip -r appends to an existing archive, so a file deleted from the source
# would survive a rebuild. Remove the output first, on every path.
rm -f "$OUT"

cd "$ROOT" || exit 1
if [ -n "$TAR" ]; then
  echo "building with $("$TAR" --version 2>/dev/null | head -1 | cut -d' ' -f1-2)"
  "$TAR" -a -c -f "$OUT" $MEMBERS || { echo "FAIL: archive write failed; removing partial output" >&2; rm -f "$OUT"; exit 1; }
elif command -v zip >/dev/null 2>&1; then
  echo "building with Info-ZIP zip"
  zip -q -r -X "$OUT" $MEMBERS || { echo "FAIL: archive write failed; removing partial output" >&2; rm -f "$OUT"; exit 1; }
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
