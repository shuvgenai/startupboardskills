# Installing Startup Board Pro

There is nothing to run. This is a set of text files. No account, no API key,
no database, no subscription to anything.

Pick whichever route matches where you use Claude.

## Route 1 — the Claude app (easiest)

1. Open Claude and go to **Settings**.
2. Open **Capabilities**, then **Skills**.
3. Upload `startup-board-pro.zip` exactly as you downloaded it. Do not unzip
   it first.
4. Start a new conversation and type: *roast my startup idea*.

If the advisor replies with one question and no enthusiasm, it is working.

## Route 2 — Claude Code, as a folder

1. Unzip `startup-board-pro.zip`.
2. Move the unzipped folder to your skills directory, renaming it
   `startup-board-pro`:
   - **Windows:** `C:\Users\<your-name>\.claude\skills\startup-board-pro\`
   - **Mac or Linux:** `~/.claude/skills/startup-board-pro/`
3. Check that `SKILL.md` sits at the top level of that folder — not inside
   another folder within it. This is the one thing people get wrong.
4. Restart Claude Code and type: *roast my startup idea*.

## Route 3 — Claude Code, as a plugin (updates come to you)

This is the only route where you get updates without re-downloading anything.
It needs read access to the distribution repository, which you are granted at
purchase — if `gh auth status` shows you logged in to GitHub and you have been
added, both commands below just work.

```
/plugin marketplace add shuvgenai/startup-board-pro
/plugin install startup-board-pro
```

Later, when a new version ships:

```
/plugin update startup-board-pro
```

**The trade-off, plainly.** Routes 1 and 2 work in a minute and give you a
frozen copy — when a new version ships, you download and install again by
hand. Route 3 takes a few more minutes to set up and then updates with one
command.

## Checking it actually loaded

Type one of these and see whether you get a single question back:

- *roast my idea*
- *do I have product-market fit?*
- *should I keep going or quit?*

Three signs it is working:

1. You get **one** question, not a list.
2. Nobody tells you the idea is interesting.
3. If you ask for a pitch deck with no evidence behind you, you do not get one.

## Where your session is saved

After a session the advisor writes `startup-board-state.md` into your current
folder and tells you the path. Keep that file. Next session it picks up from
the one test you have not run.

In the Claude app it cannot see your files, so it hands the file to you and
asks you to paste it back next time.

**Coming from the free version?** Keep your `startup-board-progress.md`. Paste
it in or leave it in the folder, and your history carries across into the new
file. The old file is left exactly where it is.

## If something looks wrong

- **No response to the trigger phrases:** the skill did not load. On route 2,
  check `SKILL.md` is at the top of the folder.
- **It asks several questions at once:** you are probably talking to Claude
  without the skill loaded.
- **It compliments your idea:** same answer. This one is not supposed to do
  that.
