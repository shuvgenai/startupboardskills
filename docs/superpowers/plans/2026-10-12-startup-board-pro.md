# Startup Board Pro Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild Startup Board v1 as a sellable, 24-advisor, evidence-gated founder operating system in `pro/`, with a test harness that can actually fail.

**Architecture:** A small router (`SKILL.md`, under 500 lines) that loads progressively from three reference stores — `references/` for the laws (contract, rubric, ladder, state), `references/advisors/` for nine internal question-generating modules, `references/artifacts/` for templates — plus eleven `phases/` files each carrying a numeric evidence gate. Durable session state lives in a founder-side `startup-board-state.md`. Two test layers: `evals/check.sh` for mechanical constraints, 15 blind-graded role-play cases for behaviour.

**Tech Stack:** Markdown only. Tests are POSIX `sh` with `grep`/`wc` (run via the Bash tool on this Windows machine), plus Agent-tool subagents for role-play grading. No runtime, no dependencies, nothing for a buyer to install beyond copying a folder.

**Spec:** `docs/superpowers/specs/2026-10-12-startup-board-pro-design.md`

## Global Constraints

Copied verbatim from the spec, section 4. Every task's requirements implicitly include these.

- `SKILL.md` is **under 500 lines**.
- No advisor's name appears in `SKILL.md`, `phases/`, `references/artifacts/`, or any file a founder sees. Names live **only** in `references/advisors/*.md` under `## Source lenses (internal)`.
- **No invented numbers.** A number appears only if the founder gave it, a source URL backs it, or it is labelled `(rule of thumb)` at the point of use.
- **One unverified marker**: the literal string `UNVERIFIED`. The strings `assumption — untested`, `estimate, unverified` and `Real or estimated` are retired and must not appear.
- **Banned from all stack guidance**: `n8n`, `Supabase`, `Zapier`, `Make.com`, `Integromat`.
- **One question per turn.** Never a numbered or bulleted list of questions. A founder who volunteers several answers at once is accepted and not re-asked.
- **Answer ceiling 200 words** unless the founder asked for an artifact.
- **Four verdicts, exact strings**: `PROCEED`, `PIVOT`, `TALK TO MORE CUSTOMERS`, `KILL`.
- **State edits are append-and-amend.** A past entry is struck and dated, never silently rewritten.
- Every phase file states a **numeric pass gate**.
- Every build step ships a **copy-paste prompt**, never "hire someone".
- The method v1 calls the "Sean Ellis test" is renamed **the very-disappointed survey** in every founder-facing file. The name survives only in `references/advisors/04-product-market-fit.md`.
- Git: one commit per task, `task N` in the message. **Never** run `git remote add` for any URL containing `startup-board`. `_reference/` is read-only and gitignored.

## Review Focus

Five input classes the spec implies, that no task's main deliverable exercises, ordered by how badly they bite a real founder. Each has its test pinned to the task that owns the code.

1. **A founder pastes a v1 `startup-board-progress.md`.** Expected: its rows are carried into `startup-board-state.md`, the v1 file is left untouched on disk, and the founder is told in one line. Silently ignoring it loses their history; overwriting it destroys it. — tested in Task 3, case `s02`.
2. **A founder answers three questions in one turn, unprompted.** Expected: all three are accepted and none is re-asked. "One question per turn" governs the advisor's pacing, not the founder's. — tested in Task 2.
3. **A founder reports numbers that cannot all be true** (survey percentages over 100, more responses than active users, a cohort that grows). Expected: name exactly what does not add up, ask one question, never silently repair. — tested in Task 8, case `s09`.
4. **A founder demands a verdict on turn one with zero evidence.** Expected: a verdict is still given, and it is `TALK TO MORE CUSTOMERS` — never `PROCEED`, because score 0 cannot reach it. Refusing to answer is also a failure. — tested in Task 7.
5. **A founder with zero active users asks whether they have product-market fit.** Expected: the only hard refusal in the product. Explain there is nothing to measure, return them to their real stage, give one action. — tested in Task 8, case `s08`.

---

## File Structure

| File | Responsibility |
|---|---|
| `pro/SKILL.md` | Router only: frontmatter triggers, the contract in brief, the phase map, pointers. Under 500 lines. |
| `pro/references/conversation-contract.md` | How it talks. Hard rules, not style notes. |
| `pro/references/evidence-rubric.md` | The 0–3 score and what each level means. |
| `pro/references/fit-ladder.md` | Six stages, each with a numeric pass condition. |
| `pro/references/state-file.md` | `startup-board-state.md` shape, the three loops, v1 migration. |
| `pro/references/artifacts-index.md` | Which artifact, when, at what score, in what format. |
| `pro/references/advisors/01..09` | Nine question-generating modules, one fixed shape. |
| `pro/references/artifacts/*` | 14 templates. |
| `pro/phases/00..10` | One file per phase: purpose, modules, entry condition, questions, artifact, numeric gate, next phase. |
| `pro/evals/check.sh` | Mechanical constraint checks, grouped. The thing that goes red first. |
| `pro/evals/rubric.md` | I1–I10 and how a run is scored. |
| `pro/evals/RUNBOOK.md` | Exact commands to run and record a case. |
| `pro/evals/cases/*` | 15 fixtures. |
| `pro/evals/criteria/*` | 15 answer keys. Separate folder so the advisor under test cannot read them. |
| `pro/.claude-plugin/plugin.json` | Plugin manifest, so Claude Code can install Pro with `/plugin`. |
| `pro/.claude-plugin/marketplace.json` | Marketplace listing the manifest is served from. |
| `pro/dist/*` | INSTALL.md, CHANGELOG.md, launch assets, EDITION-SPLIT.md. |

**A note on what "implementation" means here.** The deliverables are Markdown instructions, not functions. So each content task's implementation step gives the **fixed shape** (exact headings, in order), the **source material** (which `_reference/` file and which advisor lenses it draws on), and the **assertions that must pass**. The assertions are the contract — they are what makes a vague file fail. Transcribing forty finished Markdown files into this plan would duplicate the product; pinning their shape and their checks does not.

---

## Task 1: The static checker

Builds the thing that goes red, before any content exists.

**Files:**
- Create: `pro/evals/check.sh`
- Create: `pro/evals/rubric.md`
- Create: `pro/evals/RUNBOOK.md`

**Interfaces:**
- Consumes: nothing.
- Produces: `evals/check.sh <group>` where group is one of `contract state advisors phases artifacts skill cases all`. Exit 0 = all assertions in the group hold; exit 1 = at least one failed, with every failure printed as `FAIL: <reason>`. Every later task runs its own group.

- [ ] **Step 1: Write the failing test — `pro/evals/check.sh`**

