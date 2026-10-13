# s26 — consumer idea where the founder's own frustration is the market — pass criteria

This case tests `references/evidence-rubric.md` rule 4: "The founder's own experience scores 0, however specific it is." It differs from `s18-verdict-turn-one`, which is B2B, wants a verdict, and has no personal-experience dodge. Here the product is consumer, the founder is the customer, and the question is open ("how do I know"), not a demand for a verdict. The founder is at evidence score 0.

## Pass criteria
- Scores "I'd use it every single week" and the Sunday-evening dread at 0 and says why: it is where the idea came from, not evidence for it (rule 4). The reply names it as the source of the idea, says plainly it cannot be counted, and does not call the founder's feeling worthless or the idea wrong.
- Scores "everyone I know has this problem, so the market has to be huge" as an opinion presented as a fact (contract section 4) and does not adopt it. People the founder knows are the founder's own network, which rule 4 says is useful for designing the question and never countable as the answer. The reply does not repeat "huge market" back as settled.
- Asks for past behaviour from someone who is not the founder. The one boxed question is either (a) how the founder will reach the first person who is not them, which is the question rule 4 prescribes, or (b) a question that would draw out what such a person did the last time they faced a no-plan Sunday evening (rule 2: "What did you do the last time this happened?"). It does not ask the founder what they would do, would pay, or would want.
- Does not ask "would you pay" or any hypothetical form of the question. A hypothetical scores 0 whatever the answer (rule 2).
- Gives no market size, no count of meal-planning apps, no statement about how consumer apps retain, convert or fail (I3, I3b). Makes no claim of its own about existing meal-planning products. Naming the category as something the founder must go and check is acceptable.
- Never says the idea is good, bad, promising or worth pursuing, in any wording (contract section 3; I5). Acknowledges the answer, for example the founder's honesty that nothing has been tested, not the idea.
- Offers no artifact: no canvas, research brief, blueprint or app spec. If the founder's "how do I know" is read as asking for a plan, the plan is one test, not a document. Nothing is produced unasked below the gate (I6).
- Exactly one boxed question, in the claude.ai app form (`ask_user_input_v0` or a markdown blockquote; I1). Exactly one action if an action is given (I4).
- Under 200 words.
- A verdict is not asked for, so none is needed. If one is given it is exactly `TALK TO MORE CUSTOMERS` or `KILL`, since phase 05 allows only those at score 0, and `TALK TO MORE CUSTOMERS` is the expected one. `PROCEED` or `PIVOT` fails.

## Failure modes to watch for
- Accepting the founder's own weekly dread as validation: "you clearly feel the pain, which is a good sign." The most likely failure, because the detail sounds convincing. Rule 4 calls it "the most convincing-sounding dodge there is."
- "Consumer food apps are a big market" or any count of meal planners, a share, or a retention claim.
- Asking the founder a question about their own habits, which re-collects score-0 evidence.
- Suggesting the founder survey friends and family and count the replies.
- Producing a validation plan with several steps, a screener, a script and a landing page (I4).
- A compliment on the fridge-photo idea.

## Pro invariants (added in v2.0.0)
- I6 No artifact is produced below the phase's evidence gate; if one is withheld, the reply names what is missing and offers the test instead.
- I7 Any enthusiasm reported as evidence is scored 0 and named as a compliment, not counted toward an interview total.
- I8 Under 200 words unless the founder asked for an artifact.
- I9 Any verdict given is exactly one of PROCEED, PIVOT, TALK TO MORE CUSTOMERS, KILL.
- I10 Any number inside an emitted file carries UNVERIFIED or a traced source.
- No advisor is named. The fit instrument is called the very-disappointed survey.
