#!/usr/bin/env sh
# Startup Board Pro static checks.
# Usage: evals/check.sh <contract|state|advisors|phases|artifacts|skill|plugin|sweeps|cases|zip|all>
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# The plugin manifests, CHANGELOG and sales page sit beside the skill folder in
# the build tree and one level above it in a buyer's install. Resolve both, so
# the suite a buyer re-runs reports drift rather than layout.
PKG="$ROOT"
_p="$ROOT"
for _i in 1 2 3; do
  if [ -d "$_p/.claude-plugin" ]; then PKG="$_p"; break; fi
  _p="$(cd "$_p/.." 2>/dev/null && pwd)" || break
  [ -n "$_p" ] || break
  if [ -d "$_p/.claude-plugin" ]; then PKG="$_p"; break; fi
done
# the sales page is README-PRO.md in the build tree and README.md in an install
if [ -f "$PKG/README-PRO.md" ]; then SALES="README-PRO.md"
elif [ -f "$PKG/README.md" ]; then SALES="README.md"
else SALES=""; fi
FAIL=0
BT=$(printf '\140')
# Pick an interpreter that actually runs. On Windows, python3 is commonly a
# Microsoft Store stub: it is on PATH, prints an install notice, and exits
# non-zero. Probing is the only way to tell a name apart from an interpreter.
PY=""
for _c in python3 python py; do
  if command -v "$_c" >/dev/null 2>&1 && "$_c" -c 'pass' >/dev/null 2>&1; then PY="$_c"; break; fi
done
fail() { echo "FAIL: $*"; FAIL=1; }
ok()   { echo "ok:   $*"; }

ADVISOR_NAMES='Fitzpatrick|Alvarez|Constable|Christensen|Steve Blank|Eric Ries|Osterwalder|Maurya|Dan Olsen|Sean Ellis|Andreessen|Cagan|Perri|Biddle|Croll|Yoskovitz|McClure|Weinberg|Balfour|Andrew Chen|Paul Graham|Ravikant|Hoffman|Feld'
BANNED_STACK='n8n|Supabase|Zapier|Make\.com|Integromat'
RETIRED_MARKERS='assumption — untested|estimate, unverified|Real or estimated'
VERDICTS='PROCEED PIVOT KILL'

has_file() { [ -f "$ROOT/$1" ] && ok "exists $1" || fail "missing $1"; }
has_str()  { grep -qF "$2" "$ROOT/$1" 2>/dev/null && ok "$1 has: $2" || fail "$1 missing: $2"; }
has_re()   { grep -qE "$2" "$ROOT/$1" 2>/dev/null && ok "$1 matches: $2" || fail "$1 missing pattern: $2"; }
pkg_file() { [ -f "$PKG/$1" ] && ok "exists $1" || fail "missing $1"; }
pkg_str()  { grep -qF "$2" "$PKG/$1" 2>/dev/null && ok "$1 has: $2" || fail "$1 missing: $2"; }
pkg_lacks_re() {
  if [ -f "$PKG/$1" ] && grep -qE "$2" "$PKG/$1" 2>/dev/null; then
    fail "$1 contains banned text: $(grep -oEm1 "$2" "$PKG/$1")"
  else ok "$1 clean of banned pattern"; fi
}
lacks_re() {
  if [ -f "$ROOT/$1" ] && grep -qE "$2" "$ROOT/$1" 2>/dev/null; then
    fail "$1 contains banned text: $(grep -oEm1 "$2" "$ROOT/$1")"
  else ok "$1 clean of banned pattern"; fi
}

check_contract() {
  has_file references/conversation-contract.md
  has_str  references/conversation-contract.md "One question per turn"
  has_str  references/conversation-contract.md "200 words"
  has_str  references/conversation-contract.md "Never compliment"
  for v in $VERDICTS; do has_str references/conversation-contract.md "$v"; done
  has_str  references/conversation-contract.md "TALK TO MORE CUSTOMERS"
  has_str  references/conversation-contract.md "accept all three"
  has_str  references/conversation-contract.md "re-ask"
  has_str  references/conversation-contract.md "Hedging is not labelling"
  has_str  references/evidence-rubric.md "own experience scores 0"
  has_str  references/evidence-rubric.md "inside of the building"
  has_file references/evidence-rubric.md
  for s in 0 1 2 3; do has_re references/evidence-rubric.md "^\| *$s *\|"; done
  has_file references/fit-ladder.md
  for s in Problem Research Product Customer Market Sales; do
    has_re references/fit-ladder.md "$s"; done
  has_re   references/fit-ladder.md '[0-9]'
}