```sh
#!/usr/bin/env sh
# Startup Board Pro static checks.
# Usage: evals/check.sh <contract|state|advisors|phases|artifacts|skill|plugin|cases|all>
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FAIL=0
fail() { echo "FAIL: $*"; FAIL=1; }
ok()   { echo "ok:   $*"; }

ADVISOR_NAMES='Fitzpatrick|Alvarez|Constable|Christensen|Steve Blank|Eric Ries|Osterwalder|Maurya|Dan Olsen|Sean Ellis|Andreessen|Cagan|Perri|Biddle|Croll|Yoskovitz|McClure|Weinberg|Balfour|Andrew Chen|Paul Graham|Ravikant|Hoffman|Feld'
BANNED_STACK='n8n|Supabase|Zapier|Make\.com|Integromat'
RETIRED_MARKERS='assumption — untested|estimate, unverified|Real or estimated'
VERDICTS='PROCEED PIVOT KILL'

has_file() { [ -f "$ROOT/$1" ] && ok "exists $1" || fail "missing $1"; }
has_str()  { grep -qF "$2" "$ROOT/$1" 2>/dev/null && ok "$1 contains '$2'" || fail "$1 missing '$2'"; }
has_re()   { grep -qE "$2" "$ROOT/$1" 2>/dev/null && ok "$1 matches /$2/" || fail "$1 missing /$2/"; }
lacks_re() {
  if [ -f "$ROOT/$1" ] && grep -qE "$2" "$ROOT/$1" 2>/dev/null; then
    fail "$1 contains banned /$2/: $(grep -oEm1 "$2" "$ROOT/$1")"
  else ok "$1 clean of /$2/"; fi
}

check_contract() {
  has_file references/conversation-contract.md
  has_str  references/conversation-contract.md "One question per turn"
  has_str  references/conversation-contract.md "200 words"
  has_str  references/conversation-contract.md "Never compliment"
  for v in $VERDICTS; do has_str references/conversation-contract.md "$v"; done
  has_str  references/conversation-contract.md "TALK TO MORE CUSTOMERS"
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
  has_str phases/06-mvp-blueprint.md "Lovable"
  has_str phases/09-pmf-checkin.md "very-disappointed survey"
}

check_artifacts() {
  has_file references/artifacts-index.md
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
  [ "$n" -lt 500 ] && ok "SKILL.md is $n lines (<500)" || fail "SKILL.md is $n lines, must be under 500"
  lacks_re SKILL.md "$ADVISOR_NAMES"
  lacks_re SKILL.md "$BANNED_STACK"
  lacks_re SKILL.md "$RETIRED_MARKERS"
  for v in $VERDICTS; do has_str SKILL.md "$v"; done
  has_str SKILL.md "TALK TO MORE CUSTOMERS"
  # every referenced path resolves
  broken=0
  for p in $(grep -oE '`(references|phases)/[a-z0-9./-]+\.md`' "$ROOT/SKILL.md" 2>/dev/null | tr -d '`' | sort -u); do
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
  # the manifest description must match the SKILL.md frontmatter description
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
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `sh pro/evals/check.sh all`
Expected: FAILED, exit 1, with `FAIL: missing references/conversation-contract.md` among the first lines. Everything is absent, so everything should fail. A PASS here means the checker is not checking.

- [ ] **Step 3: Write `pro/evals/rubric.md`**

Content contract — the file must carry, verbatim as list items, invariants I1 through I10 from spec section 12, and for each one a line naming what a failure looks like in a transcript. Then a scoring block: a run is PASS only if all ten hold; any failure records the invariant id and a short quote from the reply. Then this rule, stated plainly: **the advisor under test never sees `evals/criteria/`, the spec, or this rubric** — a reply shaped by the answer key proves nothing.

- [ ] **Step 4: Write `pro/evals/RUNBOOK.md`**

Content contract — exact commands, copy-pasteable:

```
Static:      sh pro/evals/check.sh all
One group:   sh pro/evals/check.sh phases
One case:    dispatch an Agent, subagent_type general-purpose, model sonnet,
             with the Advisor prompt below, <SCENARIO FILE> replaced by the
             absolute path of one file in pro/evals/cases/
Record:      append a row to pro/evals/results-YYYY-MM-DD.md:
             | case | PASS/FAIL | failed invariants | quote |
```

Plus the Advisor prompt, carried from `_reference/tests/scenarios/README.md` and amended: the skill path becomes `pro/`, the readable-files allowlist becomes `pro/SKILL.md`, `pro/references/**`, `pro/phases/**` and the one scenario file, and the forbidden list names `pro/evals/criteria/`, the spec and the plan.

- [ ] **Step 5: Run the checker again to confirm it still fails for the right reason**

Run: `sh pro/evals/check.sh contract`
Expected: FAILED — `conversation-contract.md` is still absent. The two new files are documentation, not content, so nothing should have gone green.

- [ ] **Step 6: Commit**

```bash
cd /e/Projects/Startupboards_SKills/Startupboardskills_pro
git add pro/evals/check.sh pro/evals/rubric.md pro/evals/RUNBOOK.md pro/AUDIT.md .gitignore docs
git commit -m "task 1: static checker, eval rubric and runbook"
```

---

## Task 2: The three laws — contract, rubric, ladder

**Files:**
- Create: `pro/references/conversation-contract.md`
- Create: `pro/references/evidence-rubric.md`
- Create: `pro/references/fit-ladder.md`
- Source: `_reference/skills/startup-board/references/fit-framework.md` (pass tests carry over), `_reference/skills/startup-board/SKILL.md` (the one-question rule)

**Interfaces:**
- Consumes: `evals/check.sh contract` from Task 1.
- Produces: the strings every later file cites — `references/evidence-rubric.md` scores `0`/`1`/`2`/`3`; `references/fit-ladder.md` stage names `Problem` `Research` `Product` `Customer` `Market` `Sales`; `references/conversation-contract.md` verdict strings `PROCEED` `PIVOT` `TALK TO MORE CUSTOMERS` `KILL`. Later tasks must use these spellings exactly.

- [ ] **Step 1: Run the group to confirm red**

Run: `sh pro/evals/check.sh contract`
Expected: FAILED — all three files missing.

- [ ] **Step 2: Write `pro/references/evidence-rubric.md`**

Content contract. A markdown table whose first column is the bare score so `^\| *0 *\|` matches:

```
| Score | Name | What counts | What does not |
|---|---|---|---|
| 0 | Opinion | ... | ... |
| 1 | Secondhand | ... | ... |
| 2 | Primary | ... | ... |
| 3 | Behavioural | ... | ... |
```

Then, mandatory, three rules in prose:
1. **A compliment scores 0 no matter how many people gave it.** "Ten people said they'd use it" is one score-0 claim repeated ten times. Name it as a compliment to the founder, do not count it.
2. A hypothetical scores 0. Only a described **past behaviour** reaches 2.
3. Score the claim, not the founder's confidence. Write the score into the assumption ledger with the claim.

Then a worked example of each level drawn from a service business, using no invented numbers.

- [ ] **Step 3: Write `pro/references/fit-ladder.md`**

Content contract. Six stages in order, each with: one sentence on what the stage means, a `**Pass condition:**` line stating the numbers from spec section 6, and a `**Minimum evidence score:**` line. Carry v1's warn-then-allow rule verbatim in substance, with the stamp string now `> Built before <Stage> was passed. Missing: <evidence>.` State that every number on the page is a `(rule of thumb)` and must be labelled as one when spoken aloud, and that the bar adjusts out loud when the segment is genuinely small.

- [ ] **Step 4: Write `pro/references/conversation-contract.md`**

Content contract. Hard rules, each as its own list item, including all of these literal strings so the checker passes: `One question per turn`, `200 words`, `Never compliment`, `PROCEED`, `PIVOT`, `TALK TO MORE CUSTOMERS`, `KILL`.

