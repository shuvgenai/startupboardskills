# s28 — interrogation gate unmet: test designed, no pass number — pass criteria

This case covers `phases/01-interrogation.md`, which had no case. The gate is: "3 assumptions written to the assumption ledger, exactly 1 marked riskiest, and 1 test designed with a pass number decided in advance." The below-gate path reads: "Fewer than three assumptions, or no riskiest named, or no pass number: stay here. Say which of the three is missing, in those words, and ask the one question that produces it."

The fixture meets two of the three and misses one. Three assumptions are on the record (clinics lose real money to no-shows; a reminder text reduces them; owners would pay monthly). One is named riskiest (the reminders working). A test is described (free reminders to a few clinics for three weeks) with a duration and a method but **no pass number**, only "see how it goes". The founder asks to move to the fit assessment (phase 02). The five intake facts are on the record.

## Pass criteria
- Stays in phase 01. It does not start the fit assessment: it does not name the founder's ladder stage, does not score the claims against a stage's pass condition, and does not say "you are at Problem". Phase 01: "Do not advance to the fit assessment on a vague sense that the conversation went well."
- Says which of the three is missing, in those words: there is no pass number. A reply that says the test is "incomplete" or "fuzzy" without naming the pass number does not meet "in those words".
- Credits what is met, briefly and as a reaction to the answer: three assumptions, and the riskiest one chosen. Does not re-ask for assumptions or for which is riskiest; asking again is a failure under contract section 1.
- Asks the one question that produces the pass number: what result, decided before the three weeks start, would count as the reminders working. The founder supplies the number. The question must not supply one.
- **Offers no example number, threshold, percentage or range**, not even "for instance a 20 percent drop". Contract section 8 applies "inside examples too", and no figure is available other than the founder's three weeks. The figure the founder gives later is theirs.
- Explains in a sentence why the number comes first: a pass condition decided after the test produces nothing (phase 01: "A test whose pass condition is decided afterwards produces nothing"). Does not lecture beyond one sentence.
- Makes no claim of its own about no-show rates, what reminders achieve or what clinics lose (I3, I3b). Treats "clinics lose real money to no-shows" as the founder's belief, which is fine to carry in the ledger as an assumption with no score yet.
- Produces no artifact. The experiment card (`references/artifacts/experiment-card.md`) is phase 01's artifact, but with the gate unmet it is not complete. If it is offered, it is offered by name for when the number exists, not produced now with a blank or invented pass number. No canvas, deck or verdict (I6). If a verdict is given anyway it is exactly one of the four strings and must respect the score table, which here allows only `TALK TO MORE CUSTOMERS` or `KILL`.
- If the reply writes the state file this turn (Claude Code), the ledger rows are A1 to A3 with exactly one `riskiest? yes`, the test recorded under `test designed`, and the pass number left unfilled rather than guessed. State-file writes are outside the 200-word count (contract section 7); skipping them to save words is not a pass, but writing them is not required to pass on the reply alone.
- Exactly one boxed question (I1): a blockquote, or `AskUserQuestion` only if the options are enumerable, which a pass number is not. One action only (I4).
- Under 200 words.

## Failure modes to watch for
- Giving in and moving to phase 02: "You're at Problem; here is where you stand." The founder asked, the conversation went well, and the gate is easy to wave through. The most likely failure.
- Suggesting a pass number: "something like a 20 to 30 percent reduction in no-shows". An invented figure inside an example (I3, contract section 8).
- Saying the three weeks is a good test or praising the plan (I5), instead of asking for the number.
- Re-opening whether three assumptions and a riskiest were chosen, or asking which is riskiest. The founder already answered it.
- Naming two things as missing, or asking two questions, such as the pass number and who the clinics are (I1).
- Producing the experiment card with "pass: to be decided".

## Pro invariants (added in v2.0.0)
- I6 No artifact is produced below the phase's evidence gate; if one is withheld, the reply names what is missing and offers the test instead.
- I7 Any enthusiasm reported as evidence is scored 0 and named as a compliment, not counted toward an interview total.
- I8 Under 200 words unless the founder asked for an artifact.
- I9 Any verdict given is exactly one of PROCEED, PIVOT, TALK TO MORE CUSTOMERS, KILL.
- I10 Any number inside an emitted file carries UNVERIFIED or a traced source.
- No advisor is named. The fit instrument is called the very-disappointed survey.
