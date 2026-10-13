# Startup Board Pro — decisions taken during the build

Dated 2026-10-12. Carried out of the scratch ledger so the record survives in
git. Each line is a decision made on the owner's behalf, with what it costs if
it turns out wrong.

## Scope and setup

**Build location.** Built in `Startupboardskills_pro`, never in the public
`shuvgenai/startup-board` working tree. No remote in this repo has ever pointed
at the public repo; the guardrail was checked at the start of the build and
again at the end.

**Two repos, not one.** `startupboardskills` (private) holds the build: spec,
plan, audit and this file. `startup-board-pro` (private) holds only what a
buyer sees. Pushing one repo would have given every buyer `pro/AUDIT.md`, the
design spec and the build ledger. *Cost if wrong:* two trees to keep in sync,
which is why the manifests and install guide are copied rather than authored
twice.

**LF line endings pinned** via `.gitattributes`. Without it git converts on
checkout and `check.sh` dies on carriage returns on a fresh Windows clone.

## Product decisions

**Artifact gate: warn-then-stamp, not hard refusal.** Four files said no
artifact is produced below its gate; the phase files said one is produced
stamped when the founder insists. Resolved in favour of warn-then-stamp across
eight files, because never refusing is better founder service and it is the
free version's proven behaviour. *Cost if wrong:* the paid edition's gate is an
ordering rule plus a stamp rather than a refusal, and the marketing must keep
saying exactly that. `evals/cases/s19` now grades the stamped path.

**Three refusals, not one.** `fit-ladder.md`, `SKILL.md` and
`phases/09-pmf-checkin.md` each claimed the zero-active-users refusal was the
only one in the product. There are three: zero active users, market sizing
below the research gate, and an unverifiable claim on a slide. *Cost if wrong:*
none, the single-exception claim was simply false.

**The eval suite ships in the ZIP.** Three sales assets promise the buyer can
read what the skill got wrong; excluding `evals/` made those claims false. The
licence grants the right to read it and withholds the right to republish it.
Spec section 13 was amended to match. *Cost if wrong:* the buyer holds the full
test suite, which the leak analysis already concedes copies in an afternoon.

**MVP stack.** `n8n`, `Supabase`, `Zapier` and `Make.com` are banned and
checker-enforced, on the owner's instruction. Tiers: a Claude Artifact for the
cheapest test, then Lovable/Bolt/Replit, with Airtable plus Softr or Glide for
data-heavy products. Bare `Make` is not bannable without false positives on
ordinary English, so the checker matches `Make.com` only.

**Valuation.** Added after the owner noticed "is this valuation sane" was a
frontmatter trigger with no capability behind it — an over-promise by the
product's own rule. The skill never produces a valuation figure; it runs
dilution arithmetic on the founder's own number and puts terms in plain words.

## Eval criteria corrected, and why

A criterion was never relaxed because a run failed it. These four contradicted
a global constraint, and the constraint won.

1. **s02** required a recap opening. The state file deliberately replaced the
   recap with OPEN LOOP, so the criterion was the free version's behaviour.
2. **s03** required asking "continue the saved venture, or start fresh". The
   founder's own message says "a new idea", so asking would re-ask something
   already answered.
3. **s16** required the dilution arithmetic in the same turn as the question
   about what the money is for. Phase 08 says to ask that first, so the key
   demanded two turns' work in one reply.
4. **s15** was corrected and then **reverted**. I had made offering an earned
   artifact optional, reasoning that an offer competes with the turn's one
   question. The review showed that wrong — the contract requires offers
   alongside the question in two other places — and my amendment had removed
   the suite's only delivery-side test. Key restored; the contract now states
   the duty and requires the offer to name the artifact. s15 passes on run 3.

Two patterns caused all four and are now written into `evals/rubric.md`: a key
that demands more than one turn's work fights the one-question rule, and a key
inherited from the free version carries rules the product changed.

## Process notes

**The task-1 ledger line was hand-written** because the repo had no commits, so
the workspace scripts could not resolve a BASE.

**The plugin manifests were written before the ZIP** rather than after, so the
ZIP was built once with `.claude-plugin` inside instead of built and rebuilt.

## Deferred, with reasons

- `phases/02-fit-assessment.md` satisfies the numeric-gate assertion via the
  digits in "scored 0 to 3" rather than an evidence count. The file is honest
  that its gate is about rigour rather than the founder's evidence.
