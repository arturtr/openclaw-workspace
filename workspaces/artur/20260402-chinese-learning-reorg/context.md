# Current Session Context

**Last Updated**: 2026-04-02 14:40 UTC

**Current Task**: Reorganize Chinese character learning system + fix broken cron delivery

**Status**: Complete

---

## Session Summary

Reorganized 3 overlapping Chinese learning files into clean 3-file architecture with SRS, added best practices (phonetic series, confusable pairs, etymology, tone colors, contextual sentences, evening recall). Fixed delivery for 9 cron jobs broken after openclaw update.

### Work Completed

- **3-file architecture**: [chinese-daily.md](memory/chinese-daily.md) (single source of truth), [chinese-srs.md](memory/chinese-srs.md) (new, SRS intervals), [chinese-vocab.md](memory/chinese-vocab.md) (reference + phonetic series + confusable pairs)
- **43 base primitives**: expanded from 19 to 43 (added numbers 1-10, structural radicals). All must be learned before compound characters
- **SRS system**: 5 levels (1d, 3d, 7d, 14d, 30d), 23 characters seeded from journal
- **Card format**: tone emoji (1st=red, 2nd=orange, 3rd=green, 4th=blue), etymology (oracle bone -> modern), contextual sentences from learned chars only, phonetic series, English translation
- **Evening recall cron** (`a7da85ee`): 21:00 Vlad, asks "what character was today?" without showing answer
- **Weekly assignments**: Monday mornings, "find X on tea package"
- **Rollback to 十 (03-26)**: removed 心寸而又女 from journal/SRS (not delivered due to broken cron)
- **9 cron jobs fixed**: all had `Outbound not configured for channel: telegram` after openclaw 2026.3.24->2026.3.31 update. Fixed via `--announce --channel telegram --to <chatId> --account <account>`
- **Timeout increased**: Pinterest (600s), Morning summary (600s), Chinese morning (300s)
- **[kuzya.md](agents/kuzya.md)**: added Chinese system docs, critical rules, error handling protocol
- **[MEMORY.md](MEMORY.md)**: updated index (removed chinese-curriculum, added chinese-daily + chinese-srs)
- Archived: `memory/chinese-curriculum.md`, `memory/2026-03-14-chinese-vocab.md` -> `memory/archive/`

### Key Findings

**Cron delivery broke silently after openclaw update**:
- `openclaw cron edit --message` updates prompt only, NOT delivery config
- Direct JSON editing of `jobs.json` failed: structure changed from array to `{version, jobs}` dict
- Fix: use CLI flags `--announce --channel telegram --to <chatId> --account <accountId>`
- Affected ALL announce-mode crons, not just Chinese ones

**Strict component rule matters**:
- User explicitly requested: never send compound character before ALL components are in journal
- "Known from context" != "formally learned" -- Kuzya made this error 3+ times
- Contextual sentences must use only learned characters; unknown words -> pinyin only

**Numbers 1-10 are essential primitives**:
- Appear throughout vocabulary (四柱, 五行, 六壬, 七杀, 八卦, 九宫)
- Simple enough to batch 2-3 per day with full cards

### Open TODOs

- [ ] Verify tomorrow's morning cron delivers successfully with new format
- [ ] Verify evening recall cron delivers at 21:00
- [ ] Some SRS entries (口目水明春) are heavily overdue -- cron should prioritize them
- [ ] Phonetic series in vocab.md are initial set -- expand as vocabulary grows
- [ ] Confusable pairs -- add more as user makes mistakes

---

## Next Steps

1. Monitor morning cron (07:00 Vlad, Apr 3) -- should send 心 + SRS block
2. Monitor evening recall (21:00 Vlad, Apr 2) -- first run tonight
3. If delivery fails again, check `journalctl --user -u openclaw-gateway`

## Key Links

- [chinese-daily.md](memory/chinese-daily.md) -- main working file (rules, levels, journal)
- [chinese-srs.md](memory/chinese-srs.md) -- SRS intervals table
- [chinese-vocab.md](memory/chinese-vocab.md) -- reference dictionary + phonetic series + confusable pairs
- [kuzya.md](agents/kuzya.md) -- agent instructions (Chinese section updated)
- Morning cron: `862d86b6-17f0-4cfc-a2a7-6b90a6167d2c`
- Recall cron: `a7da85ee-93c3-48f3-a0d5-22e9d769452f`
- Plan: `.claude/plans/abundant-pondering-moler.md`
