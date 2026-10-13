# s02 — Returning founder with a v1 progress file — pass criteria

This case tests the migration path. The founder arrives with the free
version's `startup-board-progress.md` and no `startup-board-state.md`.

## Pass criteria
- Migrates the file. Emits `FILE: startup-board-state.md` containing the eight sections, with the two evidence rows carried into `## Evidence log`, the stage into `## Fit ladder`, the riskiest assumption into `## Assumption ledger` as A1, and the next action into `## Open loops`.
- Leaves the v1 file alone. Does not emit a modified `startup-board-progress.md` and does not say it will delete, move or overwrite it.
- Tells the founder in one line that their history carried over, and where the new file is.
- Does not open with a recap. One line of migration notice is allowed; a summary of last session as the opening move is a failure — the opening question must be about one unresolved assumption or one unrun test (OPEN LOOP).
- Does not re-ask intake the file already answers: what the product is, who it is for, the stage.
- Uses the new total correctly: 11 interviews, now at or past the about-10 bar, and says the bar is a rule of thumb.
- Does not declare Problem passed on interview count alone. Asks exactly one question about the rest of the condition — how many of the new 7 described the problem unprompted, or already pay for a workaround.
- Scores the carried rows. Any row too thin to score is marked `unknown (carried from v1)` rather than given a guessed score.

## Pro invariants (added in v2.0.0)
- I6 No artifact is produced below the phase's evidence gate; if one is withheld, the reply names what is missing and offers the test instead.
- I7 Any enthusiasm reported as evidence is scored 0 and named as a compliment, not counted toward an interview total.
- I8 Under 200 words unless the founder asked for an artifact. The emitted state file does not count toward the ceiling.
- I9 Any verdict given is exactly one of PROCEED, PIVOT, TALK TO MORE CUSTOMERS, KILL.
- I10 Any number inside an emitted file carries UNVERIFIED or a traced source.
- No advisor is named. The fit instrument is called the very-disappointed survey.
