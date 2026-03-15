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

### Проекты (обновлено 15.03.2026)
- 🏠 Наш дом | 💼 Работа | 💻 Jiffy | 🍵 Чай
- 👪 Семья | 👦 Ефрем | ✝ Вера | ⛪ Воцерковление | 🏫 Школа веры
- 💰 Mellow | 🔍 Поиск жилья | 📚 Книги
- 🎓 DataCamp / BABOK | 📊 Khabarovsk Data Lab | 📣 Личный бренд
- 🧙 Witchcraft Note | 🥋 БЖЖ | 💪 Тело | 🌿 ТКМ
- ☕ Дакэмп Чаепития | 📲 ТГ: Чайные встречи | 🌱 Чайный сад
- 🚀 Своё дело | 🤖 ИИ-агентство
