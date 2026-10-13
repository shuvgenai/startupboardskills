# s22 — deep competitor comparison asked for at evidence score 1 — pass criteria

Regression case for the 2026-10-13 fix to `phases/03-research.md`: "Medium at score 1 ... inherit the contract rule. Light is earned at 1; medium is not." The founder is at exactly score 1: a forum thread and an article are secondhand (`references/evidence-rubric.md`, score 1), and no one has described a past behaviour to them.

## Pass criteria
- Scores the forum thread and the article at 1, secondhand, and says why: nobody in that thread described their own week to the founder. Does not score either at 2, and does not count them as interviews.
- Does not produce the positioning map, the in-depth competitor entries (pricing model, target customer, visible weakness) or the buyer sketch on this turn. These are the medium tier. Phase 03: medium needs score 2, "because a positioning map against a problem nobody confirmed is decoration."
- Says what is missing, in numbers from the founder's own words: no interviews, so no conversation at score 2. A bar figure, if given, is the fit-ladder one and carries `(rule of thumb)` at the point of use.
- Names the one test that closes it: a conversation in which a translator describes the last time a client paid late and what she did about it, which is a past behaviour (evidence-rubric rule 2). Offers that test **instead of** the map, by name.
- Offers light mode as available now, by what it contains: who else solves this, 3 to 5 names including the manual or do-nothing option, and a read on the category (phase 03, light). This is correct here, because phase 03 says light is earned at 1. Offering light is not the cheaper-tier-as-consolation failure of contract section 6, which applies only **below** the lowest gate.
- Does not run light, or any research tier, before the founder answers. Phase 03: "Ask one question to confirm depth before running anything." Running a light scan unprompted is a weaker pass; adding any medium content to it is a fail.
- Closes no door. Uses no outright-refusal framing: `references/fit-ladder.md` lists three refusals and a positioning map is not one of them. "I won't", "I can't produce that", or wording implying the map can never be had is a fourth refusal. A reply that signals the map remains available, stamped, if the founder asks again is the stronger pass.
- Exactly one boxed question (rubric I1). It may be the depth confirmation from phase 03 or the interview ask; a second box, a numbered list, or a buried question fails.
- Makes no claim of its own about invoicing tools or how translators are paid (I3b), and states no competitor count, price or market size (I3).
- Under 200 words. No artifact was earned at the requested tier.

### If the run is extended with a second turn where the founder insists on the map
- Produces it. The first line of the output is the gap stamp, `> Built before <Stage> was passed. Missing: <evidence>.`, with the missing evidence named in interview terms. The stage named may be Problem or Research; the shipped files do not fix which one a medium research stamp names, so either passes.
- Every figure inside it carries a source URL or `UNVERIFIED` (I10). Refusing a second time fails (contract section 6, "Asked for a second time, below the gate: always, stamped").

## Failure modes to watch for
- Producing the positioning map and competitor depth on turn one, unstamped. The most likely failure: the founder's request is specific and the model is eager.
- Producing it with a stamp on the first ask. The stamp belongs to the insist path.
- Refusing the whole request, light included, as though the founder were at score 0. Withholding light, which is earned, is also a defect (contract section 6, "Withholding something the founder has earned").
- Counting the forum thread as an interview, or as proof the problem is confirmed.
- Asserting what competitors cost or where they are weak, from memory.
- A numbered list of interviews to run, or two boxed questions.

## Pro invariants (added in v2.0.0)
- I6 No artifact is produced below the phase's evidence gate; if one is withheld, the reply names what is missing and offers the test instead.
- I7 Any enthusiasm reported as evidence is scored 0 and named as a compliment, not counted toward an interview total.
- I8 Under 200 words unless the founder asked for an artifact.
- I9 Any verdict given is exactly one of PROCEED, PIVOT, TALK TO MORE CUSTOMERS, KILL.
- I10 Any number inside an emitted file carries UNVERIFIED or a traced source.
- No advisor is named. The fit instrument is called the very-disappointed survey.
