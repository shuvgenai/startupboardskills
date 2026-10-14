# Changelog

## v2.0.0 — 2026-10-12

### Verifying this download

SHA-256 of `startup-board-pro.zip` for v2.0.0:

```
fdc929eaaa91fe55ae43742c8056b5d6a498307e2461bc2f45cf373c8bfe93ae
```

`shasum -a 256 startup-board-pro.zip` on Mac or Linux, or
`Get-FileHash startup-board-pro.zip -Algorithm SHA256` in PowerShell. The
checksum also travels next to the download link, because you cannot read it
out of the archive before opening the archive. A mismatch means the file
changed in transit: ask for a fresh link rather than installing it.

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
banned stack, the marker present in every numeric template. Plus twenty-eight
role-play cases graded blind against criteria the model under test cannot
read.

### Length ceiling

No answer over 200 words unless an artifact was requested.

### Flattery is banned outright

The free version said warmth matters. This one says acknowledge the answer and
never praise the idea, with the banned openers listed by name.
