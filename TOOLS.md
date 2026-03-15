# TOOLS.md

## Singularity App (таск-менеджер семьи)

**Скрипт:** `scripts/singularity.sh`
**Токен:** `~/.openclaw/secrets/singularity-api-token`
**API:** https://api.singularity-app.com/v2

### Команды
```bash
scripts/singularity.sh projects                    # список проектов
scripts/singularity.sh tasks [project_id]          # задачи (активные)
scripts/singularity.sh add "title" [proj] [date]   # создать задачу
scripts/singularity.sh complete <task_id>          # завершить задачу
scripts/singularity.sh tags                        # теги
scripts/singularity.sh habits                      # привычки
scripts/singularity.sh raw GET /endpoint           # произвольный запрос
```

### Проекты
- 💼 Работа
- 🏡 Личное
- 📚 Учёба
- 🍵 Чайная миссия
- Ефрем
- Завершение дел в Ха
