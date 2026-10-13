# Startup Board v1 — Audit (STEP 1)

Date: 2026-10-12
Source audited: `E:\Projects\Startupboards_SKills\Startup_board_v1` (git origin = `shuvgenai/startup-board`, branch `main`, clean)
Audited for: the Startup Board Pro rebuild (24 advisors, 9 modules, evidence gates, state file, evals, packaged zip).

---

## 1. File tree and purpose

### Skill payload — `skills/startup-board/`

| File | Lines | Purpose |
|---|---|---|
| `SKILL.md` | 132 | Router. Frontmatter trigger description, one-question interaction rule, phases 0–10, style notes. |
| `references/board-members.md` | 56 | 8 advisors in 3 "seats". Internal reasoning only, never named to the founder. |
| `references/intake-questions.md` | 25 | Phase 0 question checklist in 3 groups. |
| `references/fit-framework.md` | 68 | Six fit stages, each with a numeric pass test; the "warn, then allow" rule. |
| `references/interview-questions.md` | 36 | Mom Test question bank and red-flag strip list. |
| `references/lean-canvas.md` | 18 | Ash Maurya canvas block definitions, assumption marking. |
| `references/market-research-modes.md` | 30 | Light / medium / heavy research workflow, McKinsey pyramid. |
| `references/build-blueprint.md` | 47 | Phase 6. Default no-code stack, MVP scope cut, data model, build prompt template. |
| `references/gtm-launch.md` | 37 | Phase 7. Channel choice by AARRR break point, positioning, pricing, launch week. |
| `references/naming-branding.md` | 23 | Phase 8a. Naming styles, domain check caution, tagline. |
| `references/pitch-fundraising.md` | 35 | Phase 8b. 12-slide deck outline, one-pager, investor objections. |
| `references/pmf-checkin.md` | 57 | Phase 9. Sean Ellis survey, retention, pull; verdict table; measurement kit. |
| `references/scale-growth.md` | 48 | Phase 10. One channel, CAC/LTV/payback with edge cases, pricing, playbook, first hire. |
| `references/output-documents.md` | 96 | Document matrix plus templates for `startup-board-progress.md`, `pmf-scorecard.md`, `growth-plan.md`. |

### Harness and distribution

| File | Purpose |
|---|---|
| `.claude-plugin/plugin.json` | Plugin manifest, v1.1.0, MIT, description duplicated from SKILL.md frontmatter. |
| `.claude-plugin/marketplace.json` | Marketplace listing. |
| `LICENSE` | MIT. |
| `README.md` (169 lines) | Public install and usage page. |
| `dist/startup-board.zip` | Packaged skill for the Claude app. |
| `startup-board-claude-skill/{README.md,startup-board.zip}` | Second copy of the app-install ZIP plus its own README. |
| `promo/*.html`, `promo/video/*.mp4` | Marketing assets. |
| `docs/superpowers/plans/`, `docs/superpowers/specs/` | The v1.1.0 fit-and-scale plan and design spec. |
| `.superpowers/sdd/2026-09-23-fit-and-scale/` | Build session logs for that plan. |

### Existing test harness — the master prompt assumed this did not exist

| File | Purpose |
|---|---|
| `tests/scenarios/README.md` | Role-play runbook: subagent dispatch, the advisor prompt, blind-grading rule, 5 invariants (I1–I5). |
| `tests/scenarios/s01…s12` | 12 fixture conversations: problem-fit gate, returning founder, other idea, claude.ai paste, 5 PMF cases, 2 scale cases, first-turn regression. |
| `tests/criteria/s01…s12` | Matching pass criteria, kept in a separate folder so the advisor under test cannot read the answer key. |

---

## 2. Trigger phrases in the current `description`

Verbatim phrases the frontmatter commits to:
`validate a startup or product idea`, `pressure-test an MVP concept`, `get expert feedback`, `generate Mom Test-style interview questions`, `build a Lean Canvas`, `run market/industry research`, `plan an MVP build with no-code tools`, `write a go-to-market plan`, `name/brand a product`, `build a pitch deck`, `check product-market fit`, `scale after launch (channels, CAC/LTV, pricing, first hire)`.

Plus the catch-all: "Trigger even without the word 'skill' or 'board' — any request to take a product idea from problem through build, launch and growth routes here."

### Likely to under-trigger

