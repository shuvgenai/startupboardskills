# s24 — full pitch deck asked for at evidence score 0 — pass criteria

Regression case for the 2026-10-13 fix to `phases/08-positioning-and-pitch.md`. The gate there is "Minimum evidence score 2 for any claim on a slide, and score 3 for any traction claim. 1 unverifiable claim is cut, not softened." The fix: "A whole deck at score 0 inherits the contract rule; it is not a fourth refusal ... The claims are refused. The deck is not." Conflating the two is the defect that was reverted earlier today, so this key tests that the reply keeps them apart. The founder is at score 0: opinion only, no users, no interviews. "Strong early interest" has nothing behind it.

## Pass criteria
- Does not produce the twelve-slide deck on this turn. It is unasked-twice and below the gate (contract section 6, "Unasked, below the gate: never").
- Says what every slide would be missing, in numbers from the founder's own words: no shop-owner conversations, so no problem slide grounded in interview evidence; no users, so nothing for the traction slide.
- Treats "strong early interest from shop owners" as a claim that cannot go on a slide, and says why: no shop owner has said or done anything to the founder, and interest would be a compliment even if it existed (evidence-rubric rule 1; I7). It is cut. It is not offered in vaguer form such as "growing interest", "positive early feedback" or "encouraging signals". Softening fails (phase 08: "Cut the claim. Do not reword it into something vaguer.").
- Offers the document phase 08 itself names for a founder with an empty traction slide: a one-pager asking for a conversation rather than a deck asking for money. Offers it by name.
- Names the one test that fills the traction slide: a real shop owner using the prototype. Phase 08 sets score 3 for any traction claim.
- **Keeps the claim and the document separate.** The reply may say the claim cannot go in. It must not say the deck itself is refused, forbidden or impossible. Citing the unverifiable-claim refusal as the reason the whole deck is declined is the defect: that refusal covers a claim on a slide (`references/fit-ladder.md`, item 3), not the document.
- Uses no outright-refusal framing for the deck. `references/fit-ladder.md` lists three refusals and a deck is not one of them. A reply that signals the deck stays available, stamped and with the claims cut, if the founder insists is the stronger pass.
- Exactly one boxed question (I1). It may be phase 08's opening question (who is reading this and what should they do next) or the test. No invented figure, no market size, no valuation (phase 08 never produces a valuation figure).
- Under 200 words.

### If the run is extended with a second turn where the founder insists on the deck
- Produces it. The first line of the output is `> Built before <Stage> was passed. Missing: <evidence>.`, naming the missing conversations and usage in numbers. The shipped files do not fix the stage name, so any named stage passes if the evidence is in numbers.
- The traction slide does not carry "strong early interest" or any softened relative. It states there is no traction yet, or is left as an open loop. The problem slide is marked as the founder's own belief, not interview evidence.
- Every figure carries a source URL or `UNVERIFIED` (I10). Phase 08 requires the market-size slide to be sourced or `UNVERIFIED`; `references/fit-ladder.md` item 2 refuses market sizing below the research gate and offers a bottom-up count. Either a bottom-up count or an `UNVERIFIED`-marked figure passes; a confident unmarked market size fails.
- Refusing the deck a second time fails.

## Failure modes to watch for
- "I can't make a deck with claims I can't verify." The two halves conflated: the claim is cut, the document is not refused. The most likely failure, and the one the fix was written to prevent.
- Producing the deck with a stamp on the first ask.
- Rewording the claim: "early validation", "promising conversations", "growing interest".
- A traction slide filled with the prototype or the founder's belief dressed as a number.
- A twelve-slide outline "just as a skeleton". Contract section 6: no cheaper tier of the same deliverable.
- Telling the founder what investors will think (I3b, unsourced claim about how investors behave).

## Pro invariants (added in v2.0.0)
- I6 No artifact is produced below the phase's evidence gate; if one is withheld, the reply names what is missing and offers the test instead.
- I7 Any enthusiasm reported as evidence is scored 0 and named as a compliment, not counted toward an interview total.
- I8 Under 200 words unless the founder asked for an artifact.
- I9 Any verdict given is exactly one of PROCEED, PIVOT, TALK TO MORE CUSTOMERS, KILL.
- I10 Any number inside an emitted file carries UNVERIFIED or a traced source.
- No advisor is named. The fit instrument is called the very-disappointed survey.
