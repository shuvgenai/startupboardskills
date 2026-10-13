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

## 2026-10-13 — the s27 fixture date, and what the advisor caught

**The fixture was arithmetically impossible, and it was corrected rather than tuned.**
`evals/cases/s27-flat-retention-measured.md` had a cohort starting the week of
1 September reporting a week-8 retention figure, with a Setup date of 2026-10-13. That
is 42 days — six weeks; week 8 would fall on 2026-10-27, fourteen days in the future.
The cohort start is now 4 August, whose week 8 lands on 2026-09-29 and is reachable.
This is not changing a fixture to make a case pass, which the runbook forbids: a fixture
that cannot be true tests nothing, because every correct reply is a reply about the
contradiction rather than about retention. Cost if wrong: one case's numbers differ from
the first draft, and the retention-versus-channel behaviour it was built for is tested
for the first time on the re-run.

**What the advisor did with the impossible version is worth keeping.** Run blind against
the broken fixture, it caught the error unprompted: "A cohort that started the week of
1 September reaches its eighth week in late October, and today is 13 October. That is
about six weeks in, so a week 8 figure of 58 can't have been counted yet. I won't build
on any of the numbers until I know what that 58 is." It then asked what date range the
figure covered, refused to call product-versus-channel until the very-disappointed
survey existed, and marked every cohort figure UNVERIFIED in the state file. Nobody
wrote a rule telling it to check whether a founder's dates were possible — phase 09's
"numbers that cannot all be true" covers internal contradictions between figures, not
figures against the calendar. The transcript is kept at
`evals/transcripts/s27-flat-retention-measured.md`, dated 2026-10-13, so the finding
survives the re-run that replaces it.

## 2026-10-13 — the checksum, and two things it cannot be

**A checksum cannot live inside the file it describes.** The first attempt wrote the
archive's SHA-256 into `pro/INSTALL.md` and `pro/CHANGELOG.md`. Both are payload, so
writing the value changed the archive and invalidated the value — a fixed point with no
solution. The literal now lives only in `pro/dist/CHANGELOG.md`, which is excluded from
the payload, and must travel next to the download link. `INSTALL.md` keeps the
verification commands and says plainly why the value is not printed there, because a
buyer verifies before extracting and could not read an in-archive value anyway.
Verified: zero 64-hex strings remain in any payload file.

**The archive is not byte-reproducible, so the checksum identifies a build and not a
content.** Two consecutive builds with no source edit produced
`f363b61a…` and `4a3ec350…`. Per-file mtimes are stable in the archive listing
(`SKILL.md 2026-10-12 23:24`), so the variance comes from the archive container rather
than the payload. The operational consequence is a rule, not a bug: build once at
release, publish that file's sum, ship that exact file, and if you rebuild for any
reason you must republish the sum. A buyer's mismatch therefore means "this is not the
file we published", which is the question worth answering, and not "the contents
differ", which it cannot answer. Making the build reproducible is possible — bsdtar can
clamp mtimes — and is deliberately not done here, because it is a change to the build's
contract and nobody asked for it. Cost if wrong: anyone who rebuilds and forgets to
republish hands buyers a checksum that fails on a good file, which trains them to skip
the check.

## 2026-10-13 — the four deferred minors, cleared or re-deferred

**Cleared: ROOT resolution hardening.** `build-zip.sh` now sets `CDPATH=` before the
`cd` that resolves `ROOT`, so a set `CDPATH` cannot print a directory and corrupt it,
and the failure path names what went wrong instead of a bare `exit 1`. The symlink half
is unchanged and does not need to change: invoked through a symlink the script resolves
`pro/` beside the link rather than the target, and the member-presence loop then fails
loudly with the missing file named. Loud and wrong beats silent and wrong.

**Cleared: the duplicate version spawn.** The libarchive probe captured the banner it
was already reading, so `--version` runs once instead of twice. The probe also moved
from `grep -qiE` to a POSIX `case`, which drops a second subprocess per candidate.

**Re-deferred: the Info-ZIP `zip` fallback is still never exercised.** There is no `zip`
binary on this machine, so the branch cannot be reached without installing one, and the
refusal test only reaches the no-writer arm *because* `zip` is absent — on a host that
has it, the same test would take the fallback instead and the refusal would go untested.
The branch is correct by construction (Info-ZIP writes `/` separators) and the builder's
own final guard would catch a bad archive from it. Re-deferred rather than cleared, with
the environment-dependence now stated, because the honest fix is a CI lane with `zip`
installed and that is infrastructure nobody has asked for.