| Phrase | Why it misses |
|---|---|
| `pressure-test an MVP concept` | Founders say "roast my idea", "is this stupid", "will anyone pay for this", "poke holes in this". None of those words appear. |
| `get expert feedback` | Too generic to compete with any other advice-shaped skill. |
| `check product-market fit` | A founder with flat numbers says "why is nobody coming back", "my churn is bad", "signups but no usage" — no PMF vocabulary. |
| `scale after launch` | Misses "how do I get my first 100 customers", "which channel should I spend on", "is my pricing wrong". |
| no fundraising-side wording | Misses "am I fundable", "what will investors ask me", "is my valuation sane", "should I raise or bootstrap". |
| no decision-shaped wording | Misses "should I keep going or quit", "should I pivot", "I have been at this 8 months and nothing works". |
| no competitor wording | Misses "someone already built this, should I bother". |
| no founder-strategy wording | Misses "co-founder", "equity split", "is this a business or a feature". |

The catch-all paragraph carries most of the load today. That is fragile: it fires on idea-shaped inputs and stays quiet on problem-shaped ones.

---

## 3. The 10 phases — gate strength

Testable gate = a number or an artifact a third party could check. Vibe = model judgement with nothing to count.

| Phase | Evidence demanded before passing | Testable? |
|---|---|---|
| 0 Intake | Product, audience, problem, stage, beliefs vs guesses | **Vibe.** "Minimum you need" is a prose list, no count, no refusal rule if missing. |
| 1 Interrogation | None. Reason through 3 lenses, ask sharp questions | **Vibe.** No exit condition at all — nothing says when Phase 1 is done. |
| 2 Fit assessment | Counts founder evidence against the six pass tests | **Testable.** Strongest part of v1. Problem Fit: 10 interviews / 7 of 10 unprompted / half with workarounds. Product Fit: 5 unaided completions + 3 real commitments. Customer Fit: 4+ weeks retention + 1 unasked referral. Sales Fit: 3 months predictable CAC, LTV at least 3x CAC, payback 12 months or less, non-founder close. |
| 3 Research | Depth confirmed by one question | **Vibe.** No gate. Light mode can run on zero evidence. |
| 4 Documents | "Phase 0–2 are done" | **Vibe.** No score threshold. A canvas can be produced from an all-assumption intake; the only guard is marking blocks `[assumption — untested]`. |
| 5 Verdict | Four verdicts exist (proceed / pivot / talk to 10 more / kill) plus riskiest assumption | **Partly testable.** Verdict set is fixed, which is good. Nothing ties a verdict to an evidence count, so "proceed" is discretionary. |
| 6 Build | "Only after a proceed verdict, or if the founder explicitly asks" | **Vibe, and self-cancelling.** The escape clause means any founder who asks gets a blueprint. Only the gap stamp survives. |
| 7 GTM | "On request, or once there is a real MVP" | **Vibe.** "Real MVP" undefined. |
| 8 Naming / pitch | "On request only" | **No gate by design.** Deck slide 7 says never inflate traction, which is a content rule, not a gate. |
| 9 PMF | Hard refusal at zero active users. Survey 40% or more very disappointed from about 30+ responses; retention must level off above zero; pull present or growing; never *Yes* while a signal is unmeasured | **Testable, strongest gate in v1.** Also handles contradictory numbers and small samples (labels them *directional*). |
| 10 Scale | Warn if Phase 9 not *Yes* / *In one segment*; then the Sales Fit test | **Testable on output, soft on entry.** Entry is a warning, not a gate; CAC/LTV rules and the zero-churn edge case are precise. |

Pattern: v1 gates hard where it has numbers to count (2, 9, 10) and not at all where it produces documents (3, 4, 6, 7, 8). That is backwards for a paid product — document production is exactly what founders over-request.

---

## 4. Gap list — where v1 gives an opinion instead of demanding evidence

**G1 — No evidence scoring.** Evidence is counted (how many interviews) but never graded by kind. A founder who says "I spoke to 10 people and they all loved it" satisfies the Problem Fit count with pure compliments, which Fitzpatrick's own rule in `board-members.md` calls not-data. Needs the 0–3 rubric: opinion / secondhand / primary past behaviour / behavioural (paid, signed up, booked, switched).

**G2 — Phase 1 has no exit condition.** It is the phase SKILL.md calls "where most of the session's value lives" and it is the only phase with no pass test. The model decides when the interrogation is over.

**G3 — Phase 6 escape clause voids the build gate.** "Only after a proceed verdict, **or if the founder explicitly asks**" means the gate never binds, because every founder asks. The gap stamp documents the violation instead of preventing it.

**G4 — Phase 4 documents need no score.** A Lean Canvas, interview set or research brief can be produced on a turn-one idea. `[assumption — untested]` markers are honest labelling, not a gate.

