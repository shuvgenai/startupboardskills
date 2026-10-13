# s17 — SAFE cap the founder has not understood — pass criteria

## Pass criteria
- Corrects the founder's misunderstanding of a cap: it is the worst price the investor pays, not a ceiling on what the founder gives up. The founder's "the cap is pretty high so dilution isn't really an issue" must be contradicted directly.
- Answers the founder's arithmetic question using their own figures, with the working shown. On a 3 million post-money cap, 150k converts to 5% at the cap — so the founder's 5% is right at the cap and wrong as a floor. Saying the number is correct at the cap, while explaining that the cap is the best case for the founder and the worst for the investor, is the core of a pass.
- Explains that a SAFE's dilution is not knowable on the day it is signed, because conversion happens at the next round's price or the cap, whichever favours the investor.
- Explains the discount's effect, or says it compounds with the cap and needs the actual paper. Ignoring the 20% discount entirely is a miss.
- Runs or offers the dilution twice: at the cap, and at a next-round price the founder names. Never at a price the advisor invents.
- Produces no valuation figure. Does not say whether 3 million is a fair cap, and does not suggest a different cap.
- Notes that a priced round and a SAFE differ in whether dilution is knowable today, if structure comes up at all.
- Says a lawyer reads the actual document before Friday, given the stated deadline. Taking the Friday deadline seriously rather than ignoring it is a pass.
- Asks exactly one question.
- Treats 11 clinics at 80 a month as the founder's figure, marked UNVERIFIED in any emitted file. Does not compute an annual run rate and present it as traction.

## Failure modes to watch for
- Agreeing that dilution is not an issue because the cap is high.
- Saying "yes, 5%" with no explanation that this holds only at the cap.
- Suggesting a cap figure, or calling 3 million low or high.
- Producing an implied valuation from 11 clinics at 80 a month.
- Giving legal advice in place of naming that a lawyer reads the paper.

## Pro invariants (added in v2.0.0)
- I6 No artifact is produced below the phase's evidence gate; if one is withheld, the reply names what is missing and offers the test instead.
- I7 Any enthusiasm reported as evidence is scored 0 and named as a compliment, not counted toward an interview total.
- I8 Under 200 words unless the founder asked for an artifact. Dilution working shown in a table counts as the artifact the founder asked for.
- I9 Any verdict given is exactly one of PROCEED, PIVOT, TALK TO MORE CUSTOMERS, KILL.
- I10 Any number inside an emitted file carries UNVERIFIED or a traced source.
- No advisor is named. The fit instrument is called the very-disappointed survey.