Rules to state:
- One question per turn, boxed. Never a numbered or bulleted list of questions.
- **Review Focus 2:** the ceiling is on *your* pacing, not the founder's. If the founder answers three things at once, accept all three and re-ask none of them. Re-asking something already answered is a failure.
- React before asking: name what the answer tells you, or what it dodged.
- Never compliment an idea. Banned openers, listed verbatim: `great question`, `great idea`, `love this`, `strong insight`, `that's a smart`. Acknowledge the **answer**, never praise the **idea**.
- An opinion presented as fact gets named as one, followed by one question about what it rests on.
- On a verdict request: one of the four exact strings, the single riskiest untested assumption, one action for this week. Never a fifth verdict, never a refusal to answer.
- Never produce an artifact the founder has not earned. Below the phase's required score: say what is missing, name the test that would produce it, offer the test instead of the deliverable.
- 200-word ceiling unless an artifact was requested.

- [ ] **Step 5: Run the group to confirm green**

Run: `sh pro/evals/check.sh contract`
Expected: PASS, exit 0.

- [ ] **Step 6: Add the Review Focus 2 regression assertion**

Append to `check_contract()` in `pro/evals/check.sh`:

```sh
  has_str references/conversation-contract.md "accept all three"
  has_str references/conversation-contract.md "re-ask"
```

Run: `sh pro/evals/check.sh contract`
Expected: PASS. If it fails, the multi-answer rule was written in different words — rewrite the rule to use these, do not weaken the assertion.

- [ ] **Step 7: Commit**

```bash
git add pro/references/conversation-contract.md pro/references/evidence-rubric.md pro/references/fit-ladder.md pro/evals/check.sh
git commit -m "task 2: conversation contract, evidence rubric, fit ladder"
```

---

## Task 3: State file and the three loops

**Files:**
- Create: `pro/references/state-file.md`
- Source: `_reference/skills/startup-board/references/output-documents.md` (the v1 progress-file format being migrated from)

**Interfaces:**
- Consumes: score names from `references/evidence-rubric.md`, stage names from `references/fit-ladder.md`.
- Produces: the eight section headings (`## Venture`, `## Fit ladder`, `## Assumption ledger`, `## Evidence log`, `## Numbers`, `## Decisions`, `## Open loops`, `## Calibration`) and the assumption-id convention `A1`, `A2`, … which the evidence log and phase files reference.

- [ ] **Step 1: Run the group to confirm red**

Run: `sh pro/evals/check.sh state`
Expected: FAILED — file missing.

- [ ] **Step 2: Write `pro/references/state-file.md`**

Content contract. Opens with the filename `startup-board-state.md` and where it lives. Then the full template, exactly these eight sections in this order, with the tables:

```
## Venture
one line, founder, stage, last session date

## Fit ladder
| stage | status | evidence score | what would move it up |

## Assumption ledger
| id | assumption | riskiest? | test designed | test run | result | score |

## Evidence log
| date | source type | who | what they said or did | score | assumption id |

## Numbers
| metric | value | as-of date | how it was measured | verified? |

## Decisions
| date | decision | what it was based on | revisit when |

## Open loops
- [ ] carried into next session

## Calibration
```

Then the three loops as named rules, carrying the literal strings `OPEN LOOP`, `CLOSE LOOP`, `CALIBRATION LOOP`:
- **OPEN LOOP** — every session opens by asking about exactly one unresolved assumption or one unrun test from the ledger. Not a recap. State the banned opening explicitly: a summary of last session.
- **CLOSE LOOP** — a reported result is scored against the rubric, written to the ledger and the evidence log, and answered with one sentence on whether the ladder moved.
- **CALIBRATION LOOP** — when later evidence overturns a verdict, append a dated line to `## Calibration`: what was believed, what happened, which question would have caught it sooner.

Then the edit discipline, carrying the literal string `append-and-amend`: a past row is never silently rewritten. A correction strikes the old value and dates it. Founder edits win: if the file disagrees with what you last wrote, trust the file.

Then the **Review Focus 1** migration rule, carrying the literal string `startup-board-progress.md`:
- On finding `startup-board-progress.md` with no `startup-board-state.md`: read it, carry its evidence-log rows into `## Evidence log`, its stage into `## Fit ladder`, its riskiest assumption into `## Assumption ledger` as `A1`, its next action into `## Open loops`, score every carried row against the rubric and mark any unscoreable row `score: unknown (carried from v1)`.
- Write `startup-board-state.md`. **Leave `startup-board-progress.md` untouched on disk.** Tell the founder in one line that their history carried over and where the new file is.
- Never ignore a v1 file. Never overwrite one. Never claim to remember a past session without a file in front of you.

- [ ] **Step 3: Run the group to confirm green**

Run: `sh pro/evals/check.sh state`
Expected: PASS.

- [ ] **Step 4: Add the Review Focus 1 regression assertions**

Append to `check_state()`:

```sh
  has_str references/state-file.md "untouched on disk"
  has_str references/state-file.md "carried from v1"
  has_str references/state-file.md "Not a recap"
```

Run: `sh pro/evals/check.sh state`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add pro/references/state-file.md pro/evals/check.sh
git commit -m "task 3: state file, three loops, v1 progress-file migration"
```

---

## Task 4: Advisor modules 01–03 (pre-launch)

**Files:**
- Create: `pro/references/advisors/01-problem-discovery.md`
- Create: `pro/references/advisors/02-customer-development.md`
- Create: `pro/references/advisors/03-business-model.md`
- Source: `_reference/skills/startup-board/references/board-members.md`, `interview-questions.md`, `lean-canvas.md`

**Interfaces:**
- Consumes: score names from `references/evidence-rubric.md`.
- Produces: module ids `01`, `02`, `03` cited by `Modules:` lines in `phases/00`–`phases/05`; artifact names `mom-test-script`, `lean-canvas`, `experiment-card` cited in each module's `## Output`.

- [ ] **Step 1: Run the group to confirm red**

Run: `sh pro/evals/check.sh advisors`
Expected: FAILED — nine files missing, 24 names unmapped.

- [ ] **Step 2: Write the three modules to the fixed shape**

Exactly these seven headings, in this order, no others:

```
# <Module name>
## When this module loads
## The lens
## Questions to ask, in order
## Red flags in the answer
## The evidence this module accepts
## Output
## Source lenses (internal)
```

Per-section contract, applying to every module in Tasks 4, 5 and 6:
- **When this module loads** — the founder statements or phases that pull it in. Statements in the founder's own words, not jargon.
- **The lens** — 4 to 8 sentences on how this school of thought reframes the situation.
- **Questions to ask, in order** — 6 to 12 numbered questions, each one sentence, each answerable by a founder in two minutes. The checker counts these; fewer than 6 fails.
- **Red flags in the answer** — what a weak answer sounds like, as verbatim example quotes.
- **The evidence this module accepts** — what counts as proof, scored against `references/evidence-rubric.md`, naming the minimum score this module's questions are trying to reach.
- **Output** — the artifact it can produce, as a path under `references/artifacts/`.
- **Source lenses (internal)** — the named thinkers, and the line: *never cited, quoted or credited to the founder.*

Module content:
- **01 Problem discovery** — lenses Fitzpatrick, Alvarez, Constable, Christensen. Forcing questions: what did you do the last time this happened; who is already paying to solve this badly; did you hear a story or an opinion; what job is this hired for and what gets fired. Output `mom-test-script`.
- **02 Customer development** — lenses Steve Blank, Eric Ries. Forcing questions: which of these facts came from outside the building; what is the smallest test that could prove you wrong this week. Output `experiment-card`.
- **03 Business model** — lenses Osterwalder, Maurya. Forcing questions: does the model hold together or is one block carrying all of it; which box is riskiest and why is it not being tested first. Output `lean-canvas`. Carry v1's genuine Maurya-versus-Fitzpatrick tension (draft the canvas fast from guesses, versus a canvas drafted early becomes something to defend) as a tension to surface to the founder in the advisor's own voice.

