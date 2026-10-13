# Startup Board Pro

**An evidence-gated startup advisor that runs inside Claude, asks one question at a time, and refuses to hand you a document you have not earned.**

Most AI idea-validation tools give you a report. This gives you an interrogation, a score and a verdict — then remembers your venture between sessions and holds you to what you said last time.

It is a Claude Skill: plain Markdown files that Claude reads as instructions. Nothing to run, no API key, no account, no database, no subscription.

---

## What it does

- **Scores every claim you make, 0 to 3.** Your opinion is a 0. A forum thread is a 1. One customer describing what they actually did last Tuesday is a 2. Someone paying, switching tools or signing something is a 3.
- **Gates every document behind the evidence that earns it.** A Lean Canvas needs score 2. A traction slide needs a 3. Below the gate you get the test that would close it, not the document.
- **Asks one question per turn.** No numbered lists, no "tell me X, Y and Z". It reacts to your answer before asking the next thing.
- **Never compliments your idea.** No "great question", no "strong insight", no encouragement standing in for analysis.
- **Remembers.** A state file carries your assumption ledger, evidence log, numbers and open loops between sessions, so session four does not start from scratch.
- **Gives four verdicts and only four:** `PROCEED`, `PIVOT`, `TALK TO MORE CUSTOMERS`, `KILL` — each with the single riskiest untested assumption and one action for this week.

## What it refuses to do

This is the shorter list, and it is the point.

- **It will not invent a number.** No market sizes, no competitor counts, no conversion benchmarks. Every figure comes from you, carries a source, or is labelled `(rule of thumb)` at the point of use. Numbers inside any file it writes are marked `UNVERIFIED` unless sourced.
- **It will not treat enthusiasm as evidence.** Ten people saying they would use it is one score-0 claim repeated ten times.
- **It will not run a fit check-in with zero active users.** There is nothing to measure.
- **It will not size a market for a problem nobody has confirmed.** You get a bottom-up count instead.
- **It will not soften an unverifiable claim on a pitch slide.** The claim is cut, not reworded.

Everything else is warn, then allow, then stamp: if you insist on a document you have not earned, you get it with a gap stamp on the first line naming what is missing.

## Who should not buy this

- You want validation. It is built to withhold that.
- You want a report to show an investor this week. The honest output at week one is a list of conversations to have.
- You have no way to reach customers. It will keep asking how you will, because that is the gate.

---

## How to Install

Two routes. Pick the one matching where you use Claude.

### Before you start: verify the download

Download `startup-board-pro.zip` from the link in your purchase receipt, then confirm it is the file that was built:

```bash
# macOS / Linux
shasum -a 256 startup-board-pro.zip

# Windows PowerShell
Get-FileHash startup-board-pro.zip -Algorithm SHA256
```

It must print the checksum published next to your download link. For **v2.0.0**:

```
150cc97b595a60c796a9b1766bbfb975063792102fcd5b7cd298abccf539eaea
```

A mismatch means the file changed between us and you. Ask for a fresh link rather than installing it — this is a skill a model reads as instructions.

### Route 1 — the Claude app

1. Open Claude → **Settings** → **Capabilities** → **Skills**.
2. Upload `startup-board-pro.zip` **as it downloaded**. Do not unzip it first.
3. Start a new conversation and type: *roast my startup idea*.

### Route 2 — Claude Code

