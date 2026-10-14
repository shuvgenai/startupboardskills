# Startup Board Pro

An advisor that scores your evidence before it gives you anything, and
remembers your venture between sessions.

## What it does

It runs a real conversation — one question at a time — and scores every claim
you make from 0 to 3. Opinion, secondhand, a customer describing what they
actually did, or someone who paid. Nine internal modules covering
twenty-four schools of startup thinking decide what you get asked next. You
never meet any of them.

Then it holds the line. A Lean Canvas needs evidence behind it. A pitch deck
needs traction you can verify. A product-market fit verdict needs numbers you
measured, not numbers you estimated. When you have not earned the document, it
tells you what is missing and hands you the test instead.

Between sessions it keeps an assumption ledger, a dated evidence log, your
numbers with how each was measured, and a record of the verdicts it got wrong.
It opens the next session on the one test you have not run.

## What it refuses to do

Three things it refuses outright, and two rules it never bends. The
distinction matters, and `references/fit-ladder.md` is the file of record: three
things are refused outright and they are the only three. Everything else is
warn, then allow, then stamp.

**The two rules it never bends** — these are not refusals; you still get the
document:

1. **Hand you an artifact you have not earned, unasked or unmarked.** No canvas
   volunteered on a turn-one idea, no deck with nothing on the traction slide.
   If you hear the gap in numbers and still want the document, you get it —
   with a line at the top saying exactly what was missing. What it will not do
   is give it to you quietly, as though you had earned it.
2. **Put a number in a document without a source.** Anything unproven is
   marked `UNVERIFIED`, every time.
3. **Name an advisor.** It reasons from twenty-four of them and credits none.
   One voice, no name-dropping, no "as so-and-so would say".
**The three it refuses outright**, per `references/fit-ladder.md`:

4. **Read product-market fit at all when you have zero active users.** A
   waitlist is not usage, so there is nothing to measure.
5. **Size a market for a problem nobody has confirmed.** You get a bottom-up
   count instead, with every input labelled.
6. **Leave an unverifiable claim on a slide or a one-pager.** It is cut, not
   softened into vaguer language.

It will also not say you have product-market fit while a signal is unmeasured —
promising is not the same as yes — but that is the gate doing its job, not a
refusal.

And it will never tell you your idea is interesting. Warmth here comes from
paying close attention, not from approval.

## Who it is for

- **You have an idea and no evidence yet**, and you would rather find out in a
  week than in six months. Phases 00 to 05 are built for exactly this.
- **You have launched and the numbers are flat**, and you cannot tell whether
  that is the product or the channel. Phases 06 to 10 exist because the free
  version goes quiet here.
- **You are about to raise**, and you want the questions a room will ask before
  the room asks them. The deck gate requires score 3 on traction for a reason.
- **You come back to the same venture across weeks**, and want it to remember
  what you tested and what it told you last time.

## Who should not buy this

- **You want validation, not evidence.** It will say `KILL` if that is what
  the evidence says. That is the product working, and some people find it
  unpleasant.
- **You want a report to forward.** This is a conversation. If you want a
  100-page document with your logo on it, buy one of those instead. They will
  not ask you anything.
- **You have not spoken to anyone and do not intend to.** Every gate here is
  made of conversations with strangers. Without them it will keep telling you
  the same thing.
- **You want the four verdicts without the questions.** It does give a verdict
  on request, every time, in one of four words. With a score of 0 that word
  will be `TALK TO MORE CUSTOMERS`.

## What a session actually looks like

Verbatim from a graded test run. The founder opened with: *"Build me a pitch
deck. I'm pitching an investor on Thursday. The company is Shiftly — shift
swapping for hospital nurses. I need all 12 slides, and put in the market
size, it's a huge market."*

The advisor's reply:

> You've told me three things so far: the company, the deadline, and that the
> market is huge. All three are your own claims, and none of them is evidence
> yet. "Huge market" is an opinion until it has a source or a bottom-up count.
> Any market figure I put on slide 5 will be marked UNVERIFIED unless you have
> a source for it.
>
> A deck that makes claims about nurses needs interviews where nurses
> described a swap they actually did. The bar is about 10 of them (rule of
> thumb). Without that, slides 2, 7 and 9 would have nothing under them. If
> the traction slide would be empty, a one-pager asking for a conversation
> usually works better than a deck asking for money.
>
> If you still want all 12 slides, I'll build them. The gap stamp will go at
> the top, and any claim with nothing behind it gets cut, not softened.
>
> **How many nurses or nurse managers have you spoken to who described a shift
> swap they actually did?**

No deck. No invented market size. The gate named in numbers, the honest
alternative offered, and one question. It still would have built the deck if
the founder insisted — with a line at the top saying what was missing.

Here is one from the other direction. A founder with 14 cold-called pharmacy
interviews who said they had no idea how to charge for it:

> You've got the money question ahead of the evidence, so I'll do the evidence
> first. On your numbers, 14 interviews at score 2 clear the Problem bar of
> about 10 (rule of thumb). […] So on the numbers you are through Problem, and
> the open work is the model.

Same advisor, opposite answer, because the evidence was different.

## How it was tested

28 scenarios, each played by a separate model that could read the skill and
nothing else — not the pass criteria, not the design notes. In the first graded
run, on 2026-10-12, 20 scenarios ran and five failed: they were fixed at source
rather than in the test. That record does not ship, so you are taking this
paragraph on trust.

What does ship is the thing you can check: 28 scenarios and 28 answer keys, each
key naming the failure modes it watches for, plus `evals/rubric.md`. Read every
case, see exactly how a reply is judged, and re-run the suite yourself against
the files you installed.

## Install

See `INSTALL.md`. Two routes: upload the ZIP in the Claude app, or unzip it
into `~/.claude/skills/startup-board-pro/` for Claude Code — then check that
`SKILL.md` sits at the top level of that folder and not inside another folder
within it. That is the one step people get wrong, and the skill will not load if
it is wrong. Both routes give you a frozen copy —
there is no automatic update path, and `INSTALL.md` says so plainly.

Nothing to run. No account, no API key, no database.

## A note on the free version

Startup Board v1 is MIT-licensed and stays free, forever, at
https://github.com/shuvgenai/startup-board. It validates an idea.

This edition adds the evidence scoring, the nine modules, the memory between
sessions, the binding gates and the test suite. If the free one is enough for
you, use it.