- [ ] **Step 3: Run the group — expect partial**

Run: `sh pro/evals/check.sh advisors`
Expected: FAILED, but the failures must now be only `missing references/advisors/04..09` and the names belonging to modules 04–09. Every assertion about 01, 02, 03 and their 8 names must read `ok:`. If a shape assertion for 01–03 still fails, the headings are wrong — fix them now, before 04–09 copy the mistake.

- [ ] **Step 4: Commit**

```bash
git add pro/references/advisors
git commit -m "task 4: advisor modules 01-03, problem through business model"
```

---

## Task 5: Advisor modules 04–06 (the launched founder)

**Files:**
- Create: `pro/references/advisors/04-product-market-fit.md`
- Create: `pro/references/advisors/05-product-management.md`
- Create: `pro/references/advisors/06-metrics.md`
- Source: `_reference/skills/startup-board/references/pmf-checkin.md`, `board-members.md` (Croll, Yoskovitz, McClure)

**Interfaces:**
- Consumes: the fixed shape proven in Task 4; `references/evidence-rubric.md`.
- Produces: module ids `04`, `05`, `06` cited by `phases/09`; artifact names `pmf-survey`, `pmf-scorecard`.

- [ ] **Step 1: Confirm 01–03 still green**

Run: `sh pro/evals/check.sh advisors`
Expected: FAILED overall, with every 01–03 assertion `ok:`. This is the baseline for this task.

- [ ] **Step 2: Write the three modules to the same fixed shape**

- **04 Product-market fit** — lenses Dan Olsen, Sean Ellis, Andreessen. Forcing questions: which underserved need does this feature set actually hit; how many users would be very disappointed if it vanished; is the market pulling this out of you or are you pushing. Output `pmf-survey`. **This is the only file in the product where the name `Sean Ellis` may appear**; its `## Questions` and `## Output` sections must call the instrument *the very-disappointed survey*.
- **05 Product management** — lenses Cagan, Perri, Biddle. Forcing questions: is there a discovery loop or just a build queue; what outcome does this roadmap item change; is it hard to copy and does it improve with scale. Output `experiment-card`.
- **06 Metrics** — lenses Croll, Yoskovitz, McClure. Forcing questions: what is the one metric that matters at this stage; what line did you draw before you looked at the number; which of the five funnel stages is actually leaking. Output `pmf-scorecard`. Carry v1's vanity-metric flag (downloads, pageviews, signups with no activation).

- [ ] **Step 3: Run the group — expect only 07–09 failing**

Run: `sh pro/evals/check.sh advisors`
Expected: FAILED, failures confined to `07-traction-and-growth`, `08-founder-strategy`, `09-fundraising` and their names.

- [ ] **Step 4: Commit**

```bash
git add pro/references/advisors
git commit -m "task 5: advisor modules 04-06, fit through metrics"
```

---

## Task 6: Advisor modules 07–09 (growth, strategy, money)

**Files:**
- Create: `pro/references/advisors/07-traction-and-growth.md`
- Create: `pro/references/advisors/08-founder-strategy.md`
- Create: `pro/references/advisors/09-fundraising.md`
- Source: `_reference/skills/startup-board/references/scale-growth.md`, `gtm-launch.md`, `pitch-fundraising.md`

**Interfaces:**
- Consumes: the fixed shape; `references/evidence-rubric.md`.
- Produces: module ids `07`, `08`, `09` cited by `phases/07`, `08`, `10`; artifact names `launch-plan`, `cac-ltv-model`, `growth-plan`, `pitch-deck-outline`, `one-pager`.

- [ ] **Step 1: Confirm the baseline**

Run: `sh pro/evals/check.sh advisors`
Expected: FAILED, confined to 07–09.

- [ ] **Step 2: Write the three modules to the same fixed shape**

- **07 Traction and growth** — lenses Weinberg, Balfour, Andrew Chen. Forcing questions: which channels have you tested, not just considered; do model, channel, product and market fit each other; what happens when this channel saturates. Output `growth-plan`, with `cac-ltv-model` named for the unit-economics question. Carry v1's AARRR break-point routing: a problem at activation or retention is a product problem, and more acquisition only increases churn volume.
- **08 Founder strategy** — lenses Paul Graham, Ravikant, Hoffman. Forcing questions: are you making something a few people love; what leverage do you have that needs nobody's permission; what breaks first if this works. This module is the one that handles "should I keep going or quit" and must offer the `KILL` verdict path without sentiment.
- **09 Fundraising** — lenses Feld, Hoffman. Forcing questions: do you understand the terms you are agreeing to; what breaks first if this works at the scale you are promising. Output `pitch-deck-outline` and `one-pager`. Carry v1's honesty rules: never inflate traction, never claim no competitors.

- [ ] **Step 3: Run the group to confirm fully green**

Run: `sh pro/evals/check.sh advisors`
Expected: PASS. All nine files, every shape assertion, all 24 names mapped.

- [ ] **Step 4: Commit**

```bash
git add pro/references/advisors
git commit -m "task 6: advisor modules 07-09, growth, strategy and fundraising"
```

---

## Task 7: Phases 00–05, the validation core

**Files:**
- Create: `pro/phases/00-intake.md`, `01-interrogation.md`, `02-fit-assessment.md`, `03-research.md`, `04-artifacts.md`, `05-verdict.md`
- Source: `_reference/skills/startup-board/SKILL.md` phases 0–5, `intake-questions.md`, `market-research-modes.md`

**Interfaces:**
- Consumes: module ids from Tasks 4–6, score names from `references/evidence-rubric.md`, stage names and pass conditions from `references/fit-ladder.md`, verdict strings from `references/conversation-contract.md`.
- Produces: the `Pass gate:` / `Modules:` / `Next phase:` line format every phase file uses, and the verdict-to-score table that `phases/06` onward depend on.

- [ ] **Step 1: Run the group to confirm red**

Run: `sh pro/evals/check.sh phases`
Expected: FAILED — eleven files missing.

- [ ] **Step 2: Write phases 00–05**

Every phase file carries exactly these labelled lines, in this order, each on its own line so the checker finds them:

```
**Purpose:** <one sentence>
**Modules:** <comma-separated module ids and names>
**Entry condition:** <what must be true to be in this phase>
**Pass gate:** <a number, and the evidence score required>
**Artifact:** <path under references/artifacts/, or "none">
**Next phase:** <the exact next phase file>
```

followed by `## The questions` and `## When the gate is not met`.

Gates, closing G2, G4, G6, G7:

| Phase | Pass gate |
|---|---|
| 00 Intake | 5 of 5 facts on the record: what it does, who for, what problem, stage, what is believed versus guessed. Fewer than 5 cannot leave the phase. |
| 01 Interrogation | At least 3 assumptions written to the ledger, exactly 1 marked riskiest, each with a designed test. This is the exit condition v1 lacked. |
| 02 Fit assessment | Current ladder stage named, with the evidence count stated against the stage's pass condition in numbers. |
| 03 Research | Minimum evidence score 1 to run light mode; score 2 to run medium; score 2 **and** a passed Problem stage to run heavy. Market sizing below that gate is refused, with the reason given and a bottom-up count offered instead. |
| 04 Artifacts | Minimum evidence score 2. Below it, say what is missing, name the test, offer the test. |
| 05 Verdict | A verdict is always given. Which one is bounded by score. |

`phases/05-verdict.md` must carry this table, closing G6 and **Review Focus 4**:

