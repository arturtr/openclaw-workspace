# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Workspace Is

Two things in one place:

1. **Personal AI system** — markdown-based knowledge base and memory for AI agents (Kuzya, Ember)
2. **OpenClaw platform** — the software that runs those agents (source at `/home/artur/projects/openclaw`)

---

## OpenClaw Platform (source code)

**Stack:** TypeScript, Node.js ≥24, pnpm workspaces

**Runtime:** Node 24 + pnpm managed via mise (`~/.config/mise/config.toml`). After Node changes: `openclaw daemon install --force` to update systemd unit. Node <24 gives `fts unavailable: no such module: fts5` in memory status.

**Build:**
```bash
cd /home/artur/projects/openclaw
pnpm install
pnpm build          # TypeScript → ESM dist/ + React UI
pnpm gateway:watch  # Dev mode with auto-reload
```

**Test:**
```bash
pnpm test              # Unit tests (vitest)
pnpm test:e2e          # E2E tests (gateway + channel mocking)
# Live model tests require real API keys:
pnpm test:live
```

**Architecture layers:**

| Layer | Directory | Role |
|-------|-----------|------|
| CLI | `src/cli/`, `src/commands/` | Commands: gateway, agent, onboard, daemon, doctor |
| Gateway | `src/gateway/` | WebSocket control plane — routes messages between channels and agents |
| Agent runtime | `src/agents/` | Spawns Pi subprocess per session, streams tool calls and responses |
| Channels | `src/channels/`, `extensions/` | Telegram, WhatsApp, Discord, Slack, Signal, iMessage, Matrix, etc. |
| Tools | `src/browser/`, `src/canvas-host/` | Browser (CDP), Canvas (A2UI), Nodes (device actions), Cron |
| Memory | `src/memory/` | SQLite vector DB per agent (`~/.openclaw/memory/*.sqlite`) |
| Plugin SDK | `src/plugin-sdk/`, `extensions/` | ~35 channel plugins, swappable memory backends |
| Web UI | `ui/` | React + Vite dashboard, WebChat, Canvas renderer |

**Request flow:** Channel inbound → Gateway routes by binding → Agent spawns Pi → Pi calls model → streams back → Gateway → Channel outbound

**Config:** `~/.openclaw/openclaw.json` (Zod-validated). Agents defined under `agents.list`; channel routing under `bindings`; tool deny-list under `tools.deny`.

**Agents in this installation:**
- `kuzya` (default) — Artur, family, home
- `ember-yulia` — Yulia's coaching and business
- `kuzya-efrem` — Efrem sessions
- `kuzya-masha` — Masha sessions (book cataloging)

**Daemon:**
```bash
openclaw daemon install   # systemd (Linux) or launchd (macOS)
openclaw gateway          # foreground
```

---

## Agent System (this workspace)

### Startup

Read the agent file before anything else:
- `agents/kuzya.md` — sessions with Artur (family/home/daily life)
- `agents/ember.md` — sessions as Ember with Yulia (agent=ember-yulia)

Auto-loaded each session: `SOUL.md`, `IDENTITY.md`, `MEMORY.md`, `AGENTS.md`.

> **Note:** CLAUDE.md is only read by Claude Code sessions — agents do NOT see it.
> Agent instructions go in `MEMORY.md`, `agents/kuzya.md`, `agents/ember.md`.

**Утренняя сводка (cron 6:15)** reads: ARTUR.md, FAMILY.md, memory/YYYY-MM-DD (today+yesterday), *-DEVELOPMENT.md, DATACAMP.md, KANBAN.md, BJJ.md.
If no recent daily note exists — falls back to the latest available file in memory/.

### Memory System

Files are the only continuity between sessions. Mental notes don't survive restarts.

**Daily notes:**
- `memory/YYYY-MM-DD.md` — Kuzya (основной агент)
- `memory/YYYY-MM-DD-ember.md` — Ember (agent=ember-yulia)
- `memory/YYYY-MM-DD-efrem.md` — Kuzya-Efrem (agent=kuzya-efrem)
- `memory/YYYY-MM-DD-masha.md` — Kuzya-Masha (agent=kuzya-masha)
- Read today + yesterday on startup. Never write to another agent's file.

**Thematic memory** (load by context):

| File | Topic |
|------|-------|
| `memory/family.md` | Family dates, relationships |
| `memory/yulia-profile.md` | Yulia's mission, preferences, schedule |
| `memory/kids.md` | Children: tokens, school, rituals |
| `memory/tea.md` | Tea brand (Чай•fm) |
| `memory/tech.md` | Telegram IDs, bots |
| `memory/my-career.md` | Yulia's career map (natal chart) |
| `memory/chinese-vocab.md` | Chinese characters (tea, ТКМ, Ба Цзы) — add new ones here |

**Memory rules:**
- User explains something with effort → write to thematic file immediately, not just daily note
- "Запомни навсегда" → thematic file only (not daily note)
- Every file change → git commit
- New file → update workspace map in `MEMORY.md`
- **Double-write rule**: creating a file in a subdirectory (e.g., `tea/clients/`) requires updating the corresponding thematic summary (e.g., `memory/tea.md`) in the same session — Kuzya reads summaries, not subdirectories

### Git Conventions

- Commit after every meaningful change
- Messages in Russian, information-first: verb + what changed
- Max 50 chars, no period
- Example: `22.02: правила общения с Юлей — что помнить Эмбер`

