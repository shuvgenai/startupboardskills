# Gate sweep: what each phase does below its lowest gate

Audit only. Nothing fixed. Read from disk on 2026-10-13, working tree (uncommitted edits to phase 03 and the contract included).

Reference points used:
- Contract section 6: below the gate, say what is missing in numbers, name the one test, offer the test instead of the document. If the founder insists, produce it with the gap stamp as line one. "Never refuse."
- `references/fit-ladder.md` and `SKILL.md` carve out exactly three outright refusals: zero-user fit check-in (09), market sizing below the research gate (03 heavy), unverifiable claim on a slide or one-pager (08). The contract itself contains no such exception.

| phase | gate (verbatim) | 0 defined? | refusal names a specific next test? | artifact? | contract agrees? | covered by a case |
|---|---|---|---|---|---|---|
| 00 | "5 of 5 facts recorded. No minimum evidence score — this phase collects claims, it does not judge them." | yes. Fewer than 5 facts: stay, ask the missing fact. No score involved. | n/a (asks one question, no test needed) | none | yes | none strict. s12 is a first turn with 0 of 5 facts but its criteria test tone and one-question, not the stay-in-phase rule. |
| 01 | "3 assumptions written to the assumption ledger, exactly 1 marked riskiest, and 1 test designed with a pass number decided in advance." | yes. Any shortfall: stay, name which of the three is missing, ask the one question. | n/a (count gate, asks the question that produces the missing item) | `references/artifacts/experiment-card.md` | yes. Index lists it at min score 0, so always available. | none. s13 is adjacent (hypothetical answers) but does not test fewer than 3 assumptions or no riskiest. |
| 02 | "The current stage named, and the founder's evidence counted against that stage's pass condition in numbers, with each claim scored 0 to 3." | yes. Gate is the advisor's rigour, not founder evidence. A founder who wants to move on gets warn-then-allow from fit-ladder. A founder at 0 is simply named as not past Problem. | yes ("name the one action that closes the gap") | none | yes | s01 (4 interviews, "can I start building?") |
| ⚠ 03 | "Evidence score 1 to run light mode. Score 2 to run medium. Score 2 and a passed Problem stage to run heavy, which is the only mode that produces market sizing." | partial. Score 0: defined (refuses all modes). Heavy below gate: defined. **Score 1 asking for medium: no behaviour written**, only a sentence of rationale ("Medium needs score 2 because a positioning map ... is decoration"). **Score 2 without Problem passed asking for heavy** is covered only by the generic "heavy below the gate is refused". PATH JUST WRITTEN, NOT PRE-EXISTING: the score-0 paragraph was added minutes before this audit. | yes at 0 (three interviews about the last time this happened). Heavy: bottom-up count. Medium at 1: none named. | `references/artifacts/market-research-brief.md` | **no, two conflicts.** (a) Score-0 paragraph refuses light outright with no insist-and-stamp path. SKILL.md and fit-ladder say only three things are refused and "nothing else"; light-at-0 is not one of them, and contract section 6 says never refuse. (b) Heavy refusal is sanctioned by fit-ladder/SKILL.md but states no insist path. | s21 (score 0, light) only. Nothing for score 1 asking medium, or score 2 asking heavy. |
| ⚠ 04 | "Minimum evidence score 2 for any artifact that asserts something about customers or the model. Score 0 or 1 earns the interview script and the experiment card only." | yes. "When the gate is not met" is generic, so it covers 0 and 1. | yes (interview script, tailored, offered now) | `references/artifacts/lean-canvas.md`, `references/artifacts/mom-test-script.md` | **no.** The phase's own opening question, "Want to start with the canvas, or the interview questions?", offers the canvas unconditionally, including at score 0. Contract section 6 says do not volunteer an unearned canvas. The insist-and-stamp path itself agrees. | s19 |
| 05 | "1 verdict from the four strings, 1 riskiest untested assumption named, 1 action for this week. Which verdicts are available is bounded by the evidence score below." | yes. The table covers 0, 1, 2 and 3. | yes ("1 action for this week"; at 0 the verdict is TALK TO MORE CUSTOMERS) | none (verdict goes in the state file) | yes. Never refuses; bounds the verdict instead. | s18 (score 0) |
| ⚠ 06 | "Problem stage passed, which needs 10 interviews at score 2 (rule of thumb). Below that, the blueprint still ships but carries the gap stamp and the gap is stated in numbers first." | yes. "Below that" is generic. | yes, loosely. "Name the one action that closes it", with a worked gap line. No named test form. | `references/artifacts/build-prompt-library.md` | **contradicts itself.** Gate line: below the gate the blueprint "still ships" stamped, which reads as produced on the first ask. "When the gate is not met" section and Entry condition: warn, name the action, produce only "if they still want it". Reading 1 breaks contract section 6 (unasked, below gate: never). Reading 2 agrees. Both recorded; not resolved. | s01 (asks to start building at 4 interviews) |
| ⚠ 07 | "1 person has completed the core loop without help. Below that, this is a product problem and not a channel problem." | partial. Covers "nobody has finished the loop". **Not covered: nothing built at all** (Entry condition says "something exists", but no route says where to send a founder with no product; the named action, "sit with one person while they try it", presumes one). | yes (sit with one person, say nothing, write down where they stop) | `references/artifacts/launch-plan.md`, `references/artifacts/positioning-statement.md` | partial. Insist-and-stamp agrees. But artifacts-index lists positioning-statement at min score 2; phase 07 gates it only on the loop. | none |
| ⚠ 08 | "Minimum evidence score 2 for any claim on a slide, and score 3 for any traction claim. 1 unverifiable claim is cut, not softened." | partial. Defined per claim ("cut the claim") and for empty traction (one-pager). **Not defined: whole founder at score 0 asking for a deck** (every slide claim fails; nothing says what is produced, or whether a one-pager is allowed when the index puts one-pager at min 2 as well). No insist path. | declines only (cut the claim; "a one-pager asking for a conversation"). No evidence-producing test named. | `references/artifacts/pitch-deck-outline.md`, `references/artifacts/one-pager.md`, `references/artifacts/naming-shortlist.md`, `references/artifacts/raise-plan.md` | partial. Claim-cutting is a sanctioned refusal in SKILL.md and fit-ladder, absent from the contract. Valuation figure is never produced at any score, no stamp path (a fourth hard "no" outside the three listed). | s14 (deck on turn one), s16 (valuation, no revenue) |
| ⚠ 09 | "30 or more active-user responses for a non-directional read (rule of thumb), 40% or more very disappointed (rule of thumb), retention that levels off above zero, and pull present or growing. Never Yes while any signal is unmeasured." | yes. Zero users: refused. Under 30: directional. Missing signal: measurement kit. Conflicting numbers: stop and ask. | yes (one action plus the kit; zero users: return to real stage, usually Product, with one action) | `references/artifacts/pmf-survey.md`, `references/artifacts/pmf-scorecard.md` | partial. Zero-active-users refusal is outright, with no stamp path. Sanctioned by SKILL.md and fit-ladder, but contract section 6 says "Never refuse" with no carve-out. Contract text gap, not a phase bug. | s08 (zero users); also s06, s07, s09, s20 |
| ⚠ 10 | "Sales stage conditions: 1 channel predictable for 3 consecutive months (rule of thumb), LTV at least 3x CAC (rule of thumb), payback 12 months or less (rule of thumb), and 1 customer won by someone other than the founder." | partial. Covers "below a Phase 09 verdict of Yes or In one segment" and unmet Sales parts. **Not covered: zero active users.** Phase 09 refuses these founders; phase 10's warn-then-allow would give them a stamped growth plan. Index puts `cac-ltv-model.md` at min 3, but the below-gate section stamps only the growth plan. | yes (which of the two numbers to move, and the one action) | `references/artifacts/growth-plan.md`, `references/artifacts/cac-ltv-model.md` | partial. Stamp format agrees. But the section goes "warn first, then warn-then-allow" and never says "offer the test instead of the document", so it reads as produce on the first ask. | s10 (scale before fit). Its criteria expect a stamped plan on the founder's first ask, which is itself the contract-versus-phase ambiguity above. |

