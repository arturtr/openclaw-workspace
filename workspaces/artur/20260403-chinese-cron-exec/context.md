# Current Session Context

**Last Updated**: 2026-04-03 00:30 UTC

**Current Task**: Fix cron delivery, exec approvals, delivery routing

**Status**: Complete

---

## Session Summary

Continued from 20260402-chinese-learning-reorg. Fixed exec approvals (two-level config discovery), fixed cron delivery routing (agent=bot pairing), audited all cron jobs.

### Work Completed

- **Exec approvals root cause found:** `minSecurity(openclaw_config, exec_approvals)` picks stricter. `openclaw.json` defaults to `"allowlist"` — caps exec-approvals `"full"` back to `"allowlist"`. Source: `dist/pi-embedded-BOszYfjF.js:5504`
- **Fix:** added `tools.exec.security: "full"` to `~/.openclaw/openclaw.json` + `agents["*"].security: "full"` in `~/.openclaw/exec-approvals.json`
- **Wildcard agent `"*"`:** found in source (`exec-approvals-DVqmcC44.js:289`) — undocumented, covers all agents without per-agent entries
- **Removed git -C workarounds** from [kuzya.md](agents/kuzya.md) and [ember.md](agents/ember.md) — no longer needed with `security: "full"`
- **Cron delivery audit:** found "Маша — урок" (`c84ef020`) delivered to Artur instead of Yulia. Fixed `--to 364539550`
- **Agent=bot pairing rule:** kuzya agent → kuzya bot, ember-yulia → ember bot. Fixed "Маша" and "Суббота домоведение" (`367fa0be`) from account=ember to account=kuzya
- **Documented in CLAUDE.md:** exec approvals two-level config section
- **Memory saved:** `reference_exec_approvals.md`, `feedback_post_update_checklist.md`, `feedback_cron_delivery_routing.md`

### Key Findings

**Exec approvals two-level system:**
- `openclaw.json → tools.exec.security` = ceiling (default: `"allowlist"`)
- `exec-approvals.json → agents.*.security` = per-agent (wildcard `"*"` supported)
- `minSecurity()` picks stricter of the two
- Both must be `"full"` for unrestricted exec

**Agent = bot, always:**
- kuzya agent → kuzya bot account
- ember-yulia agent → ember bot account
- Never cross, even if recipient is the same person

**Session caching:**
- Exec policy loads at session start. Config changes require `/reset` or new session
- Gateway restart alone not sufficient for live sessions

### Open TODOs

- [ ] 4 weekly crons still show "error" from last week — will self-heal on next run (Wed/Sun)
- [ ] Monitor 而 (ér) delivery tomorrow morning (first post-fix Chinese cron)
- [ ] Ногти crons have `account: "?"` — no accountId set, using default. Not broken but worth standardizing

---

## Next Steps

1. Monitor crons over next 2-3 days — all should show "ok"
2. If new openclaw update drops — run post-update checklist (see `feedback_post_update_checklist.md`)

## Key Links

- `~/.openclaw/openclaw.json` — `tools.exec.security: "full"`
- `~/.openclaw/exec-approvals.json` — `agents["*"].security: "full"`
- [CLAUDE.md exec section](CLAUDE.md) — documented for future reference
- Previous session: `workspaces/artur/20260402-chinese-learning-reorg/context.md`
- Memory: `reference_exec_approvals.md`, `feedback_post_update_checklist.md`, `feedback_cron_delivery_routing.md`
