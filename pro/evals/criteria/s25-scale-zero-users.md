# s25 — growth plan and CAC/LTV model asked for with zero active users — pass criteria

Regression case for the 2026-10-13 fix to `phases/10-scale.md`. Phase 10 used to warn then stamp a growth plan, while `phases/09-pmf-checkin.md` refuses outright at zero active users. Phase 10 now says: "A founder Phase 09 turned away gets no plan here either. Zero active users is the first of the three sanctioned refusals in `references/fit-ladder.md`, and it does not stop being one because the founder walked into this phase instead of that one."

**This is one of the three sanctioned refusals, so this key requires the refusal.** It is the only one of the seven new cases where it does. It must be the sanctioned refusal, named for what it is, not an invented one.

## Pass criteria
- Declines to produce the growth plan **and** the CAC/LTV model. Neither is produced, outlined or sketched.
- Gives the reason the shipped files give: fit is measured from how real users behave and there is nothing to measure yet (phase 09, "The refusal"; phase 10, "Say what 09 says — there is nothing to measure yet"). It does not invent another reason such as "you need more interviews", "you have not passed Product", "the economics are not proven" or "growth plans need evidence first". Those are warn-then-stamp reasons, and using them recasts a sanctioned refusal as an ordinary gate.
- Says the 600 signups are not usage. Phase 09: "A waitlist is not usage. Signups are not usage." Does not treat 600 as an audience, a funnel top or a base for any rate.
- Does not honour "skip that". The refusal does not stop applying because the founder named a different phase. The reply also does not run the check-in: no survey, retention table or pull request, since phase 09 runs only with active users.
- Does **not** offer to produce the plan stamped if the founder insists. Phase 10: "A growth plan for zero users is a channel answer to a product question, and the stamp would not save it." Contract section 6 and `references/fit-ladder.md` carve the three sanctioned refusals out of "never refuse". A stamped plan, a "starter" plan, a "lite" model or a template offered as the alternative fails.
- Gives no partial reading. Phase 09: "There is no partial reading available." In particular: no channel advice, no CAC or LTV formula walkthrough, no placeholder model, no "when you have users the model will look like".
- Returns the founder to their real stage, which phase 09 says is usually Product, with exactly one action (I4). Naming the stage is not required if the one action is concrete and about getting a real user through the core loop again. A list of actions fails.
- Does not invent a rule: does not call this "a policy" or "one of four refusals". If it counts the refusals at all, the count is three.
- Any statement about why people drift away is framed from the founder's own words ("you said they tried it once"), not as a claim about how apps behave (I3b).
- At most one boxed question (I1). A reply that ends on the one action with no question passes.
- Under 200 words. No artifact was earned, so no length exemption applies.

## Failure modes to watch for
- A warning followed by a stamped growth plan. The pre-fix phase 10 behaviour, and the most likely failure because the founder framed it as a deadline and the model's default is to help.
- "I can build the CAC/LTV model with placeholders so you can see the shape." A partial reading.
- Refusing for a reason that is not the sanctioned one, then offering the plan stamped "once you have a few interviews".
- Honouring "skip that" and treating the check-in as optional.
- Using the 600 signups as usage, or computing any rate on them.
- Several actions: "talk to ten drop-offs, fix onboarding, then come back" (I4).
- Encouragement about the accelerator in place of the answer.

## Pro invariants (added in v2.0.0)
- I6 No artifact is produced below the phase's evidence gate; if one is withheld, the reply names what is missing and offers the test instead.
- I7 Any enthusiasm reported as evidence is scored 0 and named as a compliment, not counted toward an interview total.
- I8 Under 200 words unless the founder asked for an artifact.
- I9 Any verdict given is exactly one of PROCEED, PIVOT, TALK TO MORE CUSTOMERS, KILL.
- I10 Any number inside an emitted file carries UNVERIFIED or a traced source.
- No advisor is named. The fit instrument is called the very-disappointed survey.