### Python Scripts

Content generation for homodivinus.ru:
```bash
python3 homodivinus/create_docx.py        # markdown → .docx
python3 homodivinus/build_final_docx.py   # .docx with articles + social cards
```

Requires `python-docx`. Use `uv run --with python-docx python3 script.py` if not installed.

### Safety Rules

- `trash` over `rm`
- Ask before: emails, public posts, anything leaving the machine
- Read freely: files, web, workspace exploration
- Never share private data from this workspace externally

---

## Operations & Debugging

### Config & Secrets

`~/.openclaw/openclaw.json` — Zod-validated, `.strict()`. Auth profiles only allow `provider`, `mode`, `email`. **No token fields.**

API keys live in `~/.openclaw/.env` as `PROVIDER_API_KEY`:
```
ANTHROPIC_API_KEY=...
OPENAI_API_KEY=...
GROQ_API_KEY=...        # audio transcription via whisper-large-v3-turbo
```

After editing either file: `systemctl --user restart openclaw-gateway`

Edit config safely: use `Edit` tool for targeted changes; use `python3 json.load/dump` only when structural changes (key rename, array item removal) make string replacement impractical.

**Current models (as of 2026.2.25):** opus-4-6 (primary), sonnet-4-6 (fallback#1), haiku-4-5 (fallback#2). kuzya-efrem and kuzya-masha have per-agent model overrides in `agents.list` — update those separately when upgrading models.

Update openclaw: `openclaw update` (run from any directory)

Check active models: `openclaw models list`

**Changelog after update:**
```bash
cd /home/artur/projects/openclaw
git log --oneline v2026.X.XX..v2026.Y.YY   # commits between versions
# or read CHANGELOG.md directly
```

### Diagnosing Failures

| What to check | Where |
|---------------|-------|
| Gateway logs (live) | `systemctl --user status openclaw-gateway` |
| Session history | `~/.openclaw/agents/*/sessions/*.jsonl` |
| Cron run results | `~/.openclaw/cron/runs/*.jsonl` |
| Stuck outbound messages | `~/.openclaw/delivery-queue/` |
| Cron job definitions | `~/.openclaw/cron/jobs.json` |

**Common failures:**
- `sendMessage failed: Network request failed` — transient Telegram API blip. Message was generated but not delivered. Check latest session `.jsonl`, extract assistant response, resend via Telegram Bot API.
- `All models failed: rate_limit` in cron runs — Anthropic rate limit cascade. All three fallbacks (opus/sonnet/haiku) share one account and all enter cooldown together. Concurrent cron tasks at 20:00/21:00 can trigger this.
  Cooldown: 1m → 5m → 25m → 60m (exponential). State: `~/.openclaw/agents/kuzya/auth-profiles.json`. To clear: delete `usageStats` fields or use `openclaw models status`. Since 2026.2.25: same-provider fallbacks are tried despite cooldown when reason=rate_limit.
- `cron announce delivery failed` — gateway couldn't send the job completion notification. Check `delivery-queue/` for stuck entries.
- `sendMessage failed` repeated — check VPN: `ip route | grep tun0`. If tun0 has metric 50, it routes all traffic. Unstable VPN = Telegram down.

### Resending a Stuck Message

```python
import json, urllib.request, urllib.parse
cfg = json.load(open('/home/artur/.openclaw/openclaw.json'))
token = cfg['channels']['telegram']['accounts']['kuzya']['botToken']
data = urllib.parse.urlencode({'chat_id': '1072324', 'text': '...', 'parse_mode': 'Markdown'}).encode()
urllib.request.urlopen(urllib.request.Request(f'https://api.telegram.org/bot{token}/sendMessage', data=data))
```

### Audio Transcription

Uses Groq (`whisper-large-v3-turbo`) via `GROQ_API_KEY`. Auto-detected — no config needed beyond the env var.

`faster-whisper` is installed as a Python library in `~/.openclaw/tools/` but openclaw needs a `whisper` CLI binary — the library alone is not used.

### Key Source Files (openclaw internals)

| File | What it controls |
|------|-----------------|
| `src/agents/model-fallback.ts` | Fallback chain logic, cooldown decisions |
| `src/agents/auth-profiles/usage.ts` | Cooldown calculation (formula: `5^n` min, max 1h) |
| `src/infra/heartbeat-runner.ts` | Heartbeat scheduler + delivery |
| `src/auto-reply/heartbeat.ts` | Default prompt, HEARTBEAT_OK token stripping |
| `src/agents/failover-error.ts` | Error classification (rate_limit, auth, billing…) |

### Key Files

| File | Purpose |
|------|---------|
| `SOUL.md` | Core AI principles |
| `IDENTITY.md` | Kuzya's persona |
| `FAMILY.md` | Family structure, values, routines |
| `ARTUR.md`, `YULIA.md` | Primary user profiles |
| `KANBAN.md` | Active project board |
| `HEARTBEAT.md` | Cron tasks / scheduled reminders |

### Finance & Contracts

`finance/mellow/` — Mellow (FRWD Limited, HK) subcontractor relationship.

- `agreement_template.pdf` — текущий шаблон договора (21 стр.)
- `agreement-notes.md` — анализ ключевых условий + история изменений (блок `## vX.X` при каждом обновлении)