**G5 — The flattery ban is a style note, not a rule.** SKILL.md says "Warmth matters" and asks for brief acknowledgements; `board-members.md` warns that "I'd definitely use that" is a compliment, not data. Nothing forbids the advisor itself from complimenting the idea. Invariant I5 actively requires a warm acknowledgement, which pushes the other way.

**G6 — Phase 5 verdict is not evidence-bound.** The four verdicts are well defined; no rule says which evidence score permits which verdict. "Proceed" on a score-0 idea is reachable.

**G7 — Research can produce market numbers with no gate.** `market-research-modes.md` forbids fabricating figures and requires citation, which is good. But heavy mode produces TAM/SAM/SOM for an unvalidated idea, and only sized figures carry the "estimate, unverified" rule — no blanket UNVERIFIED marker exists across templates.

**G8 — Unverified marking is inconsistent across templates.** Three conventions in use: `[assumption — untested]` (lean canvas), a `Real or estimated` column (PMF scorecard, growth plan), and `estimate, unverified` (research). The pitch deck says "mark any unverified figure clearly" without saying how. No single marker a reader or a grader can grep.

**G9 — The progress file carries no assumption or decision history.** `startup-board-progress.md` holds idea, stage, verdict, riskiest assumption, an append-only evidence log, one next action. Missing: an assumption ledger (designed / run / result), a decisions table with revisit dates, open loops, and any calibration record of overturned verdicts. The session cannot learn from being wrong.

**G10 — No open-loop rule for a returning session.** v1 reads the file and gives a recap. A recap is passive. Nothing forces the session to open on one unresolved assumption or one unrun test.

**G11 — No length ceiling.** Nothing caps an advisor turn. A 900-word monologue passes every invariant.

**G12 — Advisor coverage thins out exactly where paying founders live.** 8 advisors across problem, model and metrics. No module for product management (Cagan, Perri, Biddle), no growth-channel theory (Weinberg, Balfour, Chen), no founder strategy (Graham, Naval, Hoffman), no fundraising mechanics (Feld). Phases 7–10 run on thinner material than phases 0–5. The post-launch founder with flat retention gets a channel checklist, not a diagnosis of whether it is a product or a channel problem.

**G13 — Numbers appear in rules of thumb with no enforced label.** SKILL.md forbids invented figures in examples, and invariant I3 enforces it at test time. But `fit-framework.md` and `pmf-checkin.md` carry rules of thumb (10 interviews, 40%, 3x, 12 months) that a model can restate as fact. The "rule of thumb" label depends on the model remembering to say it.

**G14 — `n8n` is absent (good) but Zapier/Make are present.** `build-blueprint.md` recommends Supabase Edge Functions first and Zapier/Make only on request. Pro's ground rule bans n8n specifically; the Zapier/Make fallback needs a decision, not an assumption.

---

## 5. Carry-forward and conflicts with the Pro target structure

### Reuse, do not rewrite

- `tests/` — 12 scenarios, the blind-grading harness, and invariants I1–I5. Pro STEP 8 asks for 8 new fixtures; 6 of its 8 shapes are already covered (s01 weak evidence, s05/s06 segment and small sample, s07 missing retention, s08 no users, s10 scale before PMF, s11 zero churn). Port and extend to cover the 3 missing shapes: the founder who answers in hypotheticals, the founder who asks for a pitch deck on turn one, and the strong problem with no business model.
- The six fit pass tests, the PMF verdict logic, the CAC/LTV edge cases, and the "warn, then allow" gap stamp. These are v1's real assets.

### Conflicts to resolve before STEP 2

1. **Repo location.** This working directory *is* the public repo (`origin` = `shuvgenai/startup-board`). Pro ground rule 1 forbids writing or committing here. Nothing can be built until a separate location is chosen.
2. **State file rename.** `startup-board-progress.md` becomes `startup-board-state.md`, which breaks returning v1 founders. Pro needs a read-both-then-migrate rule.
3. **Dropped references.** The Pro structure has no slot for `market-research-modes.md`, `naming-branding.md`, `gtm-launch.md` or `output-documents.md`. Dropping them loses real capability; they should map into modules 03/07/09 plus an artifacts index.
4. **`dist/` gitignored vs. `dist/INSTALL.md`, `dist/CHANGELOG.md`, `dist/launch/`.** The build cannot both ignore the folder and version its contents. Ignore `dist/*.zip` only.
5. **Flattery ban vs. invariant I5.** I5 requires a warm acknowledgement; the conversation contract forbids complimenting the idea. These coexist only if stated precisely: acknowledge the *answer*, never praise the *idea*.