check_state() {
  has_file references/state-file.md
  for h in Venture "Fit ladder" "Assumption ledger" "Evidence log" Numbers Decisions "Open loops" Calibration; do
    has_str references/state-file.md "## $h"; done
  for l in "OPEN LOOP" "CLOSE LOOP" "CALIBRATION LOOP"; do
    has_str references/state-file.md "$l"; done
  has_str references/state-file.md "startup-board-progress.md"
  has_str references/state-file.md "append-and-amend"
  has_str references/state-file.md "untouched on disk"
  has_str references/state-file.md "carried from v1"
  has_str references/state-file.md "Not a recap"
  has_str references/state-file.md "ask for both filenames"
}

check_advisors() {
  for n in 01-problem-discovery 02-customer-development 03-business-model \
           04-product-market-fit 05-product-management 06-metrics \
           07-traction-and-growth 08-founder-strategy 09-fundraising; do
    f="references/advisors/$n.md"
    has_file "$f"
    for h in "## When this module loads" "## The lens" "## Questions to ask, in order" \
             "## Red flags in the answer" "## The evidence this module accepts" \
             "## Output" "## Source lenses (internal)"; do
      has_str "$f" "$h"; done
    q=$(awk '/^## Questions to ask, in order/{f=1;next} /^## /{f=0} f&&/^[0-9-]/{c++} END{print c+0}' "$ROOT/$f" 2>/dev/null)
    [ "${q:-0}" -ge 6 ] && ok "$f has $q questions" || fail "$f has ${q:-0} questions, needs 6+"
  done
  for name in Fitzpatrick Alvarez Constable Christensen "Steve Blank" "Eric Ries" \
              Osterwalder Maurya "Dan Olsen" "Sean Ellis" Andreessen Cagan Perri \
              Biddle Croll Yoskovitz McClure Weinberg Balfour "Andrew Chen" \
              "Paul Graham" Ravikant Hoffman Feld; do
    grep -rqF "$name" "$ROOT/references/advisors/" 2>/dev/null \
      && ok "advisor mapped: $name" || fail "advisor not mapped anywhere: $name"
  done
}

check_phases() {
  for n in 00-intake 01-interrogation 02-fit-assessment 03-research 04-artifacts \
           05-verdict 06-mvp-blueprint 07-launch 08-positioning-and-pitch \
           09-pmf-checkin 10-scale; do
    f="phases/$n.md"
    has_file "$f"
    has_re  "$f" 'Pass gate:.*[0-9]'
    has_str "$f" "Next phase:"
    has_str "$f" "Modules:"
    lacks_re "$f" "$ADVISOR_NAMES"
    lacks_re "$f" "$BANNED_STACK"
    lacks_re "$f" "$RETIRED_MARKERS"
  done
  has_str phases/05-verdict.md "TALK TO MORE CUSTOMERS"
  has_str phases/05-verdict.md "can never reach"
  has_re  phases/05-verdict.md '^\| *0 *\|'
  has_str phases/01-interrogation.md "riskiest"
  has_str phases/06-mvp-blueprint.md "Lovable"
  has_str phases/06-mvp-blueprint.md "Built before"
  has_str phases/07-launch.md "product problem"
  has_str phases/08-positioning-and-pitch.md "never produce a valuation"
  has_str phases/08-positioning-and-pitch.md "raise-plan.md"
  has_str phases/09-pmf-checkin.md "very-disappointed survey"
  has_str phases/09-pmf-checkin.md "does not add up"
  has_str phases/09-pmf-checkin.md "waitlist is not usage"
  has_str phases/09-pmf-checkin.md "The kit is not a to-do list"
  has_str references/advisors/09-fundraising.md "dilution"
  has_str references/advisors/09-fundraising.md "comparable"
}