## Counts

- Rows marked with the warning sign: 7 of 11 (03, 04, 06, 07, 08, 09, 10).
- Of those, genuine holes (a below-gate score with no written behaviour): 4. They are 03 (medium at score 1), 07 (nothing built), 08 (whole deck at score 0), 10 (zero users).
- Contradictions with the contract or other files: 03 (light refusal not in the sanctioned three), 04 (volunteers the canvas), 06 (self-contradictory gate line). 09 and 08 are contract-text gaps: the sanctioned refusals are in SKILL.md and fit-ladder, absent from the contract.
- Phases with no covering case at all: 01, 07, and 00 (strictly). Phase 03 has one, s21, covering score 0 only.
- Clean rows: 00, 01, 02, 05.

## Recommendation (per-phase paths vs one default rule)

The case for eleven per-phase paths: a phase file is what is loaded when the phase runs, so the rule sits next to the work. Only the phase knows its concrete test (three interviews about the last time this happened, versus sit silently with one user). A generic rule can only say "name a test", and the model improvised downward precisely at that step. Phases already differ: 05 bounds a verdict, 08 cuts claims, 09 refuses.

I would still ship one default rule in the contract that phases inherit unless they override. The failure was a missing definition, not missing prose: the contract never says what is forbidden below the lowest gate, namely substituting a cheaper tier of the same deliverable. One sentence fixes that for all eleven phases, including future ones. It also fixes the contract's missing three-refusal exception.

