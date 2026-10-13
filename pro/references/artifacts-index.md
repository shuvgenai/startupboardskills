# Artifacts index

Which artifact, when it is earned, and how it is delivered.

An artifact below its minimum score is not produced. Say what is missing, name
the test, offer the test — see rule 6 in
`references/conversation-contract.md`.

| Artifact | Earned at | Min score | Format |
|---|---|---|---|
| `references/artifacts/mom-test-script.md` | Phase 04 | 0 | inline |
| `references/artifacts/experiment-card.md` | Phase 01 | 0 | inline |
| `references/artifacts/market-research-brief.md` | Phase 03 | 1 light, 2 medium, 2 + Problem passed for heavy | inline for light, saved file for medium and heavy |
| `references/artifacts/lean-canvas.md` | Phase 04 | 2 | saved file |
| `references/artifacts/positioning-statement.md` | Phase 04 or 07 | 2 | inline |
| `references/artifacts/build-prompt-library.md` | Phase 06 | Problem passed, else gap stamp | saved file |
| `references/artifacts/launch-plan.md` | Phase 07 | 1 person completed the core loop unaided | saved file |
| `references/artifacts/naming-shortlist.md` | Phase 08 | on request | inline |
| `references/artifacts/pitch-deck-outline.md` | Phase 08 | 2, and 3 for traction claims | saved file |
| `references/artifacts/one-pager.md` | Phase 08 | 2, and 3 for traction claims | saved file |
| `references/artifacts/raise-plan.md` | Phase 08 | 2, and 3 for traction claims | saved file |
| `references/artifacts/pmf-survey.md` | Phase 09 | live active users | inline |
| `references/artifacts/pmf-scorecard.md` | Phase 09 | signals measured | saved file |
| `references/artifacts/cac-ltv-model.md` | Phase 10 | 3 | saved file |
| `references/artifacts/growth-plan.md` | Phase 10 | Phase 09 Yes or In one segment | saved file |

## The filenames you write

A template under `references/artifacts/` is the instruction. What you save into
the founder's folder has its own fixed name, and these are the only names to
use — a scorecard saved under a different filename each session cannot be
compared with the last one.

| What you save | Filename |
|---|---|
| Session state | `startup-board-state.md` |
| Fit scorecard | `pmf-scorecard.md` |
| Growth plan | `growth-plan.md` |
| Lean Canvas | `lean-canvas.md` |
| Research brief | `market-research-brief.md` |
| Launch plan | `launch-plan.md` |
| Pitch deck outline | `pitch-deck-outline.md` |
| One-pager | `one-pager.md` |
| Unit economics | `cac-ltv-model.md` |
| Raise plan | `raise-plan.md` |

A second venture in the same folder suffixes the state file with its short
name, per `references/state-file.md`. Everything else is overwritten in place,
because the state file is the thing that keeps history.

## Inline or saved

A one-time read stays inline: a verdict, an interview script, a light research
pass. Anything the founder will return to and revise becomes a file.

In Claude Code, write the `.md` into the founder's current folder and tell them
the path in one line. In the claude.ai app, produce a file artifact and say it
is theirs to keep.

## Rules that apply to every artifact

- **One marker for anything unverified: `UNVERIFIED`.** Not blank, not
  softened, not a plausible stand-in.
- **Every rule of thumb carries `(rule of thumb)`** at the point of use.
- **No advisor is ever named** in anything the founder sees.
- **A gap stamp goes at the very top** when the artifact was produced before
  its stage was passed:

  `> Built before <Stage> was passed. Missing: <evidence>.`

- Every number carried between artifacts keeps its source and as-of date, per
  `## Numbers` in `references/state-file.md`.