check_artifacts() {
  has_file references/artifacts-index.md
  has_str  references/artifacts-index.md "The filenames you write"
  has_str  references/artifacts-index.md "pmf-scorecard.md"
  has_str  references/artifacts-index.md "raise-plan.md"
  has_str  evals/rubric.md "Re-running the suite after a model update"
  has_str  references/artifacts/raise-plan.md "never produce a valuation"
  has_str  references/artifacts/raise-plan.md "Dilution"
  for a in lean-canvas mom-test-script pmf-survey positioning-statement \
           pitch-deck-outline one-pager cac-ltv-model experiment-card \
           market-research-brief naming-shortlist launch-plan \
           build-prompt-library growth-plan pmf-scorecard raise-plan; do
    f="references/artifacts/$a.md"
    has_file "$f"
    lacks_re "$f" "$ADVISOR_NAMES"
    lacks_re "$f" "$RETIRED_MARKERS"
    lacks_re "$f" "$BANNED_STACK"
  done
  for a in lean-canvas pmf-survey cac-ltv-model pitch-deck-outline one-pager \
           experiment-card market-research-brief growth-plan pmf-scorecard raise-plan; do
    has_str "references/artifacts/$a.md" "UNVERIFIED"
  done
}

check_skill() {
  has_file SKILL.md
  # The frontmatter must be valid YAML, not merely delimited. A colon followed
  # by a space inside an unquoted scalar silently terminates the value, which
  # would truncate the trigger description and is invisible to a behavioural
  # run, because a role-play reads the file as prose and never parses it.
  fm=$(awk 'NR==1&&/^---$/{f=1;next} f&&/^---$/{exit} f{print}' "$ROOT/SKILL.md" 2>/dev/null)
  if printf '%s' "$fm" | grep -qE '^description:.*: '; then
    fail "SKILL.md frontmatter has a colon-space inside the description, which breaks YAML parsing"
  else ok "SKILL.md description has no YAML-breaking colon"; fi
  if printf '%s' "$fm" | grep -qE '^name: *[a-z0-9-]+$'; then
    ok "SKILL.md name is a bare slug"
  else fail "SKILL.md name is missing or not a bare slug"; fi
  if [ -n "$PY" ] && "$PY" -c 'import yaml' 2>/dev/null; then
    if printf '%s' "$fm" | "$PY" -c 'import sys,yaml;d=yaml.safe_load(sys.stdin.read());assert isinstance(d,dict) and d.get("name") and d.get("description")' 2>/dev/null; then
      ok "SKILL.md frontmatter parses as YAML with name and description"
    else
      fail "SKILL.md frontmatter does not parse as YAML"
    fi
  else
    ok "SKILL.md YAML parse skipped (no interpreter with pyyaml); the colon check above still applies"
  fi
  n=$(wc -l < "$ROOT/SKILL.md" 2>/dev/null || echo 9999)
  n=${n:-9999}
  [ "$n" -lt 500 ] && ok "SKILL.md is $n lines (<500)" || fail "SKILL.md is $n lines, must be under 500"
  lacks_re SKILL.md "$ADVISOR_NAMES"
  lacks_re SKILL.md "$BANNED_STACK"
  lacks_re SKILL.md "$RETIRED_MARKERS"
  for v in $VERDICTS; do has_str SKILL.md "$v"; done
  has_str SKILL.md "TALK TO MORE CUSTOMERS"
  broken=0
  for p in $(grep -oE "${BT}(references|phases)/[a-z0-9./-]+\.md${BT}" "$ROOT/SKILL.md" 2>/dev/null | tr -d "$BT" | sort -u); do
    if [ -f "$ROOT/$p" ]; then ok "link resolves $p"; else fail "SKILL.md links missing $p"; broken=1; fi
  done
  [ "$broken" -eq 0 ] && ok "all SKILL.md links resolve"
}