**Cleared by context: the "buyer sends back" framing.** `evals/RUNBOOK.md:35` offers to
check "an archive you did not just build, including one a buyer sends back". When that
was flagged there was no download source, so the sentence described a buyer who could
not exist. Two things changed: `RUNBOOK.md` is no longer in the payload, so it addresses
the maintainer rather than the buyer, and the recommended channel now puts the archive
in buyers' hands with a published checksum, which is exactly the situation where someone
mails a file back and asks whether it is the right one. The capability is real —
`check.sh zip <path>` takes any archive — so the line is now accurate as written.

## 2026-10-13 — three repos became two, and route 3 was dropped

**`shuvgenai/startup-board-pro` is being deleted, and nothing unique dies with it.**
Its five commits held a copy of `pro/` that was verified byte-identical to the dev
repo earlier the same day, so the consolidation moved no work: everything already
lived in `shuvgenai/startupboardskills`. The reason is maintenance cost before
revenue — two repositories to keep in step, for a buyer list of nobody. Cleanup was
done while the repository still existed, so references could be checked against it
rather than guessed at after the fact.

**What it costs: the only automatic update path.** Route 3 was the one route where a
fix reached a buyer without them re-downloading (`/plugin marketplace add`, then
`/plugin update`). That is gone. `INSTALL.md` now has two routes and a section that
tells the buyer plainly there is no automatic update path; `README-PRO.md` says two
routes rather than three; `EDITION-SPLIT.md`'s price argument was rewritten rather
than patched, because the old version rested on "a test that catches drift and a
channel that delivers the correction" and the channel half is no longer true. It now
says detection is what compounds, delivery is manual, and a buyer who never
re-downloads is running a version whose drift someone else already found. The
commitment list's point 3 is marked as the weak one instead of being presented as a
mechanism.

**Is the price argument weaker? Yes.** Not fatally — the suite, the gates and the
evidence model are the material a copier cannot reproduce, and those are untouched —
but the strongest version of the pitch paired detection with delivery, and only
detection survives. Recorded rather than smoothed over, because a buyer who discovers
it after paying is a worse outcome than one who reads it first.

**The manifests: `plugin.json` kept and repointed, `marketplace.json` removed.** A
marketplace listing is inert without a marketplace repository, and the URL it named
now 404s, so it shipped a false artifact to every buyer. `plugin.json` survives with
its `homepage` and `repository` pointed at `startupboardskills`, because it is the
plugin's own identity and `check_plugin` uses its `description` to catch drift against
`SKILL.md`'s frontmatter — a real assertion worth keeping. `check_plugin` no longer
requires the deleted file. Cost if wrong: if a marketplace is ever published, a new
`marketplace.json` has to be written at that repository's root, which is where it
belonged anyway rather than inside the payload.

## 2026-10-13 — startupboardskills stays private, with a per-buyer collaborator add

**Ruled private, and the reasoning is reversibility rather than secrecy.** The eval
cases and answer keys ship to buyers anyway, and `dist/EDITION-SPLIT.md`'s own leak
analysis concedes they are copyable in an afternoon, so going public would not give
away much that a buyer does not already hold. The asymmetry is what decided it:
public is irreversible and private is not. Anything cloned while the repository is
public stays cloned, by anyone, forever, including the decision record and both
claim sweeps if they are still in the repo when the switch is flipped. Private costs
a manual collaborator add per buyer, which is a fine problem to have at twenty buyers
and a bad one at two hundred.

**Revisit trigger:** when the manual adds hurt — concretely, when collaborator
management becomes a routine task rather than an occasional one, or when a buyer is
blocked on an add for more than a day. At that point the choice is a public
buyer-facing repository holding only `skills/`, the manifest and the release assets,
with everything in this decision record already moved to the private dev repo, so
going public no longer exposes the working history.

**Consequence that must ship with it:** `pro/INSTALL.md`'s plugin route must state
that a buyer needs collaborator access before `/plugin marketplace add` will work
against a private repository. That was true of the deleted distribution repo and went
unstated, so a buyer's first command would have 404'd. A 404 on first install is the
worst first impression available.

