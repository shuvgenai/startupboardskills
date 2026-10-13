# Eval runbook

Three layers. All three must pass before a release. Layer 0 comes first: it
builds the zip, and the build runs the zip assertions itself, so a broken
archive stops there.

## Layer 0 — build the installable zip

```
sh build-zip.sh
```

Run it from the repo root. The builder sits there, outside `pro/`, because
anything inside `pro/` ships to the buyer and the builder is maintainer
tooling.

Writes `pro/dist/startup-board-pro.zip` (gitignored) and then runs
`evals/check.sh zip` against it. Exit 0 means the archive is spec-compliant
and its payload matches the source tree.

Never build it with PowerShell `Compress-Archive`. It writes `\` as the entry
separator, against ZIP spec 4.4.17.1. Info-ZIP `unzip` repairs that on read,
so the archive looks fine on Windows while macOS Archive Utility extracts one
flat file named `references\fit-ladder.md` and every link in `SKILL.md` dies.
`build-zip.sh` uses bsdtar/libarchive, falls back to Info-ZIP `zip`, and
refuses to build if neither is present.

To check an archive you did not just build, including one a buyer sends back:

```
sh pro/evals/check.sh zip /path/to/startup-board-pro.zip
```

## Layer 1 — static checks

```
Everything:  sh pro/evals/check.sh all
One group:   sh pro/evals/check.sh phases
Groups:      contract state advisors phases artifacts skill plugin sweeps cases zip all
```

Exit 0 means every assertion in the group holds. Exit 1 prints each failure as
`FAIL: <reason>`. Run this before every commit.

## Layer 2 — behavioural cases

Skills are tested by role-play, not unit tests. Each file in `evals/cases/`
holds a Setup block and a conversation so far. A fresh subagent plays the
advisor using the skill files exactly as they are on disk, and writes the
advisor's next message. You then grade that reply.

### Run one case

Dispatch a subagent with the Agent tool: `subagent_type: general-purpose`,
`model: sonnet`. A mid-tier model is a stricter test of the written
instructions than a frontier model, which can paper over a vague rule.

Use the Advisor prompt below, replacing `<SCENARIO FILE>` with the case's
absolute path. Independent cases run in parallel — several Agent calls in one
message.

### Grade it

Grade the reply against the matching file in `evals/criteria/` and every
invariant in `rubric.md`. Every item must hold for PASS.

### Record it

Append a row to `evals/results-YYYY-MM-DD.md`:

```
| case | PASS/FAIL | failed invariants | quote |
```

## The Advisor prompt

```
You are helping test a Claude skill called Startup Board Pro. The skill lives at:
E:\Projects\Startupboards_SKills\Startupboardskills_pro\pro\
Read SKILL.md, then read whichever files in references/ and phases/ SKILL.md
tells you to use for this situation.

Then read the scenario at <SCENARIO FILE>. You may read ONLY files inside
pro/SKILL.md, pro/references/, pro/phases/ and that one scenario file. Do not
open, list or search anything else: not pro/evals/criteria/, not pro/evals/,
not docs/, not _reference/, not AUDIT.md, and no other scenario.

Play the advisor exactly as the skill instructs and write ONLY the advisor's
next message, replying to the last founder turn.

Simulation rules:
- Environment: use the one named in the scenario Setup (Claude Code or the
  claude.ai app).
- Files in the founder's folder are listed in Setup with their contents. Treat
  them as readable only if that environment could read them. Do not read or
  write any real files other than the skill files and the scenario file.
- If the skill would save or update a file, do not write it. Put its full
  contents in your reply as a fenced block preceded by a line
  FILE: <filename>
- If the skill would use a multiple-choice question tool, render it as:
  [QUESTION TOOL] <question>
  - <option>
  - <option>
- Today's date is the one in Setup.
- Do not explain your reasoning or mention that this is a test. Output only the
  advisor's message.
```

## Why criteria live in a separate folder

The advisor must never see the pass criteria, the spec or the plan. A reply
shaped by the answer key proves nothing. That is why `evals/criteria/` is a
sibling of `evals/cases/` and the prompt above forbids reading it.
