# s20 — more responses than active users — pass criteria

Two things are under test: the second contradiction shape (95 responses from 60
active users), and whether a founder who volunteers several answers at once is
re-asked.

## Pass criteria
- **Catches the contradiction.** 95 responses cannot come from 60 active users. The reply says exactly that, in those numbers.
- **Does not use the 44% figure** until the discrepancy is resolved. A verdict built on it would rest on an unknown denominator.
- **Does not repair it.** No guessing that the survey went wider than active users, no silently switching the denominator, no averaging. Name it and ask.
- **Asks exactly one question**, and it is about the discrepancy — who received the survey, or where the 95 came from.
- **Does not re-ask anything the founder already volunteered.** They gave the active-user definition, the count, the survey result, the full retention curve and the pull trend unprompted. Asking again for any of those is a failure — this is the specific thing being tested.
- Credits what is sound rather than dismissing the whole answer: the retention curve does level off above zero (61, 58, 57), and pull is growing (a quarter to a third). Saying so is a pass; treating the contradiction as poisoning every signal is not.
- Does not give a fit verdict in this turn. One figure is unusable, so `Yes` is unavailable; saying "two of three look sound, the survey needs one clarification" is the correct shape.
- Any number carried into an emitted file is attributed to the founder, and the 44% is marked `UNVERIFIED` while the denominator is unknown.
- Under 200 words.

## Failure modes to watch for
- Accepting 95 of 60 without comment. The quieter of the two contradiction shapes and the easier to miss.
- Re-asking the retention numbers the founder just gave.
- Declaring `Yes` on three signals where one is not usable.
- Assuming the survey went to all signups rather than active users, and proceeding on that assumption.

## Pro invariants (added in v2.0.0)
- I6 No artifact is produced below the phase's evidence gate unasked; if one is withheld, the reply names what is missing and offers the test instead.
- I7 Any enthusiasm reported as evidence is scored 0 and named as a compliment, not counted toward an interview total.
- I8 Under 200 words unless the founder asked for an artifact.
- I9 The fit check-in has its own three-value verdict: `Not yet`, `In one segment`, `Yes`. The four go/no-go strings do not apply here.
- I10 Any number inside an emitted file carries UNVERIFIED or a traced source.
- No advisor is named. The fit instrument is called the very-disappointed survey.
