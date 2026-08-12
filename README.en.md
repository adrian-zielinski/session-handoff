<!-- markdownlint-disable MD033 -->
<h1 align="center">Session Handoff</h1>

<p align="center">
  <b>Topic-based memory between Claude Code sessions.</b><br>
  End a session halfway through a task, open a fresh one tomorrow, start at full speed.
</p>

<p align="center">
  <a href="README.md">🇵🇱 Polski</a> · 🇬🇧 <b>English</b>
</p>

---

## The problem

A Claude Code session dies with its context. You open a new one and re-explain everything: what got done, which decisions were made, why one approach was dropped.

Auto-`/compact` does not save you. It fires when the context window is already full and the model has gone dull, and it summarizes summaries. What survives is a digest of the last session, not the knowledge gathered across ten.

## The fix

Context lives in a `HANDOFF/` folder at the project root. **One `.md` file per topic**, plus an `INDEX.md` listing them.

```
HANDOFF/
  INDEX.md          # topic index, always read first
  elevenlabs.md     # one topic = one file
  followups.md
  onboarding.md
```

When you wrap up, you run `/handoff`. The session appends its contribution to the **right topic file**, not to yet another per-session log. Next time you run `/pickup`, and the new session reads the index plus one topic file, picking up compressed knowledge from many previous sessions at once.

A topic file is a living document, not a log. On save the session updates sections, deletes what went stale, and adds one line to the journal. Decisions with their reasoning survive longest, because that is the actual know-how.

## Install

### Option A: plugin (recommended)

Inside a Claude Code session:

```
/plugin marketplace add adrian-zielinski/session-handoff
```

```
/plugin install session-handoff@session-handoff
```

Pull a newer version whenever one ships:

```
/plugin update session-handoff
```

### Option B: install script

Copies the skill and commands into `~/.claude/`, making them available in every project:

```bash
git clone https://github.com/adrian-zielinski/session-handoff.git && cd session-handoff && ./install.sh
```

Update later with `git pull && ./install.sh`.

### Option C: by hand

```
skills/session-handoff/SKILL.md  →  ~/.claude/skills/session-handoff/SKILL.md
commands/handoff.md              →  ~/.claude/commands/handoff.md
commands/pickup.md               →  ~/.claude/commands/pickup.md
```

Use a project-local `.claude/` instead of `~/.claude/` if you want it scoped to one repo.

## Usage

| Command | What it does |
|---|---|
| `/handoff` | Saves the session context to a topic file, picking the topic from what you worked on. |
| `/handoff elevenlabs` | Same, but you name the topic. Your choice beats auto-matching. |
| `/pickup` | Lists topics with statuses and asks which one to resume. |
| `/pickup followups` | Resumes a specific topic right away. |

Plain sentences work too: "save a handoff", "resume the follow-ups topic", "zapisz sesję". The skill triggers in English and Polish.

**When to save:** around 50-60% context usage, when you close a thread, or before switching topics. Not at 90%, when the model has already gone dull, and never in the middle of a working implementation.

After `/pickup` you get the topic's files as clickable links, then three lines: where we are, next step, what to avoid. The session waits for your confirmation before moving.

## Topic file format

```markdown
---
kind: handoff-topic
topic: elevenlabs
status: in-progress
updated: 2026-08-12
---

# AI voice notes generated with ElevenLabs

> Scope: TTS, IVC/PVC clones, cost per voice note.
> NOT covered: human-recorded voice notes (→ voice-notes-manual.md)

## Current state
- ✅ API integration live in production
- 🔄 picking a voice that handles the accent
- ⛔ PVC clone blocked on 30 min of client recordings

## Key decisions
- IVC over PVC to start, because PVC needs 30 min of material and IVC needs 1 min

## Next step
Compare two voices on the same 5 sentences and pick one.

## What NOT to do
Do not revisit local synthesis. Tested, quality unacceptable.

## Artifacts
- `docs/voice-analysis.md` — 4 vendors compared, with pricing
- branch `feat/voice-tts`, commit `a1b2c3d`

## Session journal
- 2026-08-12 — API wired up, first 3 voice notes in production
- 2026-08-07 — vendor research, ElevenLabs picked
```

A topic file should stay near 150 lines. Once it swells, the session condenses the oldest entries and details that stopped mattering.

Ready-made examples: [examples/INDEX.md](examples/INDEX.md) and [examples/elevenlabs.md](examples/elevenlabs.md).

## The rules that keep it honest

**Index first.** In both modes the first action is reading `HANDOFF/INDEX.md`. It is what tells the session which topics exist and how they differ.

**Fewer files win.** The session hunts for a matching topic before creating one. It judges by the mechanism of the work, not the session title: "fix the voice notes" lands in `elevenlabs` even though nobody said the word ElevenLabs.

**Knowledge accumulates, it does not get overwritten.** The session reads the whole file and edits incrementally. Older findings that still hold stay put.

**Handoff holds task state, not permanent facts.** When a lasting preference or design decision comes up, the skill offers to store it in project memory instead.

## Where it fits

Any project you touch across more than one session: code, research, writing, docs. Commit the `HANDOFF/` folder with the project and every machine and teammate sees it.

## What you are installing

```
skills/session-handoff/SKILL.md   # all the logic: structure, topic matching, SAVE and RESUME modes
commands/handoff.md               # /handoff
commands/pickup.md                # /pickup
```

Three markdown files, no dependencies, no executable code.

## FAQ

**How is this different from `CLAUDE.md`?**
`CLAUDE.md` holds rules that always apply and load into every session. A handoff holds the state of one work thread and loads only when you pick that thread up.

**How is this different from `/compact`?**
`/compact` rescues a single session from a full context window. Handoff carries knowledge across sessions and compounds it over time.

**I have old per-session handoffs in `session-logs/`.**
The skill absorbs them. On the first `/handoff` for a matching topic it pulls the essence of the old file into the topic file and works only from `HANDOFF/` afterwards.

**The skill file is written in Polish.**
The instructions target the model, and Claude follows them regardless of the language you chat in. Your topic files come out in your language. A translation is welcome as a PR.

## License

MIT. Do what you want with it.
