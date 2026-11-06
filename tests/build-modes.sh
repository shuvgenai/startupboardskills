#!/usr/bin/env sh
# Tests for build-zip.sh's three modes.
#
# This file sits at the repo root, NOT under pro/, on purpose: everything
# under pro/ is payload, and check_zip() compares the archive against that
# tree file by file. A test added under pro/ would change the payload and
# every archive would need a rebuild to stay green.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PRO="$ROOT/pro"
DIST="$PRO/dist"
PASS=0; FAILN=0
ok()   { PASS=$((PASS+1)); echo "  ok   $1"; }
bad()  { FAILN=$((FAILN+1)); echo "  FAIL $1"; }

# T5 writes a probe file into the payload. Remove it on every exit path,
# including a failed assertion or an interrupt: leaving it behind would put
# a junk file in the next archive someone builds.
PROBE="$PRO/references/zz-stale-probe.md"
cleanup() { rm -f "$PROBE"; }
trap cleanup EXIT INT TERM

# Entry names as stored, so a backslash separator is visible rather than
# repaired on read. unzip -Z1 keeps them; namelist() would not.
names() { unzip -Z1 "$1" 2>/dev/null; }

# A negative assertion over empty output passes for the wrong reason: no
# manifest found because the archive has none, or because nothing could read
# it. Every "does not contain" check below is gated on this first.
listable() {
  if [ -n "$(names "$1")" ]; then return 0; fi
  bad "cannot list entries of $1 (is unzip installed?); negative checks below would pass vacuously"
  return 1
}

echo "T1 default mode: the skill archive, no manifest"
rm -f "$DIST/startup-board-pro.zip"
if sh "$ROOT/build-zip.sh" >/dev/null 2>&1; then ok "default build exits 0"
else bad "default build exited non-zero"; fi
if [ -s "$DIST/startup-board-pro.zip" ]; then ok "wrote startup-board-pro.zip"
else bad "startup-board-pro.zip missing or empty"; fi
if names "$DIST/startup-board-pro.zip" | grep -qx 'SKILL.md'; then ok "SKILL.md at archive root"
else bad "SKILL.md is not at the archive root"; fi
if listable "$DIST/startup-board-pro.zip"; then
  if names "$DIST/startup-board-pro.zip" | grep -q '^\.claude-plugin/'; then
    bad "skill archive carries a plugin manifest; the Claude app rejects that"
  else ok "skill archive carries no plugin manifest"; fi
fi

echo "T2 plugin mode: the manifest at the archive root"
rm -f "$DIST/startup-board-pro-plugin.zip"
if sh "$ROOT/build-zip.sh" plugin >/dev/null 2>&1; then ok "plugin build exits 0"
else bad "plugin build exited non-zero"; fi
if [ -s "$DIST/startup-board-pro-plugin.zip" ]; then ok "wrote startup-board-pro-plugin.zip"
else bad "startup-board-pro-plugin.zip missing or empty"; fi
if names "$DIST/startup-board-pro-plugin.zip" | grep -qx '\.claude-plugin/plugin\.json'; then
  ok ".claude-plugin/plugin.json at the archive root"
else bad ".claude-plugin/plugin.json is not at the archive root"; fi
if names "$DIST/startup-board-pro-plugin.zip" | grep -qx 'SKILL.md'; then ok "plugin archive also keeps SKILL.md at root"
else bad "plugin archive lost SKILL.md from the root"; fi
if listable "$DIST/startup-board-pro-plugin.zip"; then
  if names "$DIST/startup-board-pro-plugin.zip" | grep -q 'dist/'; then
    bad "plugin archive ships dist/, which payload-exclude.txt excludes"
  else ok "plugin archive excludes dist/"; fi
  _bs=$(names "$DIST/startup-board-pro-plugin.zip" | grep -c '[\]' || true)
  if [ "${_bs:-1}" -eq 0 ]; then ok "plugin archive stores no backslash separators"
  else bad "plugin archive stores $_bs backslash separators (ZIP spec 4.4.17.1 requires /)"; fi
fi

echo "T3 unknown mode refuses"
_out=$(sh "$ROOT/build-zip.sh" nonsense 2>&1); _rc=$?
if [ "$_rc" -ne 0 ]; then ok "exits non-zero on an unknown mode"
else bad "exited 0 on an unknown mode; a typo would silently build the default"; fi
if printf '%s' "$_out" | grep -q 'unknown mode'; then ok "names the unknown mode in the error"
else bad "error text does not name the unknown mode: $_out"; fi

echo "T4 gpt mode: the custom-GPT bundle inside ChatGPT's caps"
rm -rf "$DIST/startup-board-pro-gpt"
if sh "$ROOT/build-zip.sh" gpt >/dev/null 2>&1; then ok "gpt build exits 0"
else bad "gpt build exited non-zero"; fi
GPT="$DIST/startup-board-pro-gpt"
if [ -s "$GPT/instructions.txt" ]; then ok "wrote instructions.txt"
else bad "instructions.txt missing or empty"; fi
_chars=$(wc -c < "$GPT/instructions.txt" 2>/dev/null | tr -d ' ')
if [ -n "$_chars" ] && [ "$_chars" -le 8000 ]; then ok "instructions.txt is $_chars chars, within the 8000 cap"
else bad "instructions.txt is ${_chars:-unreadable} chars, over ChatGPT's 8000-character instruction cap"; fi

