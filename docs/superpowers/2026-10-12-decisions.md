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
