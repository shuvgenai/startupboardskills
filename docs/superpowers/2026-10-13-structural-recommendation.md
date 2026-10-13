# Structural recommendation: the cross-file consistency defect

2026-10-13. Written after seven instances of one defect in a single day.

## The defect

A requirement is stated in one file and contradicted, or left unreinforced, in
another. Nothing asserts the pair. Both files read correctly on their own, which is
why the defect survives inspection and is expensive to find.

| # | stated in | the other file | how it surfaced |
|---|---|---|---|
| 1 | `phases/06`'s gate line ("the blueprint still ships") | its own below-gate section (offer first, stamp on insist) | gate sweep |
| 2 | `phases/08`'s gate (traction = score 3) | its unmet-gate test, unnamed, so the advisor defaulted to interviews (score 2) | **eval s24 failed** |
| 3 | `artifacts-index.md:19` (positioning = score 2) | `phases/07`'s gate, which named no score | gate sweep |
| 4 | `evidence-rubric.md` rule 4 (founder's own experience) | `conversation-contract.md` §1, silent on who a question may target | **eval s26 failed 3×** |
| 5 | `phases/01`'s gate (counts rows in the assumption ledger) | the phase never names the ledger's file | item-0 check |
| 6 | `artifacts-index.md:19` again ("Phase 04 or 07") | `phases/04`'s `**Artifact:**` line omitted positioning-statement | **`check_invariants` §5, first run** |
| 7 | `evals/rubric.md` I9 (four verdict strings, "never a fifth") | `phases/09` Step 4 emits `Not yet` / `In one segment` / `Yes` | ruling D |

Six of the seven were fixed identically: **state the constraint where it is
applied.** #4 was fixed by moving it there. That one fix worked six times is the
evidence this is a single defect rather than seven coincidences.

Three were found only because a blind eval failed. #4 cost three failed runs. #6 sat
in a file edited twice that same day without being noticed.

## What was built

`check_invariants()` sections 5 and 6, in `pro/evals/check.sh`:

- **§5 artifact-gate agreement.** Parses `references/artifacts-index.md`'s table. Per
  row: the artifact file exists; every phase named in column 2 exists; that phase's
  `**Artifact:**` block names the artifact; and the index's minimum score is not
  higher than anything the phase's `**Pass gate:**` and `**Artifact:**` block state. A
  phase stating no score while the index demands one fails, naming both lines.
- **§6 split-rule reciprocity.** Every `> **Where this rule is split, and why.**`
  block must name another file that exists and carries the same marker. A one-way
  pointer fails as a dangling reference, because a one-way pointer is what decays.

Both parse the files rather than hardcoding values, so they follow the files when a
gate changes — the technique the refusal check already uses on `fit-ladder.md`. Both
were proven to fire against deliberately broken copies, including reproducing #3.

## How many of the seven it would have caught: two, plus one recurrence

The honest accounting, which is less flattering than the build suggests.

| # | caught? | why |
|---|---|---|
| 1 | **no** | intra-file: a gate line contradicting its own section. Two files were never involved |
| 2 | **no** | needs gate-versus-test scoring, the assertion deliberately not built |
| 3 | **yes**, §5 | exactly its shape; reproduced in the fire test |
| 4 | **not at introduction** | no split-block existed then. §6 guards only the recurrence |
| 5 | **no** | a gate counting rows in an unnamed file is not a gate mismatch |
| 6 | **yes**, §5 | caught on the first live run |
| 7 | **no** | a vocabulary conflict, not a gate mismatch — see below |

**Two of seven, plus regression cover on a third. Four are invisible to it.**

### The blind spot, stated rather than buried

Instance #7 is the strongest available evidence about what these assertions do not
cover, so it belongs in the body. I9 said a verdict is one of four strings and "never
a fifth"; `phases/09` Step 4 emits three different ones. The defect shape is identical
— a rule in one file contradicted by another, nothing asserting the pair — and
**neither new assertion comes close to detecting it.** §5 compares integers pulled out
of gate lines. §6 checks that declared pointers reciprocate. Nothing in either reads a
closed list of permitted strings in one file and looks for a conflicting list in
another.

Generalised: §5 and §6 cover instances that are **numeric** or **explicitly
declared**. They miss instances that are **semantic**, **intra-file**, or
**undeclared**. A rule nobody thought to mark as split is exactly as invisible to §6
as it was to a human reader — and that is the case that cost three failed evals.

### Recorded limits of what it does cover

- Score matching is by digits, so `phases/10`'s "12 months" satisfies a score-3
  demand. A false pass, not a false fail.
- Prose gates such as "Problem passed, else gap stamp" are skipped rather than
  interpreted, with an explicit skip line.
- §6 reciprocity is per file, not per block: a second unrelated split-block in the
  target would satisfy a dangling pointer.

## Cost

**Build, actual not estimated:** one subagent pass, about 450 seconds wall clock and
roughly 91k tokens, producing ~44 new assertions — the `invariants` group now prints
86 `ok:` lines. My pre-build estimate was "an afternoon for §5 and §6"; the real figure
was well under that, because parsing two markdown tables is less work than it sounds.

**Runtime:** the `invariants` group takes **18.7s**. The suite went from 563 to 612
assertions and still passes. Its wall clock is dominated by the `zip` group's CRC
comparison, not by these.

**Maintenance:** near zero by construction, since both parse the files. The real
exposure is the opposite: a check that false-positives gets disabled, and a disabled
check is worse than none. Digit matching is the likeliest source, and it errs toward
false passes, which is the safer direction.

## Recommendation

**Keep §5 and §6.** They cost almost nothing to run, caught a real defect on their
first execution, and their maintenance burden is structural rather than manual.

**Do not build assertion 2** (gate versus the score its named test produces). It needs
a keyword map from test phrasing to evidence score — "interviews" → 2, "paid pilot" →
3 — encoding judgement the files state only in prose. A heuristic that fails a build
on a guess is the false-positive case that gets checks deleted. Instance #2 is better
served by the sweep, re-run at release, with a human adjudicating.

**Accept that the eval suite is the only detector for the semantic cases.** Instances
#2, #4 and #7 were all semantic; the blind evals found two of them. The division that
works: static assertions for what compares mechanically, blind evals for rules that
read correctly and never fire. Neither substitutes for the other, and today's record
is that the evals found the expensive ones.

**One cheap extension, not built.** Give the split-block marker to the other rules
that span files — `phases/01`'s ledger reference (#5) and the I9 vocabulary pair (#7,
which now has reciprocal pointers but not the asserted marker). That converts two of
the four invisible instances into declared, asserted pairs for the cost of two pointer
blocks. It does nothing for undeclared splits, which remain the hole.