# Exactly four bundles, each by name. A range of 1 to 20 would pass with a
# bundle missing, which is the failure worth catching: the cap is not in
# danger, a dropped directory is.
if [ -d "$GPT/knowledge" ]; then
  ok "knowledge directory exists"
  _kn=$(find "$GPT/knowledge" -type f | wc -l | tr -d ' ')
  if [ "$_kn" -eq 4 ]; then ok "exactly 4 knowledge files, within the 20-file cap"
  else bad "$_kn knowledge files, expected 4 (cap is 20)"; fi
  for _b in phases.md references-core.md references-advisors.md references-artifacts.md; do
    if [ -s "$GPT/knowledge/$_b" ]; then ok "bundle $_b is present and non-empty"
    else bad "bundle $_b is missing or empty"; fi
  done
  if find "$GPT" -type f | grep -q '/evals/'; then
    bad "gpt bundle ships evals/, which a founder never reads"
  else ok "gpt bundle drops evals/"; fi

  # Every part the bundles carry must exist, and the bundles together must
  # carry every phase and reference the shared exclusion list does not
  # exclude. Counting headers catches a glob that silently matched nothing.
  _hdrs=$(cat "$GPT"/knowledge/*.md | sed -n 's/^===== \(.*\) =====$/\1/p' | LC_ALL=C sort)
  _missing=0
  for _h in $_hdrs; do [ -f "$PRO/$_h" ] || _missing=$((_missing+1)); done
  if [ "$_missing" -eq 0 ]; then ok "every bundled part names a real source file"
  else bad "$_missing bundled parts name a file that does not exist"; fi

  _pats=$(sed 's/#.*//; s/^[[:space:]]*//; s/[[:space:]]*$//' "$ROOT/payload-exclude.txt" | grep -v '^$')
  _want=$(cd "$PRO" && find phases references -name '*.md' -type f | sed 's|^\./||' | while IFS= read -r _f; do
    _skip=0
    while IFS= read -r _p; do case "$_f" in $_p) _skip=1; break ;; esac; done <<EOF_P
$_pats
EOF_P
    [ "$_skip" -eq 0 ] && printf '%s\n' "$_f"
  done | LC_ALL=C sort)
  if [ "$_hdrs" = "$_want" ]; then ok "bundles carry every non-excluded phase and reference"
  else
    bad "bundled parts differ from the non-excluded source files"
    printf '%s\n' "$_want" > "${TMPDIR:-/tmp}/sbp-want.$$"
    printf '%s\n' "$_hdrs" > "${TMPDIR:-/tmp}/sbp-have.$$"
    diff "${TMPDIR:-/tmp}/sbp-want.$$" "${TMPDIR:-/tmp}/sbp-have.$$" | sed 's/^/       /'
    rm -f "${TMPDIR:-/tmp}/sbp-want.$$" "${TMPDIR:-/tmp}/sbp-have.$$"
  fi
else
  bad "knowledge directory missing; the per-bundle checks cannot run"
fi

echo "T6 gpt mode also writes a single downloadable archive"
# The folder is what a person uploads file by file; the archive is what a
# download link can point at. Both come from the same build so they cannot
# describe different versions of the bundle.
GPTZIP="$DIST/startup-board-pro-gpt.zip"
if [ -s "$GPTZIP" ]; then ok "wrote startup-board-pro-gpt.zip"
else bad "startup-board-pro-gpt.zip missing or empty"; fi
if names "$GPTZIP" | grep -qx 'instructions.txt'; then ok "instructions.txt at the archive root"
else bad "instructions.txt is not at the archive root"; fi
if listable "$GPTZIP"; then
  _kz=$(names "$GPTZIP" | grep -c '^knowledge/.*\.md$' || true)
  if [ "${_kz:-0}" -eq 4 ]; then ok "archive carries all 4 knowledge bundles"
  else bad "archive carries ${_kz:-0} knowledge bundles, expected 4"; fi
  if names "$GPTZIP" | grep -q '/evals/'; then bad "gpt archive ships evals/"
  else ok "gpt archive drops evals/"; fi
  _gbs=$(names "$GPTZIP" | grep -c '[\]' || true)
  if [ "${_gbs:-1}" -eq 0 ]; then ok "gpt archive stores no backslash separators"
  else bad "gpt archive stores $_gbs backslash separators (ZIP spec 4.4.17.1 requires /)"; fi
fi

echo "T5 a rebuild drops a file that left the source tree"
# The bug this guards: zip -r appends to an existing archive, so a deleted
# source file survives a rebuild. Rebuilding an unchanged tree cannot detect
# that - the entry count would match either way. Add a file, build, remove it,
# rebuild, and require it to be gone.
printf 'A throwaway file written by tests/build-modes.sh.\n' > "$PROBE"
if sh "$ROOT/build-zip.sh" plugin >/dev/null 2>&1; then
  if names "$DIST/startup-board-pro-plugin.zip" | grep -qx 'references/zz-stale-probe.md'; then
    ok "probe file reached the archive"
    rm -f "$PROBE"
    if sh "$ROOT/build-zip.sh" plugin >/dev/null 2>&1; then
      if names "$DIST/startup-board-pro-plugin.zip" | grep -qx 'references/zz-stale-probe.md'; then
        bad "the removed probe survived the rebuild; the archive is being appended to"
      else ok "the removed probe is gone from the rebuilt archive"; fi
    else bad "rebuild after removing the probe exited non-zero"; fi
  else bad "probe file never reached the archive; T5 cannot test what it claims"; fi
else bad "build with the probe present exited non-zero"; fi
cleanup

echo
echo "$PASS passed, $FAILN failed"
[ "$FAILN" -eq 0 ]
