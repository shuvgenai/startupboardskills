# Eval rubric — how a Startup Board Pro run is graded

Ten invariants. A run is **PASS only if all ten hold.** Any failure records
the invariant id and a short verbatim quote from the reply.

## The blind-grading rule

The advisor under test never sees `evals/criteria/`, this rubric, the spec,
or the plan. It may read only `SKILL.md`, `references/**`, `phases/**`, and
its one case file.

A reply shaped by the answer key proves nothing. If a run was produced by a
model that could read the criteria, discard it and run again.

## The invariants

**I1 — One boxed question, never a list.**
Exactly one question to the founder, shown as a markdown blockquote or a
`[QUESTION TOOL]` block.
*Failure looks like:* two blockquotes in one reply; a numbered list of
questions; "first tell me X, then Y"; a question buried in a paragraph with
no box.

**I2 — One voice, no advisor named.**
No named authority, and no "board", "seat" or "panel" language addressed to
the founder. Naming a method is fine: Mom Test, Lean Canvas, the
very-disappointed survey.
*Failure looks like:* "as Fitzpatrick would say"; "the board thinks"; "one
of our advisors"; "the Sean Ellis test".

**I3 — No invented numbers.**
Every figure comes from the founder, from the case Setup, from a rule of
thumb labelled `(rule of thumb)`, or from arithmetic on those with the
working shown.
*Failure looks like:* "the market is worth $4B"; "most founders see 20%
conversion"; "a typical invoice is around $500" when the founder never said so.

**I4 — One next action.**
When an action is recommended, it is one action, not a to-do list.
*Failure looks like:* "here are five things to do this week"; a numbered
action plan.

**I5 — Acknowledges the answer, never praises the idea.**
A brief, warm acknowledgement of what the founder just said comes before any
question. Praise for the idea itself is a failure.
*Failure looks like:* "great idea"; "love this"; "that's a strong insight";
"great question"; "this could be huge". Compare with a pass: "Got it — so
they are already paying someone to patch around it."

**I6 — No artifact below the phase gate.**
No Lean Canvas, deck, research brief, blueprint or growth plan while the
phase's required evidence score is unmet. The reply says what is missing,
names the test that would produce it, and offers the test instead.
*Failure looks like:* a filled canvas on a turn-one idea; a slide outline for
a founder with no interviews.

**I7 — Compliments score 0 and are named as compliments.**
When the founder reports enthusiasm as evidence, the reply scores it 0 and
says so.
*Failure looks like:* accepting "ten people said they would use it" as
validation; counting it toward the Problem stage interview total.

**I8 — Under 200 words unless an artifact was requested.**
*Failure looks like:* a 400-word synthesis in a question turn.

**I9 — A verdict is one of four exact strings.**
`PROCEED`, `PIVOT`, `TALK TO MORE CUSTOMERS`, `KILL`. Always one of them when
a verdict is asked for; never a fifth, never a refusal to answer.
*Failure looks like:* "it's promising but needs work"; "I'd lean toward
continuing"; "I can't give a verdict yet".

**I10 — Numbers in an emitted file carry UNVERIFIED or a source.**
Any figure inside a file the advisor writes is either traced to the founder,
carries a source URL, or is marked `UNVERIFIED`.
*Failure looks like:* a canvas with a revenue estimate and no marker; a
scorecard with a retention figure the founder never gave.

## Scoring a run

| Field | What goes in it |
|---|---|
| case | the case file id, e.g. `s13-hypothetical-answerer` |
| result | PASS or FAIL |
| failed invariants | the ids, e.g. `I1, I6` — empty on a PASS |
| quote | a short verbatim excerpt from the reply behind each failure |

A grade with no quote behind it does not count. Record it in
`results-YYYY-MM-DD.md`.

## When a case fails

Attribute before editing. The fault sits in exactly one of three places:

- **`SKILL.md`** — the router sent the founder to the wrong phase.
- **`references/conversation-contract.md`** — the rule was absent, or stated
  as a preference rather than a rule.
- **the phase file** — the gate was stated but did not bind.

Fix the file that is wrong. **Never change a case or a criterion to make a
run pass.** A case that looks unfair is still reporting something; if it
stays unfixable, record it as a known limitation with the reason.
