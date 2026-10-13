# Phase 03 — Research

**Purpose:** Find out how this problem is solved today, and how big the thing actually is, without inventing a single number.
**Modules:** 03 business model, 01 problem discovery
**Entry condition:** Phase 02 done — the founder's stage is named.
**Pass gate:** Evidence score 1 to run light mode. Score 2 to run medium. Score 2 and a passed Problem stage to run heavy, which is the only mode that produces market sizing.
**Artifact:** `references/artifacts/market-research-brief.md`
**Next phase:** `phases/04-artifacts.md`

## The questions

Ask one question to confirm depth before running anything. Do not default to
heavy and do not silently assume.

> Want a quick scan of who else solves this, or should I go deeper?

Then run it with your web search and page-fetch tools — `WebSearch` and
`WebFetch` in Claude Code, `web_search` and `web_fetch` in the claude.ai app.

**Light** (the default): who else solves this today, 3 to 5 names including
the manual or do-nothing option; whether this is a known category, a shrinking
one, or not a category at all; a one-paragraph read on which industry this
actually belongs in.

**Medium:** everything in light, plus 3 to 5 competitors in depth — pricing
model, target customer, visible weakness; a two-axis positioning map showing
where the gap is; a buyer sketch built around the trigger event that makes
someone go looking.

**Heavy:** everything in medium, plus market sizing, an industry trend scan
with each development cited, and the writeup structured as a pyramid — the
one-sentence takeaway, then three or four supporting arguments, then the
evidence under each, then the detail.

Every figure carries a source URL or the marker `UNVERIFIED`. Favour primary
sources over aggregator blogspam. Paraphrase rather than reproducing text.

## When the gate is not met

**Medium at score 1, and any tier at score 0, inherit the contract rule.**
Light is earned at 1; medium is not. A founder at 1 asking for the positioning
map hears what is missing — a map drawn against a problem nobody confirmed is
decoration — and is offered the interview test instead, with the map produced
stamped if they insist. A founder at 0 has earned no tier at all: name the
conversations that are missing, offer three of them, stamp on insist. Do not
hand over light mode as the consolation tier. See section 6 of
`references/conversation-contract.md`.

**Heavy mode below the gate is refused.** Say why in one sentence: a market
size for an unvalidated problem is a number that makes the idea feel real
without making it more likely to work. Then offer the bottom-up count instead
— how many of this specific customer exist, times what the workaround already
costs them — with every input labelled.

Light mode is available at score 1 because knowing who else exists is cheap
and it changes the next question. Medium needs score 2 because a positioning
map against a problem nobody confirmed is decoration.

If no reliable public figure exists for something, say so rather than
reaching for one. "No credible public figure; here is a bottom-up estimate
with its assumptions" is a better answer than a cited guess.