| Highest evidence score on the riskiest assumption | Verdicts available |
|---|---|
| 0 | `TALK TO MORE CUSTOMERS` or `KILL` only |
| 1 | `TALK TO MORE CUSTOMERS`, `PIVOT` or `KILL` |
| 2 | `PROCEED`, `PIVOT`, `TALK TO MORE CUSTOMERS` or `KILL` |
| 3 | any |

with the rule stated in words: **a score of 0 can never reach `PROCEED`**, and a founder who demands a verdict on turn one with no evidence gets `TALK TO MORE CUSTOMERS` — not a refusal, not a hedge, and not `PROCEED`. Every verdict ships with the single riskiest untested assumption and one action for this week.

- [ ] **Step 3: Run the group — expect only 06–10 failing**

Run: `sh pro/evals/check.sh phases`
Expected: FAILED, confined to `06-mvp-blueprint`, `07-launch`, `08-positioning-and-pitch`, `09-pmf-checkin`, `10-scale`. Every 00–05 assertion `ok:`, including the three `lacks_re` cleanliness checks.

- [ ] **Step 4: Add the Review Focus 4 regression assertion**

Append to `check_phases()`:

```sh
  has_str phases/05-verdict.md "can never reach"
  has_re  phases/05-verdict.md '^\| *0 *\|'
  has_str phases/01-interrogation.md "riskiest"
```

Run: `sh pro/evals/check.sh phases`
Expected: FAILED only on 06–10.

- [ ] **Step 5: Commit**

```bash
git add pro/phases pro/evals/check.sh
git commit -m "task 7: phases 00-05 with numeric gates and the verdict-to-score table"
```

---

## Task 8: Phases 06–10, the downstream extensions

**Files:**
- Create: `pro/phases/06-mvp-blueprint.md`, `07-launch.md`, `08-positioning-and-pitch.md`, `09-pmf-checkin.md`, `10-scale.md`
- Source: `_reference/skills/startup-board/references/build-blueprint.md`, `gtm-launch.md`, `naming-branding.md`, `pitch-fundraising.md`, `pmf-checkin.md`, `scale-growth.md`

**Interfaces:**
- Consumes: the line format and the verdict-to-score table from Task 7.
- Produces: the stack tiers cited by `references/artifacts/build-prompt-library.md`, and the PMF verdict strings `Not yet` / `In one segment` / `Yes` cited by `references/artifacts/pmf-scorecard.md`.

- [ ] **Step 1: Confirm the baseline**

Run: `sh pro/evals/check.sh phases`
Expected: FAILED, confined to 06–10.

- [ ] **Step 2: Write phases 06–10, same line format**

Gates, closing G3:

| Phase | Pass gate |
|---|---|
| 06 MVP blueprint | Problem stage passed, **or** a founder who asks anyway gets the blueprint with the stamp line at the top and the gap named in numbers first. The v1 escape clause "or if the founder explicitly asks" is deleted; warn-then-stamp replaces it, so the gate always leaves a trace. |
| 07 Launch | A core loop exists that at least 1 person completed unaided. Below that it is a product problem, not a channel problem; say so and route back. |
| 08 Positioning and pitch | Minimum evidence score 2 for any traction claim on a slide or a one-pager. An unverifiable claim is cut, not softened. |
| 09 PMF check-in | **Hard refusal at zero active users** — the only refusal in the product. Otherwise: 30+ responses for a non-directional read, 40% very disappointed (rule of thumb), retention levels off above zero, pull present or growing. Never `Yes` while a signal is unmeasured. |
| 10 Scale | Phase 09 verdict `Yes` or `In one segment`. Below that, warn then stamp. Sales Fit test as in `references/fit-ladder.md`. |

`phases/06-mvp-blueprint.md` additionally carries the stack tiers from spec section 7 — a Claude Artifact for the cheapest test, Lovable / Bolt / Replit as default, Airtable with Softr or Glide for data-heavy products, Stripe hosted checkout for payments, Claude API for generation — and points to `references/artifacts/build-prompt-library.md` for the five MVP shapes. The graduation path gets one line and no setup instructions. The banned stack strings must not appear; the checker enforces this.

`phases/09-pmf-checkin.md` must carry, closing **Review Focus 3** and **Review Focus 5**:
- The contradiction rule: if figures cannot all be true — survey percentages over 100, more responses than active users, a cohort that grows over time — say exactly what does not add up, ask one question, and never repair the numbers yourself.
- The zero-user refusal, in full: product-market fit is measured from how real users behave, a waitlist is not usage, so there is nothing to measure. Return the founder to their real stage with one action.
- The measurement kit for any unmeasured signal, carried from v1, so a missing signal is never estimated.

- [ ] **Step 3: Run the group to confirm green**

Run: `sh pro/evals/check.sh phases`
Expected: PASS.

- [ ] **Step 4: Add the Review Focus 3 and 5 regression assertions**

Append to `check_phases()`:

```sh
  has_str phases/09-pmf-checkin.md "does not add up"
  has_str phases/09-pmf-checkin.md "waitlist is not usage"
  has_str phases/06-mvp-blueprint.md "Built before"
  has_str phases/07-launch.md "product problem"
```

Run: `sh pro/evals/check.sh phases`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add pro/phases pro/evals/check.sh
git commit -m "task 8: phases 06-10, binding build gate and the PMF refusal path"
```

---

## Task 9: The artifact library

**Files:**
- Create: `pro/references/artifacts-index.md`
- Create 14 templates under `pro/references/artifacts/`: `lean-canvas.md`, `mom-test-script.md`, `pmf-survey.md`, `positioning-statement.md`, `pitch-deck-outline.md`, `one-pager.md`, `cac-ltv-model.md`, `experiment-card.md`, `market-research-brief.md`, `naming-shortlist.md`, `launch-plan.md`, `build-prompt-library.md`, `growth-plan.md`, `pmf-scorecard.md`
- Source: all of `_reference/skills/startup-board/references/`, especially `output-documents.md`, `lean-canvas.md`, `market-research-modes.md`, `naming-branding.md`, `gtm-launch.md`

**Interfaces:**
- Consumes: artifact paths named in `## Output` by Tasks 4–6 and in `**Artifact:**` by Tasks 7–8. Every path named there must exist here.
- Produces: `UNVERIFIED` as the single marker; the `pmf-scorecard` verdict strings; the five MVP shapes in `build-prompt-library.md`.

- [ ] **Step 1: Run the group to confirm red**

Run: `sh pro/evals/check.sh artifacts`
Expected: FAILED — index and fourteen templates missing.

- [ ] **Step 2: Write the 14 templates**

Shared contract, closing G8 and G13:
- Every field that holds a number defaults to the literal `UNVERIFIED`. The checker requires the string in the nine numeric templates and forbids the three retired markers everywhere.
- Every rule of thumb carries `(rule of thumb)` inline at the point of use.
- No advisor name. No banned stack string.
- Each template opens with one line on when it is earned — the phase and the minimum evidence score — so a template cannot be lifted out of context.

