# Free and paid editions

Date: 2026-10-12

## The split as it actually stands

| | Free (v1.1.0, MIT) | Pro (v2.0.0) |
|---|---|---|
| Phases | 00 to 10, same range | 00 to 10, same range, each with a numeric gate |
| Advisor coverage | 8 thinkers, 3 internal seats | 24 across 9 modules, fixed shape, 77 questions |
| Post-launch depth | PMF check-in and scale only | adds product management, growth channels, founder strategy, fundraising |
| Evidence handling | counts interviews | scores every claim 0 to 3; compliments and the founder's own experience score 0 |
| Phase gates | numeric at 02, 09, 10; absent or silently waivable elsewhere | numeric at all eleven; below a gate nothing is volunteered, and an insisted-on artifact carries a stamp naming the gap |
| Verdicts | 4, unbounded | 4, bounded by a score table; 0 cannot reach PROCEED |
| Artifact gating | none | minimum score per artifact; below it, the test is offered instead |
| Unverified numbers | 3 inconsistent conventions | one marker, `UNVERIFIED`, mechanically checked |
| Memory | progress file: stage, verdict, evidence log | state file: assumption ledger, evidence log, numbers with provenance, decisions, open loops, calibration |
| Session opening | recap | OPEN LOOP on one unrun test |
| Length ceiling | none | 200 words |
| Flattery | "warmth matters" | banned by name |
| Artifact templates | 13 reference files | 14 templates plus an index, with output filenames pinned |
| MVP stack | Supabase, Zapier optional | Claude Artifact, then Lovable/Bolt/Replit, Airtable with Softr/Glide; 5 ready-to-paste prompts |
| Tests | 12 role-play scenarios, 5 invariants | 28 scenarios, 11 invariants, a static checker, and a published failure record |
| Install routes | ZIP, folder | ZIP, folder |

## Why the recommended split cannot be implemented

The split proposed before this build — free keeps phases 00 to 05 and modules
01 to 03, pro adds the rest — is not available. v1.1.0 already published all
ten phases under MIT, including the fit check-in and the scale phase. MIT is
irrevocable for what is already out there. Anyone can fork v1 today and keep
every phase.

So the line cannot be drawn at features the free version already has. It can
only be drawn at material that is new. That is what the table above reflects:
the free edition keeps everything it ever had, and Pro is differentiated by
enforcement, memory and proof rather than by withheld phases.

Deleting or crippling the free version would also be the wrong move
commercially. It is the funnel, and the main competitor is not another paid
tool — it is a founder opening Claude and asking directly.

## Where this split leaks

Honestly: almost all of it is copyable, and quickly.

A motivated buyer with the free version, a reading list and a weekend could
rebuild the nine advisor modules. They are questions derived from published
books, and they are the most visible thing in the marketing — which means a
copier knows exactly what to aim at. The conversation contract is eight rules
and copies in ten minutes once seen. The artifact templates are mostly
standard frameworks that were never mine. The state file and its three loops
copy as text in an afternoon, though the discipline of actually keeping them
is a habit rather than a file.

The evidence rubric is the first thing that resists. Not the four levels —
those are obvious once stated — but the calibration: that a compliment scores
0 however many people gave it, that the founder's own experience scores 0, that
a pass number decided afterwards voids the test. Each of those came from
watching a run fail.

What cannot be copied in an afternoon is proof that any of it works. A copy
has files. It does not have twenty-eight graded runs, seven documented failures, and
the record of which instruction was at fault each time.

## The one thing that carries the price

**The eval suite, and the update cadence it makes possible.**

Not because it is secret — it ships with the product, answer keys and the failure modes they watch for included — but
because it is the only asset here that a copier cannot produce without redoing
the work, and the only one that compounds.

A Markdown skill is instructions to a model, and the model changes underneath
it. An instruction that reliably produced one question per turn in October can
start producing three after a model update, and nothing in the file changes to
warn you. Every competitor selling a prompt pack has this problem and none of
them can tell you whether their product still behaves the way the sales page
says.

The eval suite is what detects that: 28 scenarios, blind-graded, run
against the actual files.

What it does not come with is a channel that pushes the fix to you. There was a
plugin route that updated with one command; it is gone, dropped before the
first sale rather than maintained as a second repository for a buyer list of
nobody. So the claim is narrower than it was: the suite catches the drift, the
release notes say what it caught and which file was at fault, and you
re-download. You are told, rather than served.

Stated plainly, because it is the part a buyer should weigh: detection is what
compounds, delivery is manual, and a buyer who never re-downloads is running a
version whose drift someone else already found.

The nine modules are the marketing. The eval suite is the product.

## The commitment behind that claim

The argument above rests on maintenance, so the maintenance is stated rather
than implied. Without these four lines the claim is self-flattery.

1. **The suite is re-run** when a new Claude model becomes the default in the
   Claude app or Claude Code, and whenever a buyer reports a case failing.
2. **Each release records its re-run.** That version's CHANGELOG entry, which
   ships in the archive, states what the re-run found and which file was at
   fault.
3. **Fixes are announced, not pushed.** A new version's release notes name
   what the re-run found and which file was at fault, and buyers re-download.
   There is no automatic update path; `INSTALL.md` says so to the buyer too.
4. **A regression is said out loud.** If a re-run shows the skill no longer
   behaves the way this document claims, that goes in that CHANGELOG entry
   rather than being quietly patched.

Three of the four are mechanisms rather than promises: the re-run trigger, the
published results, and saying a regression out loud all happen in files that
ship or in release notes that do. Point 3 is the weak one. It was a mechanism
while a distribution repository served the plugin route; that repository is
gone and the delivery step is now the buyer choosing to re-download. The re-run
trigger and the published cadence are still the part a copier cannot take, but
nobody should read point 3 as automatic.

One honest caveat on the proof as it stands: the first run is fifteen
scenarios, one model, one day, graded by the author. That is a real artifact
and more than a prompt pack ships, and it is still a snapshot — which is the
whole reason the re-run trigger above matters.

## No licence enforcement, stated plainly

Licence keys, obfuscation and phone-home code do not work in a Markdown skill.
Every file is readable text that the buyer can open, edit, and pass on. A
check written into the instructions is a check the buyer can delete in one
edit, and a skill that tried to call home would be both trivially removable
and a reason not to trust it.

None of them will be added. The moat is the material and the updates, and
pretending otherwise would break the same rule this product is built on:
do not claim something you cannot evidence.