Cost if wrong: the model may not carry the contract into a phase, so it improvises again, and the generic rule names no concrete test. We would find out only when an eval case catches it.

## A4 — the three "partial" rows, judged (2026-10-13)

The sweep flagged 04, 06 and 09 without counting them as genuine holes. Read again
against the new default rule in `references/conversation-contract.md` section 6, one
judgement each.

**04 — the sweep was right; my override is withdrawn, and the phase is fixed.** I first
cited the gate line ("Score 0 or 1 earns the interview script and the experiment card
only") and called the row wrong. That was a different claim from the sweep's. The sweep
pointed at the opening question, which read, verbatim:

> Want to start with the canvas, or the interview questions?

That offered the canvas to every founder entering the phase, score 0 included, while the
gate line two lines above and the "What score 0 or 1 earns" block both put the canvas at
score 2. An explicit gate with contradicting prose beside it is the phase 06 defect
exactly, and the founder reads the question, not the gate. Fixed the same way: the menu
is now score-conditional, with a stated rule that it holds only what the score has
earned, because an option on a menu is a promise. The gate line and the three
score blocks are untouched.

**06 — fixed, not accepted.** The gate line read "the blueprint still ships but carries
the gap stamp", which standing alone says it ships automatically below the gate, while
the section below says offer first and stamp on insist. Under the new rule that is a
real conflict, so the gate line now reads "still ships **on request**". Two words; the
threshold, the rule-of-thumb label and the stamped path are untouched.

**09 — acceptable as written.** Zero active users is sanctioned refusal 1, recorded in
`fit-ladder.md` and `SKILL.md`, and the phase's own path covers every non-zero
shortfall ("say which signal is short and by how much"). The contract's bare "Never
refuse" is what made this look contradictory; section 6 now names all three sanctioned
refusals verbatim, so the exception is written down rather than inferred. s08 covers it.

**Holes closed in A3:** 03 (medium at 1, and any tier at 0, inherit explicitly),
07 (nothing-built routes back to phase 06), 08 (deck at 0 inherits, with insist-and-stamp,
and is named as not a fourth refusal), 10 (a founder 09 turned away is turned away here
too, so the two phases agree).
