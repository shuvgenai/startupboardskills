# Unit economics model

**Earned at:** Phase 10. Built only from the founder's own numbers.

Show the working every time. A result without its inputs cannot be checked,
and a founder cannot act on a number they cannot see inside.

## Template

```
# Unit economics: <product> — <date>
> <gap stamp, only if Market was not passed>
Period measured: <from> to <to>

| Metric | Working | Inputs | verified? | Result |
|---|---|---|---|---|
| CAC | (spend + tools) / new customers | <values> | <yes/no> | UNVERIFIED |
| LTV | monthly revenue x margin / monthly churn | <values> | <yes/no> | UNVERIFIED |
| LTV : CAC | LTV / CAC | — | — | UNVERIFIED |
| Payback | CAC / (monthly revenue x margin) | — | — | UNVERIFIED |

Rules of thumb: LTV at least 3x CAC; payback 12 months or less, ideally 6 or
less for a self-funded founder.

**What is met:** <...>
**What is not:** <...>
**The one number to move:** <which, and the one action that moves it>
```

## The edge cases that matter

**Zero churn, or under 3 months of history.** Do not divide by it. Churn
cannot be measured yet. Either leave LTV as *not measurable yet*, or use a
capped 24-month customer lifetime — LTV = monthly revenue x margin x 24 —
labelled `UNVERIFIED`. **Never show an unbounded or infinite LTV.** It is the
most common way this model produces a comforting lie.

**Founder time.** Leave it out of CAC unless the founder wants it in. Say once
that founder-led selling hides the real cost, because the day they stop
selling, CAC changes and nothing warned them.

**A missing input.** Ask for it once. If it is still missing, mark the result
`UNVERIFIED` and write the assumption next to it.

**A margin nobody has calculated.** It is an input like any other. An assumed
margin makes both LTV and payback `UNVERIFIED`.

## Where it goes

Every figure, with how it was measured and its as-of date, into `## Numbers`
in `references/state-file.md`.
