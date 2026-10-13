# Startup Board Pro — Design Spec

Date: 2026-10-12
Derives from Startup Board v1.1.0 (`_reference/`) and the audit at `pro/AUDIT.md`.
Build location: `E:\Projects\Startupboards_SKills\Startupboardskills_pro` — local git only, no remote.

---

## 1. What this is

A paid, single-advisor founder operating system delivered as a Claude skill. It is Markdown only: no runtime, no database, no account, no API key. A non-technical buyer installs it by dropping a folder into `~/.claude/skills/` or uploading a ZIP in the Claude app.

v1 is a 10-phase advisory pipeline run by one voice synthesising 8 authorities. Pro keeps that interaction shape and adds four things v1 does not have:

1. **Evidence scoring.** Every founder claim scores 0–3. Phase gates read the score, not the model's confidence.
2. **24 advisors across 9 modules**, covering the post-launch stages where v1 goes quiet.
3. **Durable session state** with an assumption ledger, a decisions table, open loops, and a calibration record of overturned verdicts.
4. **A test harness that can fail** — static assertions plus 15 blind-graded role-play cases.

## 2. Non-goals

- No licence keys, obfuscation, or phone-home code. A Markdown skill cannot enforce any of them, and claiming otherwise would be dishonest to a buyer who can read the file.
- No growth-team or multi-channel advice. Scale guidance stops at the first hire, as in v1.
- No advisor is ever named, quoted or credited to the founder.

## 3. The 14 gaps this closes

From `pro/AUDIT.md`. Each gap names the file that closes it.

| Gap | Closed by |
|---|---|
| G1 no evidence scoring | `references/evidence-rubric.md`, read by every phase gate |
| G2 Phase 1 has no exit condition | `phases/01-interrogation.md` numeric gate |
| G3 Phase 6 escape clause voids the gate | `phases/06-mvp-blueprint.md` — gate binds, warn-then-stamp replaces the escape clause |
| G4 documents need no score | `phases/04-artifacts.md` minimum score 2 |
| G5 flattery ban is a style note | `references/conversation-contract.md` hard rule + eval criterion |
| G6 verdict not evidence-bound | `phases/05-verdict.md` verdict-to-score table |
| G7 research sizes an unvalidated market | `phases/03-research.md` gate + `UNVERIFIED` default |
| G8 three inconsistent unverified markers | one marker, `UNVERIFIED`, in every numeric template |
| G9 progress file has no ledger | `references/state-file.md` |
| G10 returning session recaps passively | OPEN LOOP rule in `references/state-file.md` |
| G11 no length ceiling | 200-word ceiling in `references/conversation-contract.md` |
| G12 advisor coverage thin post-launch | `references/advisors/04-09` |
| G13 rules of thumb restatable as fact | every rule of thumb carries `(rule of thumb)` inline in source |
| G14 Zapier/Make undecided | removed; see §7 |

## 4. Global constraints

Exact values. Every task inherits these.

- `SKILL.md` is **under 500 lines**.
- No advisor's name appears in `SKILL.md`, `phases/`, `artifacts/`, or any file a founder sees. Names live **only** in `references/advisors/*.md`, under a `## Source lenses (internal)` heading, with a never-narrate rule.
- **No invented numbers.** A number appears only if the founder gave it, a source URL backs it, or it is labelled `(rule of thumb)` at the point of use. Every template field holding a number defaults to `UNVERIFIED`.
- **One marker**: the literal string `UNVERIFIED`. `[assumption — untested]`, `estimate, unverified` and bare `Real or estimated` columns are retired.
- **Banned from all stack guidance**: `n8n`, `Supabase`, `Zapier`, `Make`.
- **One question per turn.** Never a numbered or bulleted list of questions. A founder who volunteers several answers at once is accepted and not re-asked.
- **Answer ceiling 200 words** unless the founder asked for an artifact.
- **Four verdicts, exact strings**: `PROCEED`, `PIVOT`, `TALK TO MORE CUSTOMERS`, `KILL`. Each ships with the single riskiest untested assumption and one action for this week.
- **State edits are append-and-amend.** A past entry is struck and dated, never silently rewritten.
- Every phase file states a **numeric pass gate**.
- Every build step ships a **copy-paste prompt**, never "hire someone".
- Git: one commit per task, task number in the message. **Never** `git remote add` for any URL containing `startup-board`. `_reference/` is read-only and gitignored.

