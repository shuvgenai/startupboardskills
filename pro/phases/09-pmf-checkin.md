# Phase 09 — Product-market fit check-in

**Purpose:** Give an honest verdict on fit, built only from numbers the founder measured.
**Modules:** 04 product-market fit, 06 metrics, 05 product management
**Entry condition:** A live product with real users. **Zero active users means this phase does not run.**
**Pass gate:** 30 or more active-user responses for a non-directional read, 40% or more very disappointed (both rules of thumb), retention that levels off above zero, and pull present or growing. Never Yes while 1 signal is unmeasured.
**Artifact:** `references/artifacts/pmf-survey.md`, `references/artifacts/pmf-scorecard.md`
**Next phase:** `phases/10-scale.md` on Yes or In one segment

## The refusal

**Zero active users: do not run this phase.** It is the only hard refusal in
the product.

Say it plainly: fit is measured from how real users behave, so there is
nothing here to measure yet. A **waitlist is not usage**. Signups are not
usage. Then return the founder to their real stage — usually Product — and
give one action.

Do not soften this into a partial reading. There is no partial reading
available.

## Step 1 — define an active user

Ask what counts as an active user for this product, and how often a real one
would use it: daily, weekly or monthly. Every later number uses that
definition. Without it, every figure is ambiguous.

## Step 2 — three signals, one question each

**The very-disappointed survey.** Asked of active users only: how would you
feel if you could no longer use this — very disappointed, somewhat
disappointed, or not disappointed? About **40%** or more very disappointed,
from about **30** or more responses, is the bar (rules of thumb). Under about
30 responses the result is **directional**, not proof — say so, and suggest
surveying more. Ask for a split by customer type.

**Retention.** For users who started in the same week or month, what share is
still active at later points. Healthy means the curve **levels off above
zero**. A curve still sliding toward zero is the finding. Judge the shape; do
not invent a target percentage.

**Pull.** What share of last period's new users arrived without the founder
pushing, and is that share growing? If it charges money: are people paying and
renewing?

## Numbers that cannot all be true

If the figures conflict — percentages summing past 100, more responses than
active users, a cohort that grows over time — say exactly what
**does not add up**, and ask one question before using any of them.

Never repair the numbers yourself. A founder whose figures were quietly
corrected gets a verdict built on something they never said.

## Missing signals: the measurement kit

Never estimate a missing signal. Hand over what is needed to measure it and
ask the founder to come back with the result.

**The kit is not a to-do list.** Several signals can be missing at once, and
the kit may well contain a survey and a retention table. The reply still names
exactly **one** action — the one that unblocks the most, usually whichever
signal is closest to a verdict — and attaches the rest of the kit as material
for when they get to it.

Never write "two things to do" or number the actions. A founder handed three
jobs does none of them. Name the one, hand over the instruments, and say the
others can wait until the first comes back.

**The survey.** The question above, plus: what type of person do you think
would benefit most from this; what is the main benefit you get; how could we
improve it for you. Active users only.

**The retention table.** One row per start week or month:

| Start week | Users who started | Active week 1 | Active week 4 | Active week 8 |
|---|---|---|---|---|

**Where the numbers live.** Sign-up and last-active dates in the app's own
records or login tool. Payments and cancellations in the payment tool. For
pull, a "how did you hear about us" question at sign-up.

## Step 3 — the segment check

If the founder gave results by customer type, compare each against the bar. A
segment at or above the bar with about 30 or more responses, while the overall
figure is below, earns **In one segment**. A segment above the bar with fewer
responses can still earn it, labelled directional, with a suggestion to survey
more of that segment.

## Step 4 — the verdict

| Verdict | When | One next action |
|---|---|---|
| Not yet | Below the bar overall and in every segment, or retention still sliding toward zero | The single product change most likely to win over the somewhat-disappointed users, based on what the very-disappointed ones say the main benefit is |
| In one segment | A segment meets the bar and its retention is not collapsing | Point product, messaging and outreach at that segment only |
| Yes | Bar met overall, retention levels off, pull present or growing | Offer `phases/10-scale.md` |

**Never give Yes while a signal is unmeasured.** Say the signals so far look
promising, name the missing one, hand over the kit.

## When the gate is not met

Say which signal is short and by how much, using the founder's own numbers.
Then one action.

Save `references/artifacts/pmf-scorecard.md` and append dated rows to
`references/state-file.md`. If a previous check-in exists, state the trend in
one line. Mark Market as passed only on Yes — or for that segment only, on In
one segment.
