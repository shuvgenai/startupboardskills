# Phase 06 — MVP blueprint

**Purpose:** Turn a validated problem into the smallest thing that delivers the value, with a copy-paste prompt for every step.
**Modules:** 05 product management, 03 business model, 02 customer development
**Entry condition:** Problem stage passed. A founder below it who insists after hearing the gap gets the stamped version, never the unstamped one.
**Pass gate:** Problem stage passed, which needs 10 interviews at score 2 (rule of thumb). Below that, the blueprint still ships but carries the gap stamp and the gap is stated in numbers first.
**Artifact:** `references/artifacts/build-prompt-library.md`
**Next phase:** `phases/07-launch.md`

## The questions

One question to confirm scope before generating anything.

> Which single thing does someone have to be able to do for this to be worth
> using?

That answer is the core loop. Everything else is deferred, in writing, so it
is remembered rather than smuggled in.

## The stack

Chosen so a founder who does not write code can ship. Tiered by how little
technical work is required, not by what is most impressive.

| Tier | When | What |
|---|---|---|
| 0 | Proving the core loop before committing to any platform | A single Claude Artifact the founder shares as a link. No signup, no hosting, no cost. |
| 1 | Default. Anything with a real interactive loop | Lovable, Bolt or Replit. The founder describes the app in words; the tool handles data, accounts and hosting invisibly. |
| 2 | Records an operator edits directly — bookings, inventory, applications | Airtable as the data layer, Softr or Glide as the interface. |

Payments at every tier: a Stripe hosted checkout link. No payment code, no
card handling.

Any generation or reasoning feature: the Claude API, called from whatever tier
1 or 2 tool is in use.

**Graduation.** If the founder's stated requirement genuinely exceeds tier 1 or
2 — real multi-user permissions, regulated data, heavy volume — say in one
line that they will outgrow no-code and will need a developer for that piece.
No setup instructions, no tooling tour. One line, then back to shipping.

## The scope cut

1. List every feature the founder mentioned.
2. Mark each: **core loop**, **nice-to-have**, or **later**.
3. The MVP ships the core loop only.
4. Write the deferred list into `## Open loops` so nothing is lost.
5. Check the core loop against the value proposition. If the cut no longer
   delivers it, the cut went too far.

## When the gate is not met

The gate is never waived silently. It is not a refusal either: it is an order
of operations, and the stamp is the trace.

1. Say the gap in numbers first: "You have 4 interviews at score 2; Problem
   asks for about 10 (rule of thumb)."
2. Name the one action that closes it.
3. Then, if they still want the blueprint, produce it with this line at the
   very top of the output:

   `> Built before Problem was passed. Missing: 6 more interviews at score 2.`

The stamp is not a formality. It is what the founder sees in three months when
they are wondering why the build did not land.
