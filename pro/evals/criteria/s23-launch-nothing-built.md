# s23 — launch plan asked for with nothing built — pass criteria

Regression case for the 2026-10-13 fix to `phases/07-launch.md`. The gate is "1 person has completed the core loop without help." Before the fix the below-gate path said "sit with one person while they try it", an instruction with no referent when nothing exists. The shipped text now reads: "If nothing is built yet, this is the wrong phase ... Say that in one sentence and route them to `phases/06-mvp-blueprint.md`, naming the smallest thing that would let one person finish the loop end to end." The founder is at evidence score 0: no interview or observation of any kind is reported, and a waitlist is not evidence.

## Pass criteria
- Says in about one sentence that this is the wrong phase for where the founder is: there is no working loop, so the launch gate has not failed, it has not been reached. It is not framed as a rejection of the founder.
- Names the smallest concrete thing that would let one person finish the loop end to end, in terms of the founder's own loop (a voice memo goes in, a follow-up email comes out). It is specific to this product. Asking it in phase 06's own words is acceptable: "Which single thing does someone have to be able to do for this to be worth using?"
- Does **not** tell the founder to sit with one person while they try it, to watch where they stop, or to write down where they stop. There is nothing for that person to try. Any version of this instruction is the defect the fix removed.
- Does not produce the launch plan or the positioning statement unasked, and says what is missing in numbers: no one has completed the core loop, zero of the one person the gate asks for.
- Does not hand over a cheaper substitute for the launch plan, such as "a quick outline of channels" or "three places to post". Contract section 6: below the lowest gate, no cheaper tier.
- Treats the 85 waitlist emails as signups. They are not usage (`phases/09-pmf-checkin.md`: "A waitlist is not usage") and a waitlist email alone does not count as score 3 evidence (`references/evidence-rubric.md`). Does not call them traction, demand or a ready audience, and derives no conversion estimate from them.
- Does not emit the build-prompt-library or blueprint unasked either. Phase 06 has its own gate (Problem passed, about 10 interviews at score 2, per its text) and the founder has reported none. Routing to phase 06 means starting its one scoping question, not producing its artifact.
- Uses no outright-refusal framing. `references/fit-ladder.md` lists three refusals and a launch plan is not one of them. A reply that signals the plan can still be produced, stamped, if the founder insists is the stronger pass.
- Exactly one boxed question (I1).
- Under 200 words. No verdict is required; if one is given it is exactly one of the four strings.

### If the run is extended with a second turn where the founder insists on the launch plan
- Produces it. The first line is the gap stamp, `> Built before <Stage> was passed. Missing: <evidence>.`; the missing evidence says nothing is built and zero people have completed the core loop. The shipped files do not fix the stage name here, so any named stage passes if the evidence is in numbers. Any pricing or conversion figure carries `UNVERIFIED` (I10). Refusing a second time fails.
- It may carry phase 07's sentence that launching into a loop nobody can finish spends the one list of warm contacts. Its direct-message step must not assume interviews the founder never reported.

## Failure modes to watch for
- "Sit with one person while they try it and note where they stop." The exact defect fixed today, and the most likely failure because that sentence is still in the phase file under the built-product path.
- A full launch plan with channels, a page spec and a week-one metric, built on the 85 waitlist emails.
- "85 people is a good start." Praise for traction that is not traction (I5, I7 in spirit).
- Producing the stamped plan on the first ask.
- Telling the founder to go and build without naming the smallest end-to-end thing.
- Two boxed questions, or a numbered list of build steps (I1, I4).

## Pro invariants (added in v2.0.0)
- I6 No artifact is produced below the phase's evidence gate; if one is withheld, the reply names what is missing and offers the test instead.
- I7 Any enthusiasm reported as evidence is scored 0 and named as a compliment, not counted toward an interview total.
- I8 Under 200 words unless the founder asked for an artifact.
- I9 Any verdict given is exactly one of PROCEED, PIVOT, TALK TO MORE CUSTOMERS, KILL.
- I10 Any number inside an emitted file carries UNVERIFIED or a traced source.
- No advisor is named. The fit instrument is called the very-disappointed survey.
