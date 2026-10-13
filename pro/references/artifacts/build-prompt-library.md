# Build prompt library

**Earned at:** Phase 06.

Five common MVP shapes. Each one is a prompt the founder pastes into Lovable,
Bolt or Replit as-is, then edits. Fill every angle-bracket placeholder from
the founder's actual venture before handing it over — a template returned
unfilled is not a deliverable.

Each prompt names a concrete data shape and a concrete first screen, and ends
with the payment step. Payments are always a Stripe hosted checkout link: no
payment code, no card handling.

## How to use these

1. Pick the shape that matches the core loop, not the ambition.
2. Fill the placeholders with the founder's real nouns — their customer, their
   object, their words.
3. Hand over the filled prompt and the one next step.
4. If none of the five fits, write a new prompt to the same pattern: the role,
   the one loop, the data shape, the first screen, what to leave out.

## Shape 1 — Two-sided marketplace

For connecting two groups where one lists and the other books or buys.

```
Build a web app where <provider type> list <what they offer> and
<customer type> book them.

Data shape:
- providers: id, name, email, photo, bio, city, is_published
- listings: id, provider_id, title, description, price, duration_minutes
- bookings: id, listing_id, customer_name, customer_email, date, time, status

First screen: a browsable list of published listings showing title, provider
name, city and price, with a filter by city. Clicking one opens a detail page
with a "Book this" button.

Booking flow: the customer enters name, email, and picks a date and time.
Save the booking with status "pending" and show a confirmation screen.

Provider side: a simple login, a form to create and edit listings, and a list
of their own bookings.

Leave out for now: ratings, messaging, search, cancellations, provider payouts.

Payment: on the booking confirmation screen, add a button linking to a Stripe
hosted checkout link I will paste in. Do not build any payment handling.
```

## Shape 2 — Scheduling or booking tool

For a single operator managing their own appointments and clients.

```
Build a scheduling app for a <operator type> who manages their own
appointments.

Data shape:
- clients: id, name, phone, email, address, notes
- appointments: id, client_id, date, start_time, duration_minutes, status, notes
- availability: id, weekday, start_time, end_time

First screen: this week as a day-by-day list, each appointment showing time,
client name and address. An obvious "Add appointment" button.

Add appointment: pick an existing client or create one inline, pick a date and
time, set duration. Warn me on screen if the new appointment overlaps an
existing one — do not block it, just warn.

Also needed: a client list with each client's upcoming and past appointments,
and a way to mark an appointment done or cancelled.

Leave out for now: client-facing self-booking, reminders, recurring
appointments, invoicing, multi-staff.

Payment: nothing in this version. I am charging the operator a subscription
through a Stripe hosted checkout link outside the app.
```

## Shape 3 — Content or AI generation tool

For producing something from an input, where the output is the value.

```
Build a web app where a user pastes in <input type> and gets back
<output type>.

Data shape:
- users: id, email, plan, generations_used_this_month
- generations: id, user_id, input_text, output_text, created_at

First screen: a large text area with the prompt "<the founder's own
instruction to the user>", a single button, and the result appearing
underneath. Keep every previous generation in a list on the side.

Generation: send the input to the Claude API with a system prompt I will
provide, and show the response. Show a visible loading state. If the API call
fails, say so in plain words and keep the input in the box so nothing is lost.

Limits: free users get 3 generations a month. When they hit the limit, replace
the button with an upgrade prompt.

Leave out for now: editing outputs, sharing, teams, file uploads, history
search.

Payment: the upgrade prompt links to a Stripe hosted checkout link I will
paste in. After payment I will set the user's plan manually for now.
```

## Shape 4 — Internal ops tracker

For records a person updates through the day. Often better built on Airtable
with Softr or Glide over the top — if the founder would rather edit a table
directly than use an app, use that route instead and skip this prompt.

```
Build an app for tracking <the thing being tracked> through its stages.

Data shape:
- items: id, title, <the founder's own fields>, stage, owner, updated_at
- notes: id, item_id, body, created_at

Stages: <the founder's real stages, in order>

First screen: columns, one per stage, with each item as a card showing title
and owner. Dragging a card to another column changes its stage and updates
updated_at.

Item detail: all fields editable, plus a running list of notes with the newest
first.

Also needed: a filter by owner, and a visible count per column.

Leave out for now: permissions, assignment notifications, reporting, bulk
edits, attachments.

Payment: none. This is internal.
```

## Shape 5 — Subscription content product

For paid access to something that updates over time.

```
Build a site where paying members read <content type> and non-members see
only previews.

Data shape:
- members: id, email, status, joined_at
- posts: id, title, slug, preview_text, body, published_at, is_members_only

First screen: posts newest first, each showing title, date and preview text.
A members-only post shows its preview and then a locked panel instead of the
body.

Access: members log in with an email link. A logged-in member with status
"active" sees full bodies. Everyone else sees previews.

Author side: a simple form to write and publish a post, with a toggle for
members-only.

Leave out for now: comments, tiers, search, email sending, archives.

Payment: the locked panel links to a Stripe hosted checkout link I will paste
in. After payment I will set the member's status to active manually for now.
```

## Sequencing, whichever shape

1. Data shape and accounts first. Nothing else works without them.
2. The core loop, as one screen. Not the whole app.
3. The generation or integration step, if the product needs one.
4. Payment last — a hosted checkout link, once there is something worth
   paying for.
5. Put it in front of the people already interviewed before building anything
   beyond the core loop.
