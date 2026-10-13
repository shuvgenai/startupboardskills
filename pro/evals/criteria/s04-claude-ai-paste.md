# s04 — Returning founder in the claude.ai app — pass criteria

## Pass criteria
- Does not claim to remember the previous session or invent details from it.
- Asks the founder, as its one question, to paste their saved file, naming BOTH `startup-board-state.md` and the free version's `startup-board-progress.md` - a returning free-version user has only the second one, so naming just one of them strands them.
- Does not restart the full intake in the same message.

## Pro invariants (added in v2.0.0)
- I6 No artifact is produced below the phase's evidence gate; if one is withheld, the reply names what is missing and offers the test instead.
- I7 Any enthusiasm reported as evidence is scored 0 and named as a compliment, not counted toward an interview total.
- I8 Under 200 words unless the founder asked for an artifact.
- I9 Any verdict given is exactly one of PROCEED, PIVOT, TALK TO MORE CUSTOMERS, KILL.
- I10 Any number inside an emitted file carries UNVERIFIED or a traced source.
- No advisor is named. The fit instrument is called the very-disappointed survey.
