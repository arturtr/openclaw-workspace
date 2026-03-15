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

### Чеклисты в задачах
```bash
# Создать пункт чеклиста
scripts/singularity.sh raw POST /checklist-item \
  '{"title":"Пункт","parent":"T-xxx","parentOrder":100}'

# Отметить выполненным
scripts/singularity.sh raw PATCH /checklist-item/CH-xxx '{"done":true}'

# Получить все чеклисты задачи
scripts/singularity.sh raw GET "/checklist-item?taskId=T-xxx"
```
parentOrder задаёт порядок (100, 200, 300...). done: true/false.

### Заметки в задачах (Delta / Quill формат)
Заметки — **Delta JSON-строка** (Quill rich text), не plain markdown!
**⚠️ Использовать ТОЛЬКО эндпоинт `/v2/note/`, НЕ поле `note` в задаче!**
```bash
# Обновить заметку через /note endpoint (ПРАВИЛЬНЫЙ способ)
scripts/singularity.sh raw PATCH /note/N-T-xxx \
  '{"content":"[{\"attributes\":{\"bold\":true},\"insert\":\"Заголовок:\"},{\"insert\":\" текст\\n\"}]"}'

# Прочитать заметку
scripts/singularity.sh raw GET /note/N-T-xxx
```
- content = JSON-строка с массивом Delta ops
- Атрибуты: `bold`, `italic`, `underline`, `link`, `blockquote`
- Последний `insert` **обязан** заканчиваться на `\n`
- Для сложных заметок лучше использовать python (экранирование)

### Два аккаунта (семейный)
- **Артур:** токен в `~/.openclaw/secrets/singularity-api-token`
- **Юля:** токен в `~/.openclaw/secrets/singularity-api-token-yulia` (ожидается)
- Оба на тарифе **Elite** (299₽/мес) — shared-проекты доступны в приложении
- API видит только личные проекты каждого аккаунта
- **Кузя** работает с токеном Артура, **Эмбер** — с токеном Юли

### Ограничения API
- ❌ Нет webhooks (только polling)
- ❌ Повторяющиеся задачи через API не создать
- ❌ Shared-проекты через API не видны
- Priority: **0 = high, 1 = normal, 2 = low** (НЕ наоборот!)
- Checked: 0 = пусто, 1 = выполнена, 2 = отменена
- Подробная справка: `scripts/singularity-api.md`

### Проекты (обновлено 15.03.2026)
- 🏠 Наш дом | 💼 Работа | 💻 Jiffy | 🍵 Чай
- 👪 Семья | 👦 Ефрем | ✝ Вера | ⛪ Воцерковление | 🏫 Школа веры
- 💰 Mellow | 🔍 Поиск жилья | 📚 Книги
- 🎓 DataCamp / BABOK | 📊 Khabarovsk Data Lab | 📣 Личный бренд
- 🧙 Witchcraft Note | 🥋 БЖЖ | 💪 Тело | 🌿 ТКМ
- ☕ Дакэмп Чаепития | 📲 ТГ: Чайные встречи | 🌱 Чайный сад
- 🚀 Своё дело | 🤖 ИИ-агентство