## 2026-10-13 — a rule in the wrong file looks exactly like a rule in the right one

**The fix that mattered today was a file move, not a wording change.** Case s26 failed
three times on the same move: the advisor asked the founder what *they* did the last
time the problem bit, and justified it as the one case whose detail was already
available. The prohibition was written into `references/evidence-rubric.md` rule 4
after the first failure, in clear terms, and the case failed again with it in place.

The reason is routing, not wording. `SKILL.md:104` names the rubric once, as the
authority for scoring a claim 0 to 3. Nothing routes to it at the moment a question is
chosen, and `references/conversation-contract.md` — the file read every turn — said
nothing about who a question may be asked of. So the advisor scored the founder's
claims 0 correctly and then picked a question from files that were silent on the point.
The rule was correct, readable, and never executed.

**Split along the seam of the question each file answers.** The contract answers *what
may I ask next?*, so the prohibition lives in its section 1, which already governs the
turn's question. The rubric answers *what does this evidence score?*, so the scoring
half stays there. Each half now names the other and states which question it answers,
because a bare cross-reference is what decays. s26 passed on the first blind re-run
after the move.

**The lesson generalises and is the fourth instance today.** Phase 06's gate line,
phase 08's missing test, the `artifacts-index` mismatch and this one are all the same
defect: a requirement stated in one file and contradicted or unreinforced in another,
with nothing asserting the pair. Three were fixed by stating the constraint where it is
applied; this one by moving it there. In every case the only thing preventing the next
occurrence is an author remembering, which is what `check_invariants` exists to replace
for refusals and does not yet do for anything else. Cost if wrong: nothing in this
ruling, but the pattern will recur until something asserts cross-file consistency.

## 2026-10-13 — the 21 relabels, and a check that found a sixth instance

**Relabelled, never cut.** All 21 S1 unlabelled claims from
`2026-10-13-claims-and-gates-sweep.md` are closed: 17 edited, 4 already done earlier
the same day. Three more were added on the controller's ruling — the
"three things that move the number" duplicate pair in `phases/08` and
`artifacts/raise-plan.md`, and "the room will find it" in `advisors/09` — because
leaving in-family claims unlabelled makes the fix internally inconsistent. Cutting was
refused throughout: it teaches future authors that unlabelled claims get deleted, which
selects for bland phases, where relabelling teaches them to say where a claim came from.

**Working by duplicate group found two copies the sweep never catalogued:** a third
copy of the warm-list claim at `phases/07-launch.md:42`, and a copy of the vesting
claim at `advisors/08-founder-strategy.md:64`. Fixing file-by-file would have left both.

**Three rows were judged method, not claim, and left alone:** "the two conversations
feel identical", "cumulative counts never go down", and the two-ways-to-run-a-product
framing. A label on a statement of the product's own method is noise. One further row
was re-judged by the controller against its own earlier ruling: `advisors/09:78`'s
"300% month on month from three customers to nine" is an illustration of a framing
pattern, not an assertion about behaviour, so it stays unlabelled — the line below it,
which asserted how a room behaves, was labelled instead.

**Two cross-file assertions now exist, and the first one worked immediately.**
`check_invariants` sections 5 and 6: an artifact's gate must agree across the index,
the owning phase's `**Pass gate:**` and its `**Artifact:**` block; and a rule split
across files must have both halves naming each other, so a one-way pointer fails as a
dangling reference. On its first run against the live tree, section 5 found a sixth
instance of the day's defect class: `phases/04-artifacts.md`'s `**Artifact:**` line
omitted `positioning-statement.md` while that phase's own body granted it at score 2
and the index said "Phase 04 or 07". Fixed the same way ruling B fixed phase 07 — each
artifact states its own condition in the phase, not only in the index.

**Known limits of the assertions, recorded so nobody over-trusts them.** Score matching
is by digits, so `phases/10`'s "12 months" satisfies a score-3 demand; prose gates such
as "Problem passed" are skipped rather than interpreted; and reciprocity is checked per
file rather than per block, so a second unrelated split-block in the target would
satisfy it. Assertion 2 from the recommendation — gate versus the score its named test
produces — was deliberately not built, because it needs a keyword map from test phrasing
to evidence score, which encodes judgement the files state only in prose.
