# Changelog

## v2.1.0 - 2026-11-06

Distribution only. Not one word of the advisor's behaviour changed: the
phases, the gates, the evidence rubric and the refusals are byte-identical
to v2.0.0. What changed is how many places you can install it.

### Four install routes instead of two

The Claude app's plugin uploader refuses an archive without
`.claude-plugin/plugin.json` at its root, and its skill uploader refuses any
archive that contains one. One archive cannot satisfy both, so the build now
produces each separately. Codex reads a plain folder, so the skill archive
serves it unzipped. A custom GPT reads neither, and caps instructions at 8000
characters and knowledge at 20 files, so it gets a condensed instruction file
plus four bundles merged by directory.

`INSTALL.md` now names which artifact each route needs, and what the error
message looks like when the wrong one is uploaded.

### The custom GPT route is a reduced build

It carries all 11 phases and all 29 reference files. It does not carry the
eval suite, which is 90 files a founder never reads and would consume most of
a GPT's 20-file budget. The behaviour is the same; what you lose is the
ability to re-run the tests yourself.

Because a custom GPT cannot see your files, that build asks you to paste
`startup-board-state.md` in at the start and prints the updated file back at
the end of every session. Without saving that block, the session is lost.

### The build verifies all three artifacts against one list

`payload-exclude.txt` already decided what the archive leaves out. It now
governs the GPT bundle too, and the guard asserts the plugin manifest is
present when the plugin archive is built and absent when the skill archive
is. Uploading the wrong file to the wrong route now fails at build time
rather than at upload time.

## v2.0.0 — 2026-10-12

The first paid edition. Same conversation shape as the free version, same
0 to 10 phases, same six fit stages — different enforcement.

### Evidence is now scored, not just counted

Every claim a founder makes gets a score from 0 to 3: opinion, secondhand,
primary, behavioural. Phase gates read the score.

The practical effect: "I talked to ten people and they all loved it" no longer
passes anything. Ten compliments are one opinion repeated ten times, and the
advisor now says so.

### Nine modules replace eight advisors

The free version reasons from eight thinkers across problem, business model
and metrics. This edition has nine modules covering twenty-four, and the six
new ones cover the stages where the free version goes quiet: product
management, growth channels, founder strategy and fundraising.

The founder who has launched, has users, and cannot tell whether flat
retention is a product problem or a channel problem now gets a diagnosis
instead of a checklist.

### The venture is remembered properly

`startup-board-progress.md` becomes `startup-board-state.md`, and it now holds
an assumption ledger, a dated evidence log, the numbers with how each was
measured, decisions with a revisit condition, open loops, and a calibration
record of verdicts that turned out wrong.

Three loops run on it. A session opens on one unresolved assumption rather
than a recap. A reported result is scored and logged. An overturned verdict is
written down with the question that would have caught it sooner.

**Returning free-version users:** your old progress file is read and carried
across automatically. Nothing is overwritten, and the old file is left where
it is.

### Gates that actually bind

The free version's build phase said "only after a proceed verdict, or if the
founder explicitly asks". Every founder asks, so the gate never fired. It is
gone. A founder can still get the blueprint early, but the gap is stated in
numbers first and the output carries a stamp saying what was missing.

Artifact production is gated the same way. A Lean Canvas now needs score 2
behind it; below that you get the interview script instead, because that is
the thing that produces the score.

### Valuation, dilution and terms

New in this edition. The free version had nothing to say about a raise.

It will never give you a valuation figure — not a number, not a range, not a
multiple. At pre-seed, price is negotiated rather than calculated, and an
invented figure is the most harmful number this product could produce, because
you would carry it into a room and defend it.

What it does instead: runs the dilution arithmetic on whatever price is on the
table, with every division shown, and runs it again for one more round the same
size. Puts SAFE and convertible-note terms in plain words, including why a cap
is the worst price the investor pays and not a ceiling on what you give up.
Keeps only comparables you have actually seen the terms of, each with a source.
And says once that a lawyer reads the actual paper.

Same for co-founder equity: no recommended percentage, just what each person is
committing and whether vesting is in writing.

### Verdicts are bounded by evidence

Four verdicts, as before. New: a table saying which ones the evidence allows.
A score of 0 cannot reach PROCEED. A founder who asks on turn one gets a real
answer — TALK TO MORE CUSTOMERS — rather than an encouraging maybe.

### The stack changed

Out: n8n, Supabase, Zapier. In: a Claude Artifact for the cheapest first test,
then Lovable, Bolt or Replit, with Airtable plus Softr or Glide for data-heavy
products. Payments are a Stripe hosted checkout link at every tier.

Reason: the old default asked a non-technical founder to understand database
tables and row-level security. The new one does not.

Five MVP shapes now ship as ready-to-paste build prompts.

### One marker for anything unverified

The free version used three different conventions for an unproven number. Now
there is one: `UNVERIFIED`. It is greppable, so it can be checked
mechanically.

### A test suite that can fail

`evals/check.sh` asserts the mechanical rules — the line ceiling, no advisor
named in anything the founder sees, a numeric gate on every phase file, no
banned stack, the marker present in every numeric template. Plus fifteen
role-play cases graded blind against criteria the model under test cannot
read.

### Length ceiling

No answer over 200 words unless an artifact was requested.

### Flattery is banned outright

The free version said warmth matters. This one says acknowledge the answer and
never praise the idea, with the banned openers listed by name.