check_plugin() {
  pkg_file .claude-plugin/plugin.json
  for _f in .claude-plugin/plugin.json .claude-plugin/marketplace.json; do
    [ -f "$PKG/$_f" ] || continue
    if [ -n "$PY" ]; then
      if "$PY" -c 'import json,sys;json.load(sys.stdin)' < "$PKG/$_f" 2>/dev/null; then
        ok "$_f is valid JSON"
      else fail "$_f is not valid JSON"; fi
    else ok "$_f JSON parse skipped (no interpreter found)"; fi
  done
  pkg_file .claude-plugin/marketplace.json
  pkg_str  .claude-plugin/plugin.json '"name": "startup-board-pro"'
  pkg_str  .claude-plugin/plugin.json '"version": "2.0.0"'
  pkg_str  CHANGELOG.md "2.0.0"
  pkg_lacks_re .claude-plugin/plugin.json "$ADVISOR_NAMES"
  pkg_lacks_re .claude-plugin/plugin.json "$BANNED_STACK"
  d1=$(sed -n 's/^description: *//p' "$ROOT/SKILL.md" 2>/dev/null | head -1 | cut -c1-60)
  if [ -n "$d1" ] && grep -qF "$d1" "$PKG/.claude-plugin/plugin.json" 2>/dev/null; then
    ok "plugin.json description matches SKILL.md frontmatter"
  else
    fail "plugin.json description does not match SKILL.md frontmatter"
  fi
}

