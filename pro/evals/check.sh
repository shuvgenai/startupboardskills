#!/usr/bin/env sh
# Startup Board Pro static checks.
# Usage: evals/check.sh <contract|state|advisors|phases|artifacts|skill|plugin|cases|all>
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FAIL=0
BT=$(printf '\140')
fail() { echo "FAIL: $*"; FAIL=1; }
ok()   { echo "ok:   $*"; }

ADVISOR_NAMES='Fitzpatrick|Alvarez|Constable|Christensen|Steve Blank|Eric Ries|Osterwalder|Maurya|Dan Olsen|Sean Ellis|Andreessen|Cagan|Perri|Biddle|Croll|Yoskovitz|McClure|Weinberg|Balfour|Andrew Chen|Paul Graham|Ravikant|Hoffman|Feld'
BANNED_STACK='n8n|Supabase|Zapier|Make\.com|Integromat'
RETIRED_MARKERS='assumption — untested|estimate, unverified|Real or estimated'
VERDICTS='PROCEED PIVOT KILL'

has_file() { [ -f "$ROOT/$1" ] && ok "exists $1" || fail "missing $1"; }
has_str()  { grep -qF "$2" "$ROOT/$1" 2>/dev/null && ok "$1 has: $2" || fail "$1 missing: $2"; }
has_re()   { grep -qE "$2" "$ROOT/$1" 2>/dev/null && ok "$1 matches: $2" || fail "$1 missing pattern: $2"; }
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
  has_str phases/09-pmf-checkin.md "very-disappointed survey"
  has_str phases/09-pmf-checkin.md "does not add up"
  has_str phases/09-pmf-checkin.md "waitlist is not usage"
  has_str phases/09-pmf-checkin.md "The kit is not a to-do list"
}

check_artifacts() {
  has_file references/artifacts-index.md
  has_str  references/artifacts-index.md "The filenames you write"
  has_str  references/artifacts-index.md "pmf-scorecard.md"
  for a in lean-canvas mom-test-script pmf-survey positioning-statement \
           pitch-deck-outline one-pager cac-ltv-model experiment-card \
           market-research-brief naming-shortlist launch-plan \
           build-prompt-library growth-plan pmf-scorecard; do
    f="references/artifacts/$a.md"
    has_file "$f"
    lacks_re "$f" "$ADVISOR_NAMES"
    lacks_re "$f" "$RETIRED_MARKERS"
    lacks_re "$f" "$BANNED_STACK"
  done
  for a in lean-canvas pmf-survey cac-ltv-model pitch-deck-outline one-pager \
           experiment-card market-research-brief growth-plan pmf-scorecard; do
    has_str "references/artifacts/$a.md" "UNVERIFIED"
  done
}

check_skill() {
  has_file SKILL.md
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
  has_file .claude-plugin/plugin.json
  has_file .claude-plugin/marketplace.json
  has_str  .claude-plugin/plugin.json '"name": "startup-board-pro"'
  has_str  .claude-plugin/plugin.json '"version": "2.0.0"'
  has_str  CHANGELOG.md "2.0.0"
  lacks_re .claude-plugin/plugin.json "$ADVISOR_NAMES"
  lacks_re .claude-plugin/plugin.json "$BANNED_STACK"
  d1=$(sed -n 's/^description: *//p' "$ROOT/SKILL.md" 2>/dev/null | head -1 | cut -c1-60)
  if [ -n "$d1" ] && grep -qF "$d1" "$ROOT/.claude-plugin/plugin.json" 2>/dev/null; then
    ok "plugin.json description matches SKILL.md frontmatter"
  else
    fail "plugin.json description does not match SKILL.md frontmatter"
  fi
}

check_cases() {
  c=$(ls "$ROOT/evals/cases" 2>/dev/null | wc -l)
  k=$(ls "$ROOT/evals/criteria" 2>/dev/null | wc -l)
  [ "$c" -eq 15 ] && ok "15 cases" || fail "$c cases, expected 15"
  [ "$k" -eq 15 ] && ok "15 criteria" || fail "$k criteria, expected 15"
  for f in "$ROOT/evals/cases/"*.md; do
    [ -e "$f" ] || continue
    b=$(basename "$f")
    [ -f "$ROOT/evals/criteria/$b" ] && ok "criteria pair $b" || fail "no criteria for $b"
  done
}

case "${1:-all}" in
  contract)  check_contract ;;
  state)     check_state ;;
  advisors)  check_advisors ;;
  phases)    check_phases ;;
  artifacts) check_artifacts ;;
  skill)     check_skill ;;
  plugin)    check_plugin ;;
  cases)     check_cases ;;
  all) check_contract; check_state; check_advisors; check_phases
       check_artifacts; check_skill; check_plugin; check_cases ;;
  *) echo "usage: $0 <contract|state|advisors|phases|artifacts|skill|plugin|cases|all>"; exit 2 ;;
esac

[ "$FAIL" -eq 0 ] && echo "PASS" || echo "FAILED"
exit "$FAIL"