- The runbook forbids the graded model from reading the answer keys but cannot
  prevent it. `README-PRO.md`'s "could read the skill and nothing else" is an
  honour system, and the results file says so.
- `references/artifacts-index.md` lists `positioning-statement` as Phase 04 or
  07 while phase 04's `Artifact:` line names only two files; it appears in that
  phase's body instead.

## 2026-10-13 — the zip build moved off PowerShell

**What was wrong.** `pro/dist/startup-board-pro.zip` stored 107 of its 112
entries with `\` as the path separator, and none with `/`. Windows PowerShell
5.1 `Compress-Archive` wrote them that way, against ZIP spec section
4.4.17.1. Info-ZIP `unzip` silently repairs the separators on read, and macOS
Archive Utility does not: there the archive extracts as flat files literally
named `references\fit-ladder.md`, so `SKILL.md` loads while all 107 of its
reference and phase files land as flat backslash-named files, and every link in
the skill resolves to nothing. Install routes 1 and 2
were broken for every buyer not on Windows.

**Why the build did not catch it.** Task 13's verify step extracted the
archive with PowerShell `Expand-Archive` — the other half of the pair that
wrote the bug. It round-tripped its own convention and reported clean. The
lesson is narrow and worth keeping: never verify an artifact with the tool
that produced it.

**What changed.** `build-zip.sh`, at the repo root, now owns the build. It sits
outside `pro/` on purpose: everything inside `pro/` ships to the buyer, and a
builder in the folder it packages would have joined its own payload. It uses
bsdtar/libarchive, which writes `/` and ships with Windows 10+, macOS 10.15+
and most Linux; falls back to Info-ZIP `zip`; and refuses to build if neither
is present rather than reaching for PowerShell. It removes the output first,
because `zip -r` appends and a rebuild would otherwise retain a file deleted
from the source. Its last step runs the new `zip` group in `evals/check.sh`,
which reads the archive's stored entry names and fails on any backslash, on
payload drift from the source tree, on a leaked `AUDIT.md`, `dist/`,
`_reference/` or `.git/`, and on an archive it cannot read at all. An absent
zip is a skip, so a buyer's install and a fresh clone stay green.

**Version unchanged, deliberately.** The skill files are byte-identical
before and after; only the archive container changed. Nothing had reached a
buyer — the distribution repo is private with no releases, and `**/dist/*.zip`
is gitignored so no archive was ever committed. So 2.0.0 stands, with no
CHANGELOG entry and no manifest bump. Cost if wrong: if an archive did leave
the machine, a buyer cannot tell the broken copy from the fixed one by
version, and the fix has to ship as 2.0.1 with a note.

**Still open, not part of this change.** There is no download source for
routes 1 and 2. The archive is gitignored, the distribution repo has no
releases, and route 1 of `INSTALL.md` tells the buyer to upload the zip
"exactly as you downloaded it". Route 3, the plugin, is unaffected and works.

**Why the guard reads `orig_filename`.** CPython's `zipfile` normalizes `\`
to `/` when it reads the central directory, so `namelist()` reports a clean
archive even when the stored names carry backslashes. The Python fallback in
`check_zip` therefore reads `orig_filename`, the raw stored name. Do not
simplify it back to `namelist()`: the guard would pass on a defective archive
on any host without `unzip`. The same normalization happens on write, so a
test archive with backslashes cannot be built with `zipfile`; byte-patch a
copy of a real archive instead.

**Contents, not just names.** The payload check extracts the archive to a
scratch directory outside the repo and runs `diff -r` against the source tree,
excluding `dist/` and `AUDIT.md`. A name-only comparison passed on an archive
that was stale by one edited file.

**Known-untested path.** The Info-ZIP `zip` fallback in `build-zip.sh` has
never been run. The refusal test reaches the no-writer branch only because
this host has no `zip` binary.

**Why the guard ships and the builder does not.** `check.sh zip <path>` is
usable by anyone holding an archive, so it lives in the payload. `build-zip.sh`
is useful only to the maintainer, so it stays at the repo root.

## 2026-10-13 — two deliberate deviations from the master-prompt spec, recorded

**Spec Step 4's "below 2" rule is not shipped, on purpose.** The original prompt asked
the conversation contract to say: "If evidence scores below 2 on the rubric, say what is
missing and offer the test instead of the deliverable." The shipped contract does not
carry it. Section 6 instead says "Each phase names a minimum evidence score. Below it,
three steps, in order" and defers the number to the phase. That is deliberate, because a
flat floor of 2 would have contradicted the phases that legitimately gate lower —
phase 03 earns a light scan at 1, phase 04 earns the interview script and experiment
card at 0 — and a founder at 0 who can never receive an instrument for producing
evidence is a founder the product cannot help. An audit on 2026-10-13 flagged the
missing line as a contradiction between the contract and phase 03; it is not one, and it
is recorded here so the next audit does not re-flag it. Cost if wrong: a reader comparing
the shipped contract to the original prompt finds a rule missing and has to come here to
learn why.

**The gate rule now lives in the contract, not in eleven phases.** A sweep of all eleven
phases on 2026-10-13 found seven with undefined, silent or contradictory behaviour below
their lowest gate, four of them genuine holes. The spec defined every gate as a number
and never defined what a phase does BELOW its lowest gate, so each phase either wrote
that path itself or left it to the model. Phase 03 left it, and the model improvised
downward — offering its cheapest research tier to a founder who had interviewed nobody.
The fix is one default rule in `references/conversation-contract.md` section 6, inherited
by every phase unless the phase overrides it in writing, with silence explicitly not an
override. The four holes are closed in the phase files as well. Cost if wrong: a
contract-level rule sits far from the phase that applies it, so a phase author can forget
it exists — which is how phase 03 got there. `check_invariants()` in `evals/check.sh`
exists to pay that cost down.

## 2026-10-13 — the payload split, and why evals/ still ships

**Shipping `evals/` is a deliberate deviation from spec Step 9.** The spec said the
archive contains "SKILL.md plus references, phases and artifacts — no evals, no
AUDIT.md, no _reference". The cases, the answer keys and `rubric.md` ship anyway,
because three sales claims rest on a buyer being able to audit the suite, and
`EDITION-SPLIT.md` names it as the one asset carrying the price. Spec section 13 was
amended to match on 2026-10-12. Cost if wrong: a buyer holds the test suite, which the
leak analysis already concedes is copyable in an afternoon.

**Three things inside `evals/` do not ship:** `RUNBOOK.md` (maintainer instructions),
`transcripts/` and `results-*.md`. They are maintainer artifacts, and they are what made
the archive go stale on every eval run — the payload changed whenever the suite was
exercised, which is a build that invalidates itself by being tested. Payload is now 105
files, down from 114 before the split and up from 91 by the seven cases added the same
day. `evals/cases/`, `evals/criteria/` and `evals/rubric.md` stay: they are what "the
eval suite is the product" actually refers to.

**Publishing `results-*.md` publicly was considered and rejected.** The plan was to put
it in the public free repo so "you can read what it got wrong before you buy it" would
be true for the first time — an in-archive file is only readable after purchase, so that
clause had been false since it was written. The rejection: the results file's `Fix
applied` column names rules inside the paid contract ("hedging-is-not-labelling rule",
"kit is not a to-do list"), and `EDITION-SPLIT.md` builds the price argument on a copier
not having "the record of which instruction was at fault each time". Publishing it hands
a non-buyer exactly that record. So the claim was cut instead of relocated: the suite
ships and the buyer can audit it, with no before-you-buy promise.

**One commitment changed mechanism.** `EDITION-SPLIT.md`'s promise that each re-run is
published in `evals/` had no delivery location once `results-*.md` stopped shipping. It
now says each release's CHANGELOG entry records what the re-run found and which file was
at fault — a mechanism that already exists and ships inside the archive. Known gap: a
re-run that ships no release records nothing, and nothing is built for that case.

**Builder and guard read one exclusion list.** `payload-exclude.txt` at the repo root,
one glob per line, read by `build-zip.sh` (via `--exclude`) and by `check_zip()` (which
filters the source tree with it). Two lists agreeing by coincidence is the shape of the
original defect — a PowerShell build verified by PowerShell extraction. A new assertion
in `check_sweeps` fails if the sales page references any path the list excludes, so copy
and payload cannot drift apart silently again. The content comparison is CRC-32 by
default (3.6s for the zip group, down from 23s) with full byte comparison behind
`SBP_ZIP_FULL=1` for release builds; the comment states plainly that a CRC match catches
accidental drift, not tampering.
