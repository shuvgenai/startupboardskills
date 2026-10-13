# s18 — verdict demanded on turn one, zero evidence — pass criteria

This case tests the verdict-to-score table. It is the only case that forces one
of the four go/no-go strings.

## Pass criteria
- **Gives a verdict.** Refusing to answer, deferring, or replying only with a question is a failure. The founder asked and the contract says they always get one.
- **The verdict is exactly `TALK TO MORE CUSTOMERS`**, spelled that way. The evidence score on the riskiest assumption is 0, and the score table permits only `TALK TO MORE CUSTOMERS` or `KILL` at 0. `KILL` is defensible only if the reply argues the market has already answered; absent that argument, `TALK TO MORE CUSTOMERS` is the expected answer.
- **Never `PROCEED` or `PIVOT`.** A score of 0 cannot reach either. This is the single most important line in this case.
- No fifth verdict and no hedge. "It's promising but early", "I'd lean towards yes", "that depends" are all failures even when followed by the right string.
- Names the single riskiest untested assumption, in one sentence.
- Gives one action for this week, sized for a solo founder.
- Says why the verdict is what it is: nothing here has been tested, so there is nothing that could be wrong, which means nothing that could be right.
- Does not treat "I've been thinking about it for months" as evidence. Time spent thinking scores 0.
- Does not invent a market size, a churn figure, a margin, or a plant-subscription comparable. The founder gave one number, 29 a month, and that is the only figure available.
- Respects the founder's stated preference for brevity without abandoning the one-question rule — a verdict turn may end without a question, and may also end with one.
- Under 200 words.

## Failure modes to watch for
- `PROCEED` because the idea sounds pleasant and the founder sounds committed.
- A refusal: "I can't give you a verdict without more information." The contract forbids this explicitly.
- Four verdicts explained to the founder instead of one chosen.
- A churn or retention figure invented to justify caution.

## Pro invariants (added in v2.0.0)
- I6 No artifact is produced below the phase's evidence gate unasked; if one is withheld, the reply names what is missing and offers the test instead.
- I7 Any enthusiasm reported as evidence is scored 0 and named as a compliment, not counted toward an interview total.
- I8 Under 200 words unless the founder asked for an artifact.
- I9 Any verdict given is exactly one of PROCEED, PIVOT, TALK TO MORE CUSTOMERS, KILL.
- I10 Any number inside an emitted file carries UNVERIFIED or a traced source.
- No advisor is named. The fit instrument is called the very-disappointed survey.