1. Unzip `startup-board-pro.zip`.
2. Move the folder to your skills directory, renamed `startup-board-pro`:
   - **Windows:** `C:\Users\<your-name>\.claude\skills\startup-board-pro\`
   - **macOS / Linux:** `~/.claude/skills/startup-board-pro/`
3. Confirm `SKILL.md` sits at the **top level** of that folder, not inside another folder. This is the one step people get wrong.
4. Restart Claude Code and type: *roast my startup idea*.

### Check it loaded

Type any of these. If the advisor replies with **one** question and no enthusiasm, it is working:

- *roast my idea*
- *do I have product-market fit?*
- *someone already built this, is there any point?*
- *should I keep going or quit?*

### Updates

Both routes give you a frozen copy. There is no automatic update path — when a new version ships, the release notes say what the re-run of the test suite found and which file was at fault, and you download and install again. Nothing phones home.

---

## What is in the box

| | |
|---|---|
| Router skill | `SKILL.md`, 172 lines, loads only what a turn needs |
| Phases | 11, numbered 00–10, from intake to scale |
| Advisor modules | 9 reference modules shaping the questions |
| Artifact templates | 15, each gated on an evidence score |
| Evidence rubric | 0–3, with worked examples per level |
| Fit ladder | six stages, each with a testable pass condition |
| Test suite | 28 blind-graded scenarios with answer keys |
| Static checks | 612 assertions over the skill's own files |

The 9 advisor modules carry the thinking of two dozen operators and writers. **None of them is ever named to you.** The influence shows up as the question you get asked next, not as a quotation.

## The test suite ships with it

A Markdown skill is instructions to a model, and the model changes underneath it. An instruction that reliably produced one question per turn in October can start producing three after a model update, and nothing in the file changes to warn you.

That is what the eval suite is for: **28 scenarios, blind-graded** — a separate model plays the advisor with access to the skill files and nothing else, then its reply is graded against an answer key it never saw. The cases and the answer keys ship with the product, so you can read what it is tested against and re-run it yourself.

`check.sh` adds **612 static assertions** over the skill's own files: that every phase states a numeric gate, that no phase invents a refusal the fit ladder does not sanction, that an artifact's required score agrees across every file that mentions it, and that no unsourced claim about markets or investors is stated as fact.

---

## FAQ

**Is this just a prompt?**
No. It is a router plus 9 advisor modules, 11 phase files, 15 artifact templates, an evidence rubric, a state-file format and a 28-case test suite. The router stays under 200 lines and loads only what a turn needs, which is what stops a long session degrading.

**I can read the Markdown. Why pay for text files?**
You can, and you should before you buy. What you are paying for is not secrecy, it is the work: the evidence rubric that stops ten compliments counting as validation, the gates, the test suite, and the updates when something is found to be wrong.

**What is the difference from the free version?**
The free version validates an idea. This adds the phases after launch — product-market fit, metrics, traction, founder strategy, fundraising — plus the evidence scoring, the memory between sessions, the binding gates and the artifact library. The free version stays free and is not going away.

**Does it work in the Claude app, or only Claude Code?**
Both. Route 1 is the app, route 2 is Claude Code. The skill detects which environment it is in and adapts how it saves files and asks multiple-choice questions.

**Does it send my idea anywhere?**
No. There is no telemetry, no phone-home and no server. It is files Claude reads. Your conversation goes wherever your Claude conversations already go.

**Will it tell me my idea is good?**
No. It is built not to. If you want a verdict you get one of four strings, and `PROCEED` requires evidence you will have had to go and collect.

**What if I want the document anyway?**
You get it, with a gap stamp on the first line naming what is missing. It never refuses outright except in three documented cases: a fit check-in with zero active users, market sizing below the research gate, and an unverifiable claim on a slide or one-pager.

**Does it do market research?**
Yes, at three depths, each gated. A light scan of who else solves the problem needs score 1. A positioning map needs 2. Market sizing needs 2 plus a passed Problem stage — because a market size for an unvalidated problem makes an idea feel real without making it more likely to work.

**What stack does it recommend for building?**
Prompt-first and no-code tools a non-technical founder can actually use: React, Supabase, Vercel, Stripe, Airtable, and the Claude and OpenAI APIs. Every build step ships with a copy-paste prompt rather than an instruction to hire someone.

**Can I get a refund?**
Ask. It is Markdown — you will know within one session whether it is for you.

---

## Licence

The free edition is MIT and stays that way. This paid edition ships under its own licence: you may read every line, use it on your own ventures and modify it for yourself. You may not republish or resell it. See `LICENSE`.

---

## Topics

GitHub indexes **Topics**, not hashtags — set these in *Settings → Topics*:

`claude-skill` · `claude-code` · `anthropic-claude` · `startup-validation` · `idea-validation` · `product-market-fit` · `mom-test` · `customer-discovery` · `lean-startup` · `founder-tools` · `ai-agents` · `prompt-engineering` · `startup-tools` · `mvp` · `no-code`

For social posts, where hashtags do work:

`#ClaudeSkills` `#ClaudeCode` `#BuildInPublic` `#StartupValidation` `#ProductMarketFit` `#MomTest` `#CustomerDiscovery` `#LeanStartup` `#IndieHackers` `#FounderTools` `#AIForFounders` `#NoCode` `#MVP` `#SoloFounder` `#StartupIdeas`
