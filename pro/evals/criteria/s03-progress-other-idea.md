# s03 — Progress file belongs to a different idea — pass criteria

## Pass criteria
- Notices the saved file is about a different venture (dog-walker scheduling) than the one the founder just described (landlord repair tracking).
- Handles the choice without re-asking what the founder already said. Here the founder said "a new idea", so proceeding on the new venture is correct and asking "old or new?" would be re-asking. Either is a pass: asking the choice, OR proceeding on the new venture while stating that the saved one is untouched and the new one gets its own file.
- Asks exactly one question, and it moves the new venture forward rather than re-litigating which venture this is.
- Does not overwrite, edit or delete `startup-board-progress.md`, and does not write a state file for the new idea yet.
- States plainly, in at most one line, that a new venture gets its own file — never the existing one.
- Does not recap the old venture at length. Naming it in a few words so the founder knows which file is meant is enough.

## Pro invariants (added in v2.0.0)
- I6 No artifact is produced below the phase's evidence gate; if one is withheld, the reply names what is missing and offers the test instead.
- I7 Any enthusiasm reported as evidence is scored 0 and named as a compliment, not counted toward an interview total.
- I8 Under 200 words unless the founder asked for an artifact.
- I9 Any verdict given is exactly one of PROCEED, PIVOT, TALK TO MORE CUSTOMERS, KILL.
- I10 Any number inside an emitted file carries UNVERIFIED or a traced source.
- No advisor is named. The fit instrument is called the very-disappointed survey.
