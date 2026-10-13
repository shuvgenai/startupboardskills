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
*Failure looks like:* naming any of the twenty-four source thinkers; "the
board thinks"; "one of our advisors"; calling the fit survey by the name of the
person it is usually named after, instead of the very-disappointed survey.

**I3 — No invented numbers.**
Every figure comes from the founder, from the case Setup, from a rule of
thumb labelled `(rule of thumb)`, or from arithmetic on those with the
working shown.
*Failure looks like:* "the market is worth $4B"; "most founders see 20%
conversion"; "a typical invoice is around $500" when the founder never said so.

**I3b — No invented general claims.**
A statement about how markets, categories, channels or founders behave is
scored exactly as a figure is: sourced, labelled `(rule of thumb)` at the
point of use, or absent. Digits are not what makes a claim a claim.
*Failure looks like:* "a crowded category usually means people pay for the
job"; "most consumer apps die at the retention step"; "founders who cannot
name a competitor have not looked" — plausible, unsourced, unlabelled, and
heard by the founder as permission.

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

**I6 — The artifact gate is obeyed in both directions.**
Below the gate and unasked: no Lean Canvas, deck, research brief, blueprint or
growth plan. The reply says what is missing in numbers, names the test, and
offers the test instead.
Below the gate and the founder has insisted after hearing that: the artifact
**is** produced, and its first line is the gap stamp
`> Built before <Stage> was passed. Missing: <evidence>.`
At or above the gate: produced on request, and withholding it is a failure too.
*Failure looks like:* a filled canvas on a turn-one idea; a slide outline for a
founder with no interviews; an unstamped artifact after the founder insisted;
refusing an artifact the founder has earned.

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

## Re-running the suite after a model update

This is the undertaking the paid edition rests on, so the suite is built to run
from wherever it was installed.

```
sh evals/check.sh all
```

It must pass in all three layouts, and a release is not shippable until it
does:

| Layout | Where the suite sits |
|---|---|
| Build tree | `pro/evals/`, with `.claude-plugin` and `CHANGELOG.md` beside it |
| Plugin install | `skills/startup-board-pro/evals/`, with those files two levels up |
| Unpacked ZIP | `evals/`, with those files beside it |

The checker resolves the package root by walking up from the skill folder, so
the plugin manifests and the changelog are found in any of the three. A failure
caused by layout rather than by drift is the worst possible outcome of a
re-run: the buyer cannot tell which they are looking at. That is why this is
asserted rather than assumed.

Then run the 20 behavioural cases per `RUNBOOK.md` and publish a dated results
file beside this one.

## Writing a criterion

Two mistakes were made repeatedly while these keys were written, and both
produced false failures:

1. **Requiring more than one turn's work.** A key that demands the gate named,
   the arithmetic run, the artifact offered and a question asked, all in one
   reply, fights the one-question rule and the 200-word ceiling. Split it: say
   what this turn must do, and allow a correctly sequenced reply to defer the
   rest with a signal that it is coming.
2. **Carrying a rule the product changed.** Three keys inherited from the free
   version demanded retired markers, old stage names, and the old progress
   filename. A key must be read in full against the current spec, not appended
   to.

When a key and a global constraint disagree, the constraint wins and the key is
corrected — but record it, and never correct a key simply because a run failed
it.

## When a case fails

Attribute before editing. Name the file, then fix that file. In practice the
fault has sat in five different places, and two of the first four were outside
the three obvious ones:

- **`SKILL.md`** — the router sent the founder to the wrong phase, or an
  instruction there was incomplete.
- **`references/conversation-contract.md`** — the rule was absent, or stated as
  a preference rather than a rule.
- **the phase file** — the gate was stated but did not bind.
- **`references/evidence-rubric.md`** — a dodge the rubric never scored. This
  is where the founder's-own-experience failure lived.
- **`references/state-file.md`** or **`references/artifacts-index.md`** — a
  mechanic the skill relies on but never specified, such as which filename to
  write or which file to ask for.

A failure can implicate two files at once; fix both, and name both.

Fix the file that is wrong. **Never change a case or a criterion to make a
run pass.** A case that looks unfair is still reporting something; if it
stays unfixable, record it as a known limitation with the reason.