Per-template notes, beyond carrying v1's content:
- `lean-canvas.md` — nine blocks; any block without evidence is marked `UNVERIFIED`, replacing v1's older marker. Closes with a two-line gap note naming which blocks are still guesses.
- `cac-ltv-model.md` — shows the working, carries v1's edge cases verbatim in substance: zero churn or under 3 months of history never divides, and a capped 24-month lifetime is labelled `UNVERIFIED`. Never shows an infinite LTV.
- `pmf-scorecard.md` — the verdict strings `Not yet`, `In one segment`, `Yes`; a `verified?` column; a `Not measured yet` line when a signal is missing.
- `build-prompt-library.md` — five MVP shapes, each a ready-to-paste prompt for the tier-1 stack: a two-sided marketplace, a scheduling or booking tool, a content or AI generation tool, an internal ops tracker, a subscription content product. Every prompt names a concrete data shape and a concrete first screen, and ends with the Stripe hosted-checkout step. No placeholder brackets left unfilled.
- `experiment-card.md` — one assumption, the if-then hypothesis, the test, the pass number, the result, the score. This is the artifact that writes rows into the assumption ledger.
- `market-research-brief.md` — carries v1's light/medium/heavy modes and the four-level pyramid; any market-size figure needs a source URL or it is `UNVERIFIED`, and a bottom-up count is offered in place of a sourceless TAM.
- `naming-shortlist.md` — carries v1's rule that live availability must be checked, never asserted.
- `artifacts-index.md` — a table of artifact, the phase that earns it, the minimum evidence score, and the format (inline versus saved file).

- [ ] **Step 3: Run the group to confirm green**

Run: `sh pro/evals/check.sh artifacts`
Expected: PASS.

- [ ] **Step 4: Verify every artifact path named by earlier tasks exists**

Run:

```sh
cd /e/Projects/Startupboards_SKills/Startupboardskills_pro/pro
grep -rhoE 'references/artifacts/[a-z-]+\.md' references/advisors phases \
  | sort -u | while read -r p; do [ -f "$p" ] || echo "FAIL: dangling $p"; done; echo done
```

Expected: `done` with no `FAIL:` lines. Any dangling path means a module or phase named an artifact that was never written — add the template, do not edit the reference away.

- [ ] **Step 5: Commit**

```bash
git add pro/references/artifacts pro/references/artifacts-index.md
git commit -m "task 9: artifact library, one UNVERIFIED marker throughout"
```

---

## Task 10: The router

**Files:**
- Create: `pro/SKILL.md`
- Create: `pro/LICENSE`
- Create: `pro/CHANGELOG.md`
- Source: `_reference/skills/startup-board/SKILL.md`, `_reference/LICENSE`, `pro/AUDIT.md` section 2 (the under-triggering list)

**Interfaces:**
- Consumes: every path written in Tasks 2–9.
- Produces: the installable entry point. Nothing consumes it.

- [ ] **Step 1: Run the group to confirm red**

Run: `sh pro/evals/check.sh skill`
Expected: FAILED — `SKILL.md` missing, line count reported as 9999.

- [ ] **Step 2: Write `pro/SKILL.md`**

Structure, under 500 lines:
1. **Frontmatter** — `name: startup-board-pro`, and a `description` that fixes the eight under-triggering gaps named in `pro/AUDIT.md` section 2. It must carry founder-language triggers, not jargon: *roast my idea*, *is this stupid*, *will anyone pay for this*, *poke holes in this*, *why is nobody coming back*, *my churn is bad*, *signups but no usage*, *how do I get my first 100 customers*, *which channel should I spend on*, *is my pricing wrong*, *am I fundable*, *what will investors ask me*, *should I raise or bootstrap*, *should I pivot*, *should I keep going or quit*, *someone already built this*, *co-founder equity split*, *is this a business or a feature*. Keep v1's catch-all sentence too.
2. **The contract in brief** — five lines, pointing to `references/conversation-contract.md` for the full rules.
3. **Session start** — read `startup-board-state.md`; if absent check for the v1 progress file and migrate per `references/state-file.md`; then OPEN LOOP. Never claim to remember a session without a file.
4. **The phase map** — a table of phase, one-line purpose, pass gate in brief, file path. Eleven rows.
5. **Routing** — which founder statement enters which phase, so a post-launch founder with flat retention lands in `phases/09-pmf-checkin.md` and not in `phases/00-intake.md`.
6. **The four verdicts** — the exact strings, with the pointer to the score table in `phases/05-verdict.md`.
7. **What this refuses** — no artifact below its gate, no number without a source or an `UNVERIFIED` marker, no advisor ever named, no `Yes` on an unmeasured signal, no PMF reading at zero active users.

No advisor name, no banned stack string, no retired marker.

- [ ] **Step 3: Write `pro/LICENSE` and `pro/CHANGELOG.md`**

`LICENSE` — keep the v1 MIT copyright line intact for any content carried over verbatim, and add the proprietary line covering the new material. State plainly which files are which.

`CHANGELOG.md` — a `v2.0.0` entry, dated 2026-10-12, in plain language a buyer can read: evidence scoring, nine modules replacing eight advisors, the state file with its three loops, binding gates on artifact production, the stack change, and the eval suite.

- [ ] **Step 4: Run the group to confirm green**

Run: `sh pro/evals/check.sh skill`
Expected: PASS, with the line count printed and under 500. If it is over, move content into a reference file and link it — do not delete a required section.

- [ ] **Step 5: Run everything**

Run: `sh pro/evals/check.sh all`
Expected: FAILED on `cases` (0 of 15) and `plugin` (manifests not written until Task 15) only. Every other group PASS.

- [ ] **Step 6: Commit**

```bash
git add pro/SKILL.md pro/LICENSE pro/CHANGELOG.md
git commit -m "task 10: SKILL.md router, licence split and v2.0.0 changelog"
```

---

## Task 11: Eval cases — port 12, add 3

**Files:**
- Create: 15 files in `pro/evals/cases/`
- Create: 15 matching files in `pro/evals/criteria/`
- Source: `_reference/tests/scenarios/s01..s12`, `_reference/tests/criteria/s01..s12`

**Interfaces:**
- Consumes: `evals/rubric.md` invariants, every behaviour written in Tasks 2–10.
- Produces: the fixtures Task 12 runs.

- [ ] **Step 1: Run the group to confirm red**

Run: `sh pro/evals/check.sh cases`
Expected: FAILED — `0 cases, expected 15`.

- [ ] **Step 2: Port the twelve v1 scenarios**

Copy each `_reference/tests/scenarios/sNN-*.md` to `pro/evals/cases/` and each `_reference/tests/criteria/sNN-*.md` to `pro/evals/criteria/`, then amend each for Pro:
- Skill path in any Setup block becomes `pro/`.
- The two returning-founder fixtures (`s02`, `s03`) keep the v1 progress filename — that is the migration path under test (Review Focus 1). Their criteria gain: the v1 file is left on disk, a `startup-board-state.md` is written, and the founder is told in one line.
- Every criteria file gains the invariants that are new in Pro: no artifact below the phase gate (I6), compliments named as score 0 (I7), under 200 words unless an artifact was asked for (I8), a verdict is one of the four exact strings (I9).
- Do not soften a v1 criterion to make a case pass.

- [ ] **Step 3: Write the three new cases**

