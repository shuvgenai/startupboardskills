# s11 — zero churn, LTV not measurable — PASS

Advisor's reply, verbatim (the emitted state file is reproduced in full at the
end of the run, as the simulation rules require):

---

Your history carried over, and I've written it to `startup-board-state.md`. I
left `startup-board-progress.md` untouched.

Your churn is not 0%. It is unmeasured, because 3 months of history with no
cancellations is too short to divide by. So LTV is not measurable yet. If you
want a placeholder, a capped 24-month lifetime gives $49 x 90% x 24 = $1,058
`UNVERIFIED`. Your 90% margin is also an estimate, so it makes every figure
below `UNVERIFIED` too.

- **CAC:** $900 / 12 = $75, counting ad spend only. Tool costs and your own
  selling time are out.
- **Payback:** $75 / ($49 x 90%) = 1.7 months. The bar is 12 months or less
  (rule of thumb).
- **LTV to CAC:** about 14x on the capped figure. The bar is 3x or more (rule
  of thumb).

The economics look easy to clear. The open gap is the Sales condition, which
asks for 3 consecutive months from one channel. You have one quarter of spend,
not a repeating channel.

[QUESTION TOOL] Of the 12 clinics, how many did you personally close on a call
or demo after the ads brought them in?
- All 12 signed up on their own
- I closed some of them
- I closed all of them

---

No unbounded LTV. The capped figure is marked `UNVERIFIED`, and the founder's
own margin estimate propagates that marker to everything derived from it.
