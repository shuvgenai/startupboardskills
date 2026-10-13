# The state file

`startup-board-state.md` is the venture's memory between sessions. Read it at
the start of every session, write it at the end of every session.

**Where it lives.** In Claude Code, the founder's current folder. In the
claude.ai app you cannot see their files: if they say they have used Startup
Board before, ask them once to paste it in, and give it back as a file they
keep. Never pretend to remember a past session without the file in front of
you.

**In the app, ask for both filenames.** A founder returning from the free
version has `startup-board-progress.md` and has never had a state file. Ask
for "your `startup-board-state.md`, or the older `startup-board-progress.md`
if that is what you have" — then migrate per the rules at the end of this
file. Naming only the state file leaves a free-version user telling you they
cannot find a file they never had.

One venture, one file. A different idea gets its own file named
`startup-board-state-<short-idea-name>.md`. Never overwrite another idea's
file.

## The shape

Exactly these eight sections, in this order.

## Venture

One line on what it is. Founder. Current ladder stage. Date of last session.

## Fit ladder

| stage | status | evidence score | what would move it up |
|---|---|---|---|

Six rows, one per stage in `references/fit-ladder.md`.

## Assumption ledger

| id | assumption | riskiest? | test designed | test run | result | score |
|---|---|---|---|---|---|---|

Ids run `A1`, `A2`, `A3`. Exactly one row carries `riskiest? yes` at any time.
Everything else in the file that mentions an assumption refers to it by id.

## Evidence log

| date | source type | who | what they said or did | score | assumption id |
|---|---|---|---|---|---|

Append-only. One row per piece of evidence, scored against
`references/evidence-rubric.md`, pointing at the assumption it bears on.

## Numbers

| metric | value | as-of date | how it was measured | verified? |
|---|---|---|---|---|

Anything in `verified?` other than `yes` means the figure carries `UNVERIFIED`
wherever it appears in a document.

## Decisions

| date | decision | what it was based on | revisit when |
|---|---|---|---|

`revisit when` is a condition, not a date guess: "when 10 interviews are
done", "if churn passes 8%".

## Open loops

- [ ] one line per unresolved thing, carried into the next session

## Calibration

Dated lines only. Written when a verdict turns out to have been wrong.

---

# The three loops

## OPEN LOOP

Every session opens by asking about **exactly one** unresolved assumption or
one unrun test from the ledger.

**Not a recap.** A summary of last session is banned as an opening: it feels
helpful and it moves nothing. The founder already knows what they told you.
What they have not done is the test.

Pick the row that matters: the riskiest assumption with no test run, or the
test designed and never run. One question, then stop.

## CLOSE LOOP

When the founder reports a result:

1. Score it against `references/evidence-rubric.md`.
2. Append a row to the evidence log, pointing at its assumption id.
3. Update that assumption's `test run` and `result`.
4. Say in **one sentence** whether the fit ladder moved, and which stage.

A result that moves nothing still gets logged. That is information too.

## CALIBRATION LOOP

When later evidence overturns an earlier verdict, append a dated line to
`## Calibration` with three parts:

- what was believed, and the verdict it produced
- what actually happened
- which question would have caught it sooner

This is the only section that is about the advice rather than the venture. It
is how the next session gets sharper instead of just longer.

---

# Edit discipline: append-and-amend

A past entry is never silently rewritten.

A correction strikes the old value and dates it, in place:

| 2026-09-14 | survey | 24 active users | ~~38%~~ 29% (corrected 2026-10-12) | 3 | A2 |

The strike-through is the point. A reader must be able to see that the number
changed and when, because a verdict was given on the old one.

**Founder edits win.** If the file disagrees with what you last wrote, trust
the file and carry on from it.

---

# Migrating a v1 progress file

Startup Board v1 wrote `startup-board-progress.md`. Returning founders arrive
with one.

When you find `startup-board-progress.md` and there is no
`startup-board-state.md`:

1. Read it.
2. Carry its evidence-log rows into `## Evidence log`, its current stage into
   `## Fit ladder`, its riskiest assumption into `## Assumption ledger` as
   `A1`, and its next action into `## Open loops`.
3. Score every carried row against `references/evidence-rubric.md`. A row with
   too little detail to score gets `unknown (carried from v1)` in the score
   column — never a guessed score.
4. Write `startup-board-state.md`.
5. **Leave `startup-board-progress.md` untouched on disk.** Do not edit it, do
   not delete it, do not move it.
6. Tell the founder in one line: their history carried over, and where the new
   file is.

Then run OPEN LOOP as normal. The migration is not the session; it is the
first ten seconds of it.

Never ignore a v1 file you can see. Never overwrite one. If both files exist,
`startup-board-state.md` is the live one and the v1 file is history.
