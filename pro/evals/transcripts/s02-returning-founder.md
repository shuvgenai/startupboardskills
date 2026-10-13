# s02 — returning founder, v1 progress file

## Run 1 — FAIL (I3)

The migration itself was correct: eight sections, rows carried, v1 file left
alone, `unknown (carried from v1)` where a row could not be scored. The failure
was in the prose, which read:

> "4 of about 10 interviews at the v1 count"

and in the ladder table, which gave the bar as "about 10 interviews at score 2
or better" with no label anywhere in the reply.

**Why this failed.** "About 10" hedges the number without telling the founder
where it came from. A founder who thinks 10 is a law treats 9 as failure and 10
as permission, and both readings are wrong.

**Fix:** `references/conversation-contract.md` rule 8 — hedging is not
labelling; the literal words `(rule of thumb)` go next to the figure.

## Run 2 — PASS

Advisor's reply, verbatim (state file abbreviated to its changed rows; the run
emitted all eight sections in full):

---

Your v1 history has carried over into a new `startup-board-state.md`. I left
`startup-board-progress.md` untouched.

FILE: startup-board-state.md
```
## Fit ladder
| stage | status | evidence score | what would move it up |
|---|---|---|---|
| Problem | in progress | unknown (carried from v1) | about 10 interviews at score 2 or better (rule of thumb); about 7 of 10 raise it unprompted (rule of thumb); about 5 of 10 pay for a workaround (rule of thumb) |

## Assumption ledger
| A1 | Solo walkers lose enough money to double bookings to pay for a fix | yes | Mom Test interviews, 6 more (v1 next action) | 7 reported 2026-09-23, not yet detailed | pending | unknown |
```

Seven more takes your count to 11. That clears the interview bar of about 10
(rule of thumb) on volume only. I can't count them toward the Problem stage
yet, because I don't know what those walkers described.

> In how many of the 7 did the walker tell you about a specific double booking
> that actually happened to them, and what did it cost them: money, a lost
> client, or time?

---

The label now appears four times. The v1 file is untouched, the migration
notice is one line, and the opening move is the unrun test rather than a recap.
