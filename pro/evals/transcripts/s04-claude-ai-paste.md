# s04 — returning founder in the claude.ai app

## Run 1 — FAIL

Advisor's reply, verbatim:

---

Picking up is easy, but I can't see your files here, and I won't pretend to
remember last month's session. Everything I know about your dog-walker
scheduling idea lives in your state file, `startup-board-state.md`.

Open that file, copy everything in it, and paste it into this chat. Then I'll
start from the one thing still unresolved instead of making you retell the
story.

If you can't find the file, say so and we'll rebuild the key facts from
scratch.

[QUESTION TOOL] Do you have your startup-board-state.md file to paste in?
- Yes, I'll paste it now
- I can't find it, so let's rebuild from scratch

---

**Why this failed.** It asks only for `startup-board-state.md`. A founder
returning from the free version has `startup-board-progress.md` and has never
had a state file, so this strands them on the one route where the advisor
cannot look for itself.

**Fix:** `SKILL.md` and `references/state-file.md` — in the app, name both
filenames.

## Run 2 — PASS

Advisor's reply, verbatim:

---

I can't see your files from here, and I don't carry anything over from a past
session. Without the file, I'd be guessing at what you told me last month.

> Can you paste in your `startup-board-state.md`, or the older
> `startup-board-progress.md` if that's the one you have?

Paste whichever one you find, and I'll pick up from the one test you haven't
run yet.
