# Phase 05 — Verdict

**Purpose:** Give the founder a straight answer, bounded by the evidence rather than by how the conversation felt.
**Modules:** 08 founder strategy, 01 problem discovery, 06 metrics
**Entry condition:** Phase 02 done, or the founder asked for a verdict at any point.
**Pass gate:** 1 verdict from the four strings, 1 riskiest untested assumption named, 1 action for this week. Which verdicts are available is bounded by the evidence score below.
**Artifact:** none — the verdict goes in the state file
**Next phase:** `phases/06-mvp-blueprint.md` on PROCEED, `phases/00-intake.md` on PIVOT to a new problem, otherwise back to the open loop

## The four verdicts

- `PROCEED`
- `PIVOT`
- `TALK TO MORE CUSTOMERS`
- `KILL`

Never a fifth. Never a hedge. Never a refusal to answer.

## Which verdicts the evidence allows

Read the score on the **riskiest** assumption, not the best score in the file.

| Highest evidence score on the riskiest assumption | Verdicts available |
|---|---|
| 0 | `TALK TO MORE CUSTOMERS` or `KILL` only |
| 1 | `TALK TO MORE CUSTOMERS`, `PIVOT` or `KILL` |
| 2 | `PROCEED`, `PIVOT`, `TALK TO MORE CUSTOMERS` or `KILL` |
| 3 | any |

**A score of 0 can never reach `PROCEED`.** A founder who asks for a verdict on
turn one, with nothing behind the idea, gets `TALK TO MORE CUSTOMERS` — not a
refusal, not a hedge, and not an encouraging maybe. Say the verdict, then say
why in one line: there is nothing here yet that could be wrong, which means
there is nothing here yet that could be right.

`KILL` is available at every score and is a real verdict. Use it when the
evidence is in and it is bad — months of work with no score-3 signal, a problem
nobody has ever tried to solve, a market that has already answered. Withholding
it to be kind is not kindness; it bills the founder another year.

## The shape of the answer

Three parts, nothing else, under 200 words:

1. **The verdict**, as one of the four strings.
2. **The single riskiest untested assumption** — one sentence, by its ledger
   id.
3. **One action for this week** — specific enough to start today, sized for a
   solo founder. Ten conversations, a landing page, one survey sent to active
   users. Never "hire a growth team", never a to-do list.

Then mention in one line that build, launch, positioning and fundraising help
exist when they want them, and that after launch they can come back with real
numbers. Do not run those phases unprompted.

## When the gate is not met

The gate is unmet if you gave a verdict above what the score allows. That is
the failure this phase exists to prevent, and it is the comfortable one: the
conversation went well, the founder is likeable, the idea is interesting, and
`PROCEED` is the generous thing to say. It is not generous. It sends someone to
build on a score of 0.

Check the ledger before answering. If the riskiest assumption has no evidence
against it, the verdict is bounded whatever else is in the file.

## After the verdict

Write to `references/state-file.md`:

- the verdict and its date into `## Decisions`, with what it was based on and
  a `revisit when` condition
- the riskiest assumption into `## Assumption ledger` if it is not there
- the one action into `## Open loops`

If a later session overturns this verdict, run the CALIBRATION LOOP: append a
dated line to `## Calibration` saying what was believed, what happened, and
which question would have caught it sooner.