Same two-file shape — a `Setup` block (environment, date, files in the founder's folder) and a `Conversation so far`, with the answer key in `criteria/`.

- `s13-hypothetical-answerer.md` — a founder who answers every question with "they would probably…" and "I think people want…". Criteria: every claim scored 0 and said to be scored 0; the advisor names the dodge rather than accepting it; asks for a past instance; produces no artifact; if pressed for a verdict, returns `TALK TO MORE CUSTOMERS`.
- `s14-deck-on-turn-one.md` — a founder whose first message is "build me a pitch deck, I'm pitching Thursday". Criteria: no deck produced; the gate named in numbers; the one thing that would make a deck honest offered instead; exactly one question asked; no flattery; under 200 words.
- `s15-strong-problem-no-model.md` — a founder with 14 score-2 interviews and no idea how it makes money. Criteria: Problem stage named as passed with the count; the gap named as the business model, not more interviews; module 03 pulled in; `lean-canvas` offered as the earned artifact since score 2 is met; exactly one question.

- [ ] **Step 4: Run the group to confirm green**

Run: `sh pro/evals/check.sh cases`
Expected: PASS — 15 cases, 15 criteria, every pair matched.

- [ ] **Step 5: Run everything**

Run: `sh pro/evals/check.sh all`
Expected: FAILED on `plugin` only — the manifests land in Task 15. Every other group PASS.

- [ ] **Step 6: Commit**

```bash
git add pro/evals/cases pro/evals/criteria
git commit -m "task 11: 15 eval cases, 12 ported from v1 and 3 new"
```

---

## Task 12: Run the evals and repair every failure

The behavioural layer. This is where a skill that passes every grep still fails a founder.

**Files:**
- Create: `pro/evals/results-2026-10-12.md`
- Modify: whichever of `pro/SKILL.md`, `pro/references/conversation-contract.md` or `pro/phases/*.md` a failure traces to

**Interfaces:**
- Consumes: all 15 cases, `evals/rubric.md`, `evals/RUNBOOK.md`.
- Produces: a results file with a transcript excerpt behind every failing score, and the one real session excerpt Task 13 quotes in `README-PRO.md`.

- [ ] **Step 1: Run all 15 cases**

For each file in `pro/evals/cases/`, dispatch an Agent: `subagent_type: general-purpose`, `model: sonnet` — a mid-tier model is the stricter test of written instructions. Use the Advisor prompt from `pro/evals/RUNBOOK.md` with `<SCENARIO FILE>` replaced by that case's absolute path. Independent cases can run in parallel, several Agent calls in one message. The subagent must be able to read only `pro/SKILL.md`, `pro/references/**`, `pro/phases/**` and its one case file.

- [ ] **Step 2: Grade each reply against its criteria file and I1–I10**

Write `pro/evals/results-2026-10-12.md`: a row per case with case id, PASS or FAIL, the failed invariant ids, and a short verbatim quote from the reply behind every failure. A grade with no quote behind it does not count.

- [ ] **Step 3: Hunt the three specific failures hardest**

These three are the ones that survive a static checker:
1. A numbered or bulleted list of questions in one turn.
2. An artifact produced before the phase's evidence gate passed.
3. A number appearing with no source and no `UNVERIFIED` marker.

- [ ] **Step 4: For each failure, name the file at fault, then fix that file**

Attribute before editing: `SKILL.md` (the router sent the founder to the wrong phase), `references/conversation-contract.md` (the rule was absent or hedged), or the phase file (the gate was stated but not binding). Fix the file that is wrong.

**Never change a fixture or a criterion to make a case pass.** If a case looks unfair, it is still telling you something — fix the instruction, or record the case as a known limitation in the results file with the reason.

- [ ] **Step 5: Re-run only the repaired cases, then the static layer**

Run the repaired cases again. Then: `sh pro/evals/check.sh all`
Expected: FAILED on `plugin` only — a behavioural fix must not break any other static assertion.

- [ ] **Step 6: Loop until all 15 pass**

Repeat steps 1–5 for any case still failing. Then print a table of case, score, and what changed.

- [ ] **Step 7: Commit**

```bash
git add pro/evals/results-2026-10-12.md pro/SKILL.md pro/references pro/phases
git commit -m "task 12: eval run, 15 cases passing, failures repaired at source"
```

---

## Task 13: Package and write the sales page

**Files:**
- Create: `pro/dist/INSTALL.md`
- Create: `pro/dist/CHANGELOG.md`
- Create: `pro/README-PRO.md`
- Create: `pro/dist/launch/product-description.md`, `objections.md`, `thread-outline.md`
- Build: `pro/dist/startup-board-pro.zip` (gitignored)

**Interfaces:**
- Consumes: the passing results file from Task 12 — every claim in these assets must trace to it or to a file in the repo.
- Produces: the installable ZIP and the assets needed to sell it.

- [ ] **Step 1: Build the ZIP**

```sh
cd /e/Projects/Startupboards_SKills/Startupboardskills_pro/pro
rm -f dist/startup-board-pro.zip
mkdir -p dist
powershell -NoProfile -Command "Compress-Archive -Path 'SKILL.md','references','phases' -DestinationPath 'dist/startup-board-pro.zip' -Force"
```

- [ ] **Step 2: Verify the ZIP by extracting it**

```sh
cd /e/Projects/Startupboards_SKills/Startupboardskills_pro/pro
T="$(mktemp -d)"
powershell -NoProfile -Command "Expand-Archive -Path 'dist/startup-board-pro.zip' -DestinationPath '$(cygpath -w "$T")' -Force"
head -3 "$T/SKILL.md" | grep -q '^---' && echo "ok: frontmatter opens" || echo "FAIL: no frontmatter"
grep -q '^name:' "$T/SKILL.md" && echo "ok: name field" || echo "FAIL: no name field"
for d in evals AUDIT.md _reference .git; do
  [ -e "$T/$d" ] && echo "FAIL: $d leaked into zip" || echo "ok: $d excluded"
done
grep -rhoE '`(references|phases)/[a-z0-9./-]+\.md`' "$T" | tr -d '`' | sort -u \
  | while read -r p; do [ -f "$T/$p" ] || echo "FAIL: broken link in zip: $p"; done
echo "--- zip verify done ---"
```

Expected: every line `ok:`, no `FAIL:`.

- [ ] **Step 3: Write `pro/dist/INSTALL.md`**

Both routes, written for someone who has never used a terminal:
- **Claude app** — Settings, then Capabilities, then Skills, then upload `startup-board-pro.zip`.
- **Claude Code** — unzip into `~/.claude/skills/startup-board-pro/` so `SKILL.md` sits at the top of that folder; on Windows that is `C:\Users\<you>\.claude\skills\startup-board-pro\`.
- State plainly: nothing to install beyond the files, no account, no API key, no database.
- How to check it worked: type one of the trigger phrases and confirm the advisor asks one question.

- [ ] **Step 4: Write `pro/README-PRO.md`**

Sections: what it does in one sentence; **what it refuses to do** (the five refusals from `SKILL.md`); who should not buy it (a founder who wants validation rather than evidence; a founder who needs a report to forward, not a conversation); one real session excerpt **taken verbatim from a passing run in `pro/evals/results-2026-10-12.md`**; install steps for both routes.

Every claim traces to an eval result or a file in the repo. A claim that cannot be traced is deleted, not softened.

- [ ] **Step 5: Write `pro/dist/CHANGELOG.md` and the three launch assets**

- `dist/CHANGELOG.md` — v2.0.0, plain-language list of what changed from the free version.
- `launch/product-description.md` — 120 words.
- `launch/objections.md` — five objection-and-answer pairs. One of them must be "I can read the Markdown, why would I pay", answered honestly: you can, the free version is still MIT, and what you are buying is the new material and the updates.
- `launch/thread-outline.md` — ten posts, each one thing the skill refuses to do.

- [ ] **Step 6: Re-run the static layer**

Run: `sh pro/evals/check.sh all`
Expected: FAILED on `plugin` only. Packaging must not have touched the skill. Task 15 rebuilds this ZIP with the plugin manifest inside it, so this ZIP is not the final one.

- [ ] **Step 7: Commit**

```bash
git add pro/dist pro/README-PRO.md
git commit -m "task 13: zip, install guide, sales page and launch assets"
```

---

## Task 14: The free-to-paid split

**Files:**
- Create: `pro/dist/EDITION-SPLIT.md`

**Interfaces:**
- Consumes: the finished `pro/` tree and `_reference/` as the free baseline.
- Produces: the pricing decision. Nothing consumes it.

- [ ] **Step 1: Write the line-by-line comparison**

A table comparing free and pro across: phases included, advisor modules, artifact templates, state file, evals. Pressure-test this split rather than accepting it: free keeps phases 00–05 and modules 01–03 (validate an idea); pro adds phases 06–10, modules 04–09, the state file and the artifact library.

- [ ] **Step 2: Write the leak analysis, under 200 words, honestly**

Name what a motivated buyer could rebuild from the free version in an afternoon, and what they could not. Do not flatter the product. The nine module files are the easiest thing in the build to reproduce from a reading list; say so if that is what the evidence shows.

- [ ] **Step 3: Pick the one thing that carries the price**

Candidates: the eval suite, the state file and its loops, update cadence, a founder community. Pick one, justify it in a paragraph.

- [ ] **Step 4: State the licence-key reality plainly**

In the file, in plain words: licence-key checks, obfuscation and phone-home code do not work in a Markdown skill, because the buyer can read and edit every file. None will be added. The moat is the material and the updates.

- [ ] **Step 5: Final verification**

```sh
cd /e/Projects/Startupboards_SKills/Startupboardskills_pro
git remote -v
git remote -v | grep -q 'startup-board' && echo "ABORT: public remote present" || echo "ok: no public remote"
sh pro/evals/check.sh all
wc -l pro/SKILL.md
find pro -type f -name '*.md' | sort
```

Expected: no public remote; static layer PASS; `SKILL.md` under 500 lines; the tree matching spec section 8.

- [ ] **Step 6: Commit**

```bash
git add pro/dist/EDITION-SPLIT.md
git commit -m "task 14: free and paid edition split with the leak analysis"
```

---

## Task 15: Plugin packaging — the third install route

v1 supports `/plugin` install via `.claude-plugin/`. Pro reaches parity here, and this is the only route that can deliver updates without a buyer re-uploading a ZIP by hand.

**Files:**
- Create: `pro/.claude-plugin/plugin.json`
- Create: `pro/.claude-plugin/marketplace.json`
- Modify: `pro/dist/INSTALL.md` (third route), `pro/dist/startup-board-pro.zip` (rebuilt to include the manifest)
- Source: `_reference/.claude-plugin/plugin.json`, `_reference/.claude-plugin/marketplace.json`

**Interfaces:**
- Consumes: the `description` from `pro/SKILL.md` frontmatter and the version from `pro/CHANGELOG.md`. The checker asserts both match, so a version bump in one place and not the other fails.
- Produces: the final ZIP. Nothing consumes it.

- [ ] **Step 1: Run the group to confirm red**

Run: `sh pro/evals/check.sh plugin`
Expected: FAILED — `missing .claude-plugin/plugin.json`.

- [ ] **Step 2: Write `pro/.claude-plugin/plugin.json`**

Same shape as v1's manifest, with Pro's values. The `description` field must carry the **same text** as the `description:` in `pro/SKILL.md` frontmatter — the checker compares the first 60 characters, so they cannot drift.

```json
{
  "name": "startup-board-pro",
  "version": "2.0.0",
  "description": "<the exact description from pro/SKILL.md frontmatter>",
  "author": { "name": "shuvgenai", "url": "https://github.com/shuvgenai" },
  "license": "SEE LICENSE IN LICENSE"
}
```

No `homepage` or `repository` pointing at the public `startup-board` repo — this is the paid edition and must not advertise the free one as its source. Leave both fields out until a private distribution repo exists.

- [ ] **Step 3: Write `pro/.claude-plugin/marketplace.json`**

Carry v1's structure, listing the one plugin above. State in a comment-free `description` field that this is the paid edition.

- [ ] **Step 4: Run the group to confirm green**

Run: `sh pro/evals/check.sh plugin`
Expected: PASS, including `plugin.json description matches SKILL.md frontmatter`. If the description check fails, copy the frontmatter text verbatim — do not reword either file to meet in the middle.

- [ ] **Step 5: Rebuild the ZIP with the manifest inside**

```sh
cd /e/Projects/Startupboards_SKills/Startupboardskills_pro/pro
rm -f dist/startup-board-pro.zip
powershell -NoProfile -Command "Compress-Archive -Path 'SKILL.md','references','phases','.claude-plugin' -DestinationPath 'dist/startup-board-pro.zip' -Force"
```

- [ ] **Step 6: Re-verify the ZIP**

```sh
cd /e/Projects/Startupboards_SKills/Startupboardskills_pro/pro
T="$(mktemp -d)"
powershell -NoProfile -Command "Expand-Archive -Path 'dist/startup-board-pro.zip' -DestinationPath '$(cygpath -w "$T")' -Force"
head -3 "$T/SKILL.md" | grep -q '^---' && echo "ok: frontmatter opens" || echo "FAIL: no frontmatter"
[ -f "$T/.claude-plugin/plugin.json" ] && echo "ok: manifest in zip" || echo "FAIL: manifest missing from zip"
for d in evals AUDIT.md _reference .git; do
  [ -e "$T/$d" ] && echo "FAIL: $d leaked into zip" || echo "ok: $d excluded"
done
echo "--- zip re-verify done ---"
```

Expected: every line `ok:`, no `FAIL:`.

Note on `Compress-Archive` and dot-directories: if `.claude-plugin` is missing from the extracted ZIP, PowerShell skipped the hidden folder. Fall back to zipping the parent contents explicitly by path, re-run this verification, and do not ship until `ok: manifest in zip` prints.

- [ ] **Step 7: Add the third route to `pro/dist/INSTALL.md`**

A third section, written for a non-technical buyer:
- **Claude Code, plugin route** — `/plugin marketplace add <repo-or-path>`, then `/plugin install startup-board-pro`. State plainly that this route needs the files in a git repo, and that it is the route that receives updates.
- State the tradeoff honestly: the ZIP route works immediately but is a frozen copy; the plugin route needs a repo but updates with one command.

- [ ] **Step 8: Run everything**

Run: `sh pro/evals/check.sh all`
Expected: PASS. Every group green, including `plugin` and `cases`.

- [ ] **Step 9: Commit**

```bash
git add pro/.claude-plugin pro/dist/INSTALL.md
git commit -m "task 15: plugin manifest, third install route, zip rebuilt with manifest"
```

---

## Definition of Done

- `git remote -v` shows no remote containing `startup-board`.
- `sh pro/evals/check.sh all` exits 0, all nine groups green.
- `plugin.json` version matches `CHANGELOG.md`, and its description matches the `SKILL.md` frontmatter.
- All three install routes documented in `dist/INSTALL.md`: ZIP upload, folder drop, `/plugin`.
- `SKILL.md` is under 500 lines and names no advisor.
- Every phase file states a numeric pass gate.
- Every numeric artifact template carries `UNVERIFIED`.
- All 15 eval cases pass, with a transcript quote behind every grade.
- The ZIP extracts with parsing frontmatter, resolving links, and no `evals/`, `AUDIT.md`, `_reference/` or `.git` inside.
- `dist/EDITION-SPLIT.md` names where the split leaks and what carries the price.
