# Current Session Context

**Last Updated**: 2026-03-05 09:25 UTC

**Current Task**: Диагностика и починка Telegram (Кузя не отвечал)

**Status**: Complete

---

## Session Summary

Кузя перестал отвечать после обновления openclaw (2026.3.x, 2177 коммитов). Причина — новое security-правило в `bot-message-context.ts`: named Telegram account без явного binding теперь отклоняет все сообщения (fail closed). Добавили binding + попутно исправили несколько конфигурационных проблем.

### Work Completed

- **Корень проблемы**: [src/telegram/bot-message-context.ts:214](file:///home/artur/projects/openclaw/src/telegram/bot-message-context.ts#L214) — новый guard `route.accountId !== DEFAULT_ACCOUNT_ID && route.matchedBy === "default"` → `return null`
- **Фикс**: добавлен explicit binding в `~/.openclaw/openclaw.json`:
  ```json
  { "agentId": "kuzya", "match": { "channel": "telegram", "accountId": "kuzya" } }
  ```
- **defaultAccount**: добавлен `channels.telegram.defaultAccount: "kuzya"` → убрал "Telegram: not configured" в doctor
- **groupPolicy**: откатили с `"open"` обратно на `"allowlist"` (2 CRITICAL security audit issues)
- **Haiku fallback**: убран из всех агентов (`agents.defaults.model.fallbacks`, `kuzya-efrem`, `kuzya-masha`)
- **IPv6 delay**: добавлен `channels.telegram.network: { autoSelectFamily: false, dnsResultOrder: "ipv4first" }` — убрал 30-60с задержку старта
- **Debug logging**: включён через `~/.config/systemd/user/openclaw-gateway.service.d/debug.conf` (`OPENCLAW_LOG_LEVEL=debug`)

### Key Findings

**Новое security-правило (breaking change в обновлении)**:
- Named Telegram accounts (не `"default"`) без explicit binding → сообщения молча дропаются
- Проявляется как: update_id растёт, offset файл обновляется, но агент не запускается
- Диагностировано через `raw-update` subsystem logger в `/tmp/openclaw/openclaw-2026-03-05.log`
- Строка-виновник: `bot-message-context.ts:214`

**Streaming**: везде явно `"off"` — новый дефолт `"partial"` не влияет.

**Bindings в openclaw**: `resolveAgentRoute` кэширует по WeakMap на объект config, но `bot-message-context.ts` вызывает `loadConfig()` свежим каждый раз → binding changes подхватываются без рестарта.

### Open TODOs

- [ ] Оставшиеся warnings в doctor: `groupPolicy: "allowlist"` но `groupAllowFrom` пуст — косметика, группы не используются
- [x] Debug logging отключён (debug.conf удалён, gateway перезапущен 19:29)

---

## Next Steps

1. Убедиться что Кузя стабильно работает (несколько часов)
2. Опционально: отключить debug logging (команда выше)
3. При следующем обновлении openclaw — сразу проверять bindings в changelog

## Key Links

- Config: `~/.openclaw/openclaw.json` (bindings, channels.telegram)
- Security rule: `/home/artur/projects/openclaw/src/telegram/bot-message-context.ts:214`
- Update offset: `~/.openclaw/telegram/update-offset-kuzya.json`
- Session store: `~/.openclaw/agents/kuzya/sessions/sessions.json`
- Debug log: `/tmp/openclaw/openclaw-2026-03-05.log`
- Debug conf: `~/.config/systemd/user/openclaw-gateway.service.d/debug.conf`