## 5. Evidence rubric

Scores a single claim 0–3.

| Score | Name | What it is |
|---|---|---|
| 0 | Opinion | Founder's own belief, no outside input |
| 1 | Secondhand | An article, a forum thread, someone agreed in conversation |
| 2 | Primary | A Mom Test interview where a **past behaviour** was described, not a hypothetical |
| 3 | Behavioural | Someone paid, signed up, booked time, or switched tools |

A compliment scores 0 regardless of how many people gave it. "Ten people said they would use it" is a score-0 claim repeated ten times, not a score-2 body of evidence. This single rule closes G1.

## 6. The fit ladder

Six stages carried from v1 with their numeric pass tests intact, each now also carrying a minimum evidence score.

| Stage | Means | Pass condition |
|---|---|---|
| Problem | The problem exists and people already work around it | 10 interviews at score 2+; 7 of 10 describe it unprompted; 5 of 10 show a workaround |
| Research | How it is solved today is known, and the riskiest assumption is written as a test | Top 3 alternatives named; 1 if-then hypothesis with a pass number |
| Product | This product solves it for a small core group | 5 users complete the core loop unaided; 3 real commitments at score 3 |
| Customer | The highest-value profile is known and sticks | That profile active 4+ weeks; 1 unasked referral |
| Market | Demand pulls | Phase 09 verdict `Yes` (segment-only on `In one segment`) |
| Sales | Acquisition repeats profitably | One channel predictable 3 months; LTV at least 3x CAC; payback 12 months or less; a non-founder closed one |

## 7. MVP stack (replaces v1's Supabase default)

Tiered by how little technical work the founder must do. Decided 2026-10-12; `n8n`, `Supabase`, `Zapier` and `Make` are out.

| Tier | When | Stack |
|---|---|---|
| 0 — cheapest test | Proving the core loop before committing to a platform | A single Claude Artifact the founder shares as a link |
| 1 — default | Anything with a real interactive loop | Lovable / Bolt / Replit — the founder describes the app in words; the tool handles data, login and hosting invisibly. Payments via a Stripe hosted checkout link. Claude API for any generation feature. |
| 2 — data-heavy or ops-shaped | Records an operator edits directly | Airtable as the data layer, Softr or Glide as the interface, Stripe hosted checkout |

**Graduation path:** named in **one line only**, and only when the founder's stated requirement genuinely exceeds tier 1 or 2 (real multi-user permissions, regulated data, heavy volume). No setup instructions. The skill does not drag a non-coder toward tooling they do not need.

## 8. File structure

```
pro/
  SKILL.md                      router: triggers, phase map, contract pointer
  LICENSE  CHANGELOG.md  AUDIT.md  README-PRO.md
  references/
    conversation-contract.md    how it talks
    evidence-rubric.md          section 5
    fit-ladder.md               section 6
    state-file.md               state shape + three loops + v1 migration
    artifacts-index.md          which artifact, when, what format
    advisors/01..09             nine modules, fixed shape
    artifacts/                  14 templates
  phases/00-intake.md .. 10-scale.md
  evals/
    check.sh                    static assertions, grouped
    rubric.md                   how a run is graded
    RUNBOOK.md                  exact commands
    cases/                      15 fixtures
    criteria/                   15 answer keys, separate folder (blind grading)
  dist/                         INSTALL.md, CHANGELOG.md, launch/, EDITION-SPLIT.md
```

`dist/*.zip` is gitignored; everything else under `dist/` is versioned.

## 9. Advisor modules

Nine files, one fixed shape, 24 source lenses. Names are internal only.

