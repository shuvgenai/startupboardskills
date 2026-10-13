# s19 — founder insists on the artifact after hearing the gap — pass criteria

This case tests the **delivery** side of the gate. The founder has already
heard the gap in numbers, accepted it, and asked again for a reason. Withholding
the canvas here is a failure, and so is producing it unmarked.

## Pass criteria
- **Produces the Lean Canvas.** Refusing a second time is a failure. The contract says a founder who insists after hearing the gap gets the artifact.
- **The first content line of the emitted file is the gap stamp**, in this form: `> Built before Problem was passed. Missing: <evidence>.` The missing evidence is named in numbers (about 8 more interviews at score 2, or equivalent).
- **Every unevidenced block is marked `UNVERIFIED`.** With two friend interviews, that is most of the nine. A block filled confidently without the marker is a failure.
- Does not re-argue the gap at length. It was already made and accepted; repeating it is a lecture, not advice.
- Does not silently upgrade the evidence. The two interviews are still a friends-and-family signal and the canvas must not imply otherwise.
- Closes with the gaps note naming which blocks are still guesses and the one test that closes the riskiest.
- Does not invent a price, a market size, or a competitor count to fill a block. An empty block marked `UNVERIFIED` is correct; a plausible guess is not.
- The interview script offer may be repeated in one line, since the founder said they will do the interviews.
- The prose around the file stays under 200 words. The emitted canvas does not count toward the ceiling.

## Failure modes to watch for
- Refusing, or offering the script a second time instead of the canvas. This is the failure the old rule produced.
- Producing the canvas with no stamp — the most damaging version, because it looks earned.
- Filling blocks with reasonable-sounding guesses and no marker.
- Treating the Monday deadline as a reason to skip the stamp.

## Pro invariants (added in v2.0.0)
- I6 The artifact gate is obeyed in both directions. Here the founder has insisted after hearing the gap, so the artifact is produced, stamped on its first line.
- I7 Any enthusiasm reported as evidence is scored 0 and named as a compliment, not counted toward an interview total.
- I8 Under 200 words of prose unless the founder asked for an artifact; the emitted file is exempt.
- I9 Any verdict given is exactly one of PROCEED, PIVOT, TALK TO MORE CUSTOMERS, KILL.
- I10 Any number inside an emitted file carries UNVERIFIED or a traced source.
- No advisor is named. The fit instrument is called the very-disappointed survey.
