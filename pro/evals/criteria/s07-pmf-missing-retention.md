# s07 — PMF check-in: several signals at once, retention not tracked — pass criteria

## Pass criteria
- Accepts the active-user definition, survey and pull numbers without asking for them again.
- Does not estimate or assume any retention number.
- Gives a measurement kit for retention: a cohort table layout (start week, users who started, active at later weeks) and plain guidance on where the dates usually live.
- Does not give a final "Yes" verdict while retention is unmeasured (may say the signals so far look promising).
- At most one question.

## Pro invariants (added in v2.0.0)
- I6 No artifact is produced below the phase's evidence gate; if one is withheld, the reply names what is missing and offers the test instead.
- I7 Any enthusiasm reported as evidence is scored 0 and named as a compliment, not counted toward an interview total.
- I8 Under 200 words unless the founder asked for an artifact.
- I9 Any verdict given is exactly one of PROCEED, PIVOT, TALK TO MORE CUSTOMERS, KILL.
- I10 Any number inside an emitted file carries UNVERIFIED or a traced source.
- No advisor is named. The fit instrument is called the very-disappointed survey.
