# Raise plan

**Earned at:** Phase 08. Minimum evidence score 2 for any claim, score 3 for
any traction claim.

## The rule that governs this file

**This skill will never produce a valuation figure.** Not a range, not a
"typical", not a multiple of revenue. A pre-seed valuation is not calculated,
it is negotiated, and a number invented here would be the single most harmful
number in the whole product: the founder would take it into a room and defend
it.

What this file does instead:

1. Shows the **dilution arithmetic** on whatever price the founder has been
   offered or is considering, with the working visible.
2. Records what the money is **for**, and what it unlocks.
3. Holds the **terms** in plain words, so the founder knows what they are
   agreeing to.
4. Keeps **comparables** the founder has actually seen, each with a source.

If the founder asks what their company is worth, the honest answer is in the
section below, and it is not a number.

## Template

```
# Raise plan: <venture> — <date>
> <gap stamp, only if an earlier stage was not passed>

## The ask
Amount:        <figure the founder gave>
Instrument:    <priced round | convertible note | SAFE | not decided>
Price offered: <figure, or UNVERIFIED if nobody has offered one>
Source:        <who offered it, and when — or: no offer yet>

## What it is for
| Use of funds | Amount | What it unlocks | Milestone it reaches |
|---|---|---|---|

Runway it buys: <months>   [UNVERIFIED unless monthly burn is measured]

## Dilution, at the price on the table
Working shown. Every input is the founder's own figure or UNVERIFIED.

| Step | Working | Result |
|---|---|---|
| Post-money value | pre-money + amount raised | UNVERIFIED |
| Share sold this round | amount raised / post-money value | UNVERIFIED |
| Founder share after | founder share before x (1 - share sold) | UNVERIFIED |
| Founder share after a second round of the same size | repeat the line above | UNVERIFIED |

## Terms, in plain words
| Term | What it says | What it means for you if things go badly |
|---|---|---|

## Comparables the founder has actually seen
| Company or deal | Stage | Terms | Source URL | Seen or heard? |
|---|---|---|---|---|

Nothing goes in this table without a source. A figure someone mentioned on a
podcast is heard, not seen, and it is marked that way.
```

## When the founder asks what it is worth

Answer this honestly rather than reaching for a number.

At pre-seed there is no formula. There is no revenue to multiply and no
profit to discount, so price is set by three things: what comparable deals in
that market and geography closed at recently, how much the investor wants in,
and how much the founder needs. The third one is the only one the founder
controls, which is why the useful question is not "what am I worth" but "how
little can I raise to reach the next milestone that changes the answer".

Three things that actually move the number, and all of them are evidence:

- **Revenue that repeats**, with the months to show it.
- **Retention that levels off**, which says the product holds.
- **A channel that repeats at a known cost**, which says growth is buyable.

A founder with none of those is not being offered a price based on their
company. They are being offered a price based on the stage, and the terms
matter more than the number.

## Instruments, in plain words

Stated once, without legal advice attached. Tell the founder plainly that this
is the shape of the thing, not a substitute for a lawyer reading their actual
paper.

- **Priced round** — the price is agreed now, shares are issued now, and the
  dilution is knowable today. The arithmetic above applies directly.
- **Convertible note** — a loan that becomes shares later, usually at the next
  round's price with a discount. The dilution is not knowable today, and that
  is the point to understand before signing.
- **SAFE** — similar in effect to a note without the loan mechanics. Two
  numbers decide almost everything: the **cap**, which sets the worst price the
  investor will pay, and the **discount**. A low cap on a round that goes well
  is where founders are most often surprised.

With a note or a SAFE, run the dilution table twice: once at the cap, once at
a plausible next-round price the founder names. Two scenarios the founder
chose, never a scenario invented here.

## Rules

- **Never produce a valuation figure**, including a range or a comparable
  presented as a benchmark. If the founder has no offer, `Price offered` stays
  `UNVERIFIED` and the dilution table stays empty.
- Every figure is the founder's own or `UNVERIFIED`. Show every division.
- Stacked rounds: always show founder share after a *second* round, because
  one round in isolation reads better than the path does.
- **Say once that a lawyer reads the actual document.** This file prepares the
  founder for that conversation; it does not replace it.
- Any traction claim that would appear in the raise materials needs score 3,
  per `phases/08-positioning-and-pitch.md`.