# Sweeps that apply to whole directories, not one named file.
# These exist because three answer keys shipped demanding retired markers and
# the v1 filename, and nothing was looking at evals/criteria at all.
check_sweeps() {
  for f in "$ROOT"/references/*.md "$ROOT"/evals/criteria/*.md "$ROOT"/evals/rubric.md            ${SALES:+"$PKG/$SALES"} "$PKG"/dist/*.md "$PKG"/dist/launch/*.md; do
    [ -f "$f" ] || continue
    rel=${f#"$ROOT"/}; rel=${rel#"$PKG"/}
    # retired unverified markers, anywhere a founder or a grader can read them
    if grep -qE "$RETIRED_MARKERS" "$f" 2>/dev/null; then
      fail "$rel uses a retired marker: $(grep -oEm1 "$RETIRED_MARKERS" "$f")"
    else ok "$rel clean of retired markers"; fi
    # the v1 progress filename is allowed only where migration is the subject
    case "$rel" in
      references/state-file.md|evals/criteria/s02-*|evals/criteria/s03-*|evals/criteria/s04-*|dist/INSTALL.md|dist/CHANGELOG.md|dist/EDITION-SPLIT.md|README-PRO.md) ;;
      *)
        if grep -qF 'startup-board-progress.md' "$f" 2>/dev/null; then
          fail "$rel names the v1 progress file outside the migration path"
        else ok "$rel clean of the v1 filename"; fi ;;
    esac
    # v1 stage names were renamed; the keys must not ask for a string the skill never emits
    if grep -qE 'Problem Fit|Market Fit|Sales Fit|Research Fit|Product Fit|Customer Fit' "$f" 2>/dev/null; then
      fail "$rel uses a v1 stage name: $(grep -oEm1 'Problem Fit|Market Fit|Sales Fit|Research Fit|Product Fit|Customer Fit' "$f")"
    else ok "$rel clean of v1 stage names"; fi
  done
  # advisor names must not appear in anything shipped outside references/advisors
  for f in "$ROOT"/references/*.md ${SALES:+"$PKG/$SALES"} "$PKG"/dist/*.md "$PKG"/dist/launch/*.md; do
    [ -f "$f" ] || continue
    rel=${f#"$ROOT"/}; rel=${rel#"$PKG"/}
    if grep -qE "$ADVISOR_NAMES" "$f" 2>/dev/null; then
      fail "$rel names an advisor: $(grep -oEm1 "$ADVISOR_NAMES" "$f")"
    else ok "$rel names no advisor"; fi
  done
  # README-PRO links must resolve from where a buyer actually unpacks them
  if [ -n "$SALES" ]; then
    for lp in $(grep -oE "${BT}(evals|references|phases)/[a-zA-Z0-9./-]+${BT}|${BT}INSTALL\.md${BT}" "$PKG/$SALES" 2>/dev/null | tr -d "$BT" | sort -u); do
      if [ -f "$ROOT/$lp" ] || [ -f "$PKG/$lp" ]; then ok "$SALES link resolves: $lp"
      else fail "$SALES links missing $lp"; fi
    done
  fi

  # every rule of thumb carries its label at the point of use
  for f in "$ROOT"/references/fit-ladder.md "$ROOT"/phases/09-pmf-checkin.md "$ROOT"/phases/10-scale.md; do
    rel=${f#"$ROOT"/}
    n=$(grep -oE '\(rules? of thumb\)' "$f" 2>/dev/null | wc -l)
    [ "${n:-0}" -ge 3 ] && ok "$rel labels $n rules of thumb"       || fail "$rel labels only ${n:-0} rules of thumb, needs 3 or more inline"
    if grep -qE '\(rule of$' "$f" 2>/dev/null; then
      fail "$rel splits a (rule of thumb) label across a line break, so it is not greppable"
    else ok "$rel has no split rule-of-thumb label"; fi
  done
}

check_cases() {
  c=$(ls "$ROOT/evals/cases" 2>/dev/null | wc -l)
  k=$(ls "$ROOT/evals/criteria" 2>/dev/null | wc -l)
  [ "$c" -eq 20 ] && ok "20 cases" || fail "$c cases, expected 20"
  [ "$k" -eq 20 ] && ok "20 criteria" || fail "$k criteria, expected 20"
  for f in "$ROOT/evals/cases/"*.md; do
    [ -e "$f" ] || continue
    b=$(basename "$f")
    [ -f "$ROOT/evals/criteria/$b" ] && ok "criteria pair $b" || fail "no criteria for $b"
  done
}

# The installable zip for routes 1 and 2. It is a build artifact: gitignored,
# absent from a fresh clone and from a buyer's install, so an absent zip is a
# skip and a present one is asserted hard.
#
# Windows PowerShell 5.1 Compress-Archive stored 107 of 112 entries with "\"
# separators, against ZIP spec 4.4.17.1, which requires "/". Info-ZIP unzip
# silently repairs that on read and macOS Archive Utility does not: there it
# extracts one flat file named "references\fit-ladder.md", and every link in
# SKILL.md resolves to nothing. The original build verified the zip with
# PowerShell Expand-Archive, the same pair that wrote the bug, so the verify
# could never see it. Hence this group reads the stored names, not an extract.
# The Python fallback must read orig_filename: namelist() normalizes backslash to
# slash on read, which would repair the very defect this group exists to catch.
check_zip() {
  _zip="${1:-$PKG/dist/startup-board-pro.zip}"
  if [ ! -f "$_zip" ] && [ -n "${1:-}" ]; then
    fail "no zip at $_zip (an explicit path was given and does not exist)"
    return
  fi
  if [ ! -f "$_zip" ]; then
    ok "no zip at dist/startup-board-pro.zip (build artifact; run sh build-zip.sh (from the repo root) to make one)"
    return
  fi
  _names=""
  if command -v unzip >/dev/null 2>&1; then
    _names=$(unzip -Z1 "$_zip" 2>/dev/null)
  fi
  if [ -z "$_names" ] && [ -n "$PY" ]; then
    _names=$("$PY" -c 'import sys,zipfile;print("\n".join(i.orig_filename for i in zipfile.ZipFile(sys.argv[1]).infolist()))' "$_zip" 2>/dev/null | tr -d '\r')
  fi
  if [ -z "$_names" ]; then
    fail "cannot read zip entry names from $_zip (no unzip and no working interpreter, or the archive is corrupt)"
    return
  fi

  _bs=$(printf '%s\n' "$_names" | grep -c '[\]' || true)
  if [ "$_bs" -eq 0 ]; then
    ok "zip stores no backslash path separators"
  else
    fail "zip stores $_bs entries with backslash separators (ZIP spec 4.4.17.1 requires /); rebuild with sh build-zip.sh (from the repo root)"
  fi

  # Entries ending in / are directory records. bsdtar writes them and
  # Compress-Archive did not, so compare files only.
  _zip_files=$(printf '%s\n' "$_names" | sed 's|\\|/|g' | grep -v '/$' | LC_ALL=C sort)
  _src_files=$(cd "$ROOT" && find . -type f -not -path './dist/*' -not -name AUDIT.md | sed 's|^\./||' | LC_ALL=C sort)
  if [ "$_zip_files" = "$_src_files" ]; then
    ok "zip payload matches the source tree ($(printf '%s\n' "$_src_files" | grep -c .) files, nothing missing, nothing extra)"
  else
    fail "zip payload differs from the source tree; rebuild with sh build-zip.sh (from the repo root)"
    printf '%s\n' "$_src_files" > "${TMPDIR:-/tmp}/sbp-src.$$"
    printf '%s\n' "$_zip_files" > "${TMPDIR:-/tmp}/sbp-zip.$$"
    diff "${TMPDIR:-/tmp}/sbp-src.$$" "${TMPDIR:-/tmp}/sbp-zip.$$" | sed 's/^/      /'
    rm -f "${TMPDIR:-/tmp}/sbp-src.$$" "${TMPDIR:-/tmp}/sbp-zip.$$"
  fi

  # Names alone cannot see a stale archive: a payload file edited after the
  # build keeps its name. Extract to a scratch dir outside the repo and diff
  # the contents against the source tree.
  _tmp=""; _ex=""
  if command -v unzip >/dev/null 2>&1; then
    _tmp=$(mktemp -d "${TMPDIR:-/tmp}/sbp-ex.XXXXXX" 2>/dev/null) && unzip -q "$_zip" -d "$_tmp" >/dev/null 2>&1 && _ex="$_tmp"
  elif [ -n "$PY" ]; then
    _tmp=$(mktemp -d "${TMPDIR:-/tmp}/sbp-ex.XXXXXX" 2>/dev/null) && "$PY" -c 'import sys,zipfile;zipfile.ZipFile(sys.argv[1]).extractall(sys.argv[2])' "$_zip" "$_tmp" >/dev/null 2>&1 && _ex="$_tmp"
  fi
  if [ -n "$_ex" ]; then
    _drift=$(diff -r -x dist -x AUDIT.md "$ROOT" "$_ex" 2>&1)
    if [ -z "$_drift" ]; then
      ok "zip contents are identical to the source tree"
    else
      fail "zip contents differ from the source tree (stale archive?); rebuild with sh build-zip.sh (from the repo root)"
      printf '%s\n' "$_drift" | sed 's/^/      /'
    fi
  elif command -v unzip >/dev/null 2>&1 || [ -n "$PY" ]; then
    fail "could not extract $_zip to compare its contents against the source tree"
  else
    ok "zip content comparison skipped (no unzip, no working interpreter): file names were checked, file contents were NOT"
  fi
  [ -n "$_tmp" ] && rm -rf "$_tmp"

  for _x in AUDIT.md dist/ _reference/ .git/; do
    if printf '%s\n' "$_zip_files" | grep -q "^$(printf '%s' "$_x" | sed 's/[.]/[.]/g')"; then
      fail "zip leaks $_x"
    else
      ok "zip excludes $_x"
    fi
  done

  if command -v unzip >/dev/null 2>&1; then
    if unzip -p "$_zip" SKILL.md 2>/dev/null | head -1 | grep -q '^---'; then
      ok "zip SKILL.md opens with a frontmatter fence"
    else
      fail "zip SKILL.md has no opening frontmatter fence"
    fi
  else
    ok "zip SKILL.md frontmatter check skipped (no unzip found)"
  fi
}

case "${1:-all}" in
  contract)  check_contract ;;
  state)     check_state ;;
  advisors)  check_advisors ;;
  phases)    check_phases ;;
  artifacts) check_artifacts ;;
  skill)     check_skill ;;
  plugin)    check_plugin ;;
  sweeps)    check_sweeps ;;
  cases)     check_cases ;;
  zip)       check_zip "${2:-}" ;;
  all) check_contract; check_state; check_advisors; check_phases
       check_artifacts; check_skill; check_plugin; check_sweeps; check_cases
       check_zip ;;
  *) echo "usage: $0 <contract|state|advisors|phases|artifacts|skill|plugin|sweeps|cases|zip|all>"; exit 2 ;;
esac

[ "$FAIL" -eq 0 ] && echo "PASS" || echo "FAILED"
exit "$FAIL"