| Module | Source lenses |
|---|---|
| 01 Problem discovery | Fitzpatrick, Alvarez, Constable, Christensen |
| 02 Customer development | Blank, Ries |
| 03 Business model | Osterwalder, Maurya |
| 04 Product-market fit | Olsen, Ellis, Andreessen |
| 05 Product management | Cagan, Perri, Biddle |
| 06 Metrics | Croll, Yoskovitz, McClure |
| 07 Traction and growth | Weinberg, Balfour, Chen |
| 08 Founder strategy | Graham, Ravikant, Hoffman |
| 09 Fundraising | Feld, Hoffman |

Fixed shape, in this order, no other top-level headings:

```
# <Module name>
## When this module loads
## The lens
## Questions to ask, in order
## Red flags in the answer
## The evidence this module accepts
## Output
## Source lenses (internal)
```

## 10. Conversation contract

Hard rules, not style notes.

- One question per turn, boxed (`AskUserQuestion` / `ask_user_input_v0` where options enumerate; otherwise a blockquote).
- React to the answer before the next question: name what it tells you, or what it dodged.
- **Never compliment an idea.** No "great question", "strong insight", "love this". Acknowledge the *answer*, never praise the *idea* — this is how the warmth v1 wanted coexists with the flattery ban.
- When an opinion is presented as fact, say so and ask what it rests on.
- On a verdict request, give one of the four exact strings, plus the riskiest untested assumption and one action this week.
- **Never produce an artifact the founder has not earned.** Below the phase's required score, say what is missing and offer the test instead of the deliverable.
- 200-word ceiling unless an artifact was asked for.

## 11. State file and the three loops

`startup-board-state.md`, re-read and written every session. Sections: `## Venture`, `## Fit ladder`, `## Assumption ledger`, `## Evidence log`, `## Numbers`, `## Decisions`, `## Open loops`, `## Calibration`.

- **OPEN LOOP** — a session opens by asking about exactly one unresolved assumption or one unrun test. Not a recap.
- **CLOSE LOOP** — a reported result is scored, written to the ledger, and answered with one sentence on whether the ladder moved.
- **CALIBRATION LOOP** — an overturned verdict appends a dated line: what was believed, what happened, which question would have caught it sooner.

**v1 migration.** On finding `startup-board-progress.md` and no `startup-board-state.md`, read it, carry its rows into the new shape, write `startup-board-state.md`, leave the v1 file untouched on disk, and tell the founder in one line. Never ignore it, never overwrite it.

## 12. Tests

Two layers. Both must pass.

**Static** — `evals/check.sh <group>`, groups: `contract`, `state`, `advisors`, `phases`, `artifacts`, `skill`, `cases`, `all`. Plain `grep`/`wc`, exit 1 on failure. Asserts the constraints in section 4 mechanically: line count, banned strings, `UNVERIFIED` presence, numeric gate per phase file, advisor names absent from founder-facing files, the four exact verdict strings.

**Behavioural** — 15 blind-graded role-play cases. The 12 v1 scenarios port across; 3 are new (founder who answers in hypotheticals, founder who asks for a pitch deck on turn one, strong problem with no business model). Criteria stay in `evals/criteria/`, which the advisor under test is forbidden to read.

Invariants extend v1's I1–I5:

- I1 one boxed question, never a list
- I2 one voice, no advisor named, no board/seat/panel language to the founder
- I3 no invented numbers; rules of thumb labelled
- I4 one next action, not a to-do list
- I5 acknowledges the answer; **never praises the idea**
- I6 no artifact below the phase's required evidence score
- I7 compliments score 0 and are named as compliments, not evidence
- I8 answer under 200 words unless an artifact was requested
- I9 a verdict is one of the four exact strings
- I10 any number in an emitted file carries `UNVERIFIED` or a source

## 13. Packaging and editions

`dist/startup-board-pro.zip` carries `SKILL.md`, `references/`, `phases/`. It excludes `evals/`, `AUDIT.md`, `_reference/`, `.git`. Verified by extracting to a temp folder and confirming the frontmatter parses and every relative link resolves.

`dist/EDITION-SPLIT.md` compares free and pro line by line, then states plainly where the split leaks — what a motivated buyer rebuilds from the free version in an afternoon, and what they cannot — and names the one thing genuinely hard to copy that should carry the price.

The free v1 stays public and alive as the funnel. MIT is irrevocable for already-published code; the moat is the new material and the updates, not secrecy.
