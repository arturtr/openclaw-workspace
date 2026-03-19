# Singularity App — API-справочник

**API Base:** `https://api.singularity-app.com/v2`

**Токен Артура:** `~/.openclaw/secrets/singularity-api-token`

**Auth header:** `Authorization: Bearer $(cat ~/.openclaw/secrets/singularity-api-token)`

## Шаблон curl

```bash
TOKEN=$(cat ~/.openclaw/secrets/singularity-api-token)
curl -s -X GET "https://api.singularity-app.com/v2/project" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json"
```

## Эндпоинты

| Метод | URL | Что делает |
|-------|-----|-----------|
| GET | /v2/project | Список проектов |
| POST | /v2/project | Создать проект |
| PATCH | /v2/project/{id} | Обновить проект |
| DELETE | /v2/project/{id} | Удалить проект |
| GET | /v2/task?status=active | Активные задачи |
| GET | /v2/task?projectId={id} | Задачи проекта |
| POST | /v2/task | Создать задачу |
| PATCH | /v2/task/{id} | Обновить задачу |
| DELETE | /v2/task/{id} | Удалить задачу |
| GET | /v2/tag | Список тегов |
| POST | /v2/tag | Создать тег |
| GET | /v2/note/{noteId} | Получить заметку (Delta content) |
| PATCH | /v2/note/{noteId} | Обновить заметку (Delta content) |
| GET | /v2/habit | Список привычек |
| POST | /v2/habit | Создать привычку |

## Создание задачи

```json
{
  "title": "Название",
  "projectId": "ID-проекта",
  "start": "2026-03-16T09:00:00+03:00",
  "priority": 1,
  "useTime": false,
  "note": "[{\"attributes\":{\"bold\":true},\"insert\":\"Заголовок:\"},{\"insert\":\" описание\\n\"}]"
}
```

## Создание проекта

```json
{
  "title": "Название",
  "emoji": "1f3e0",
  "color": "#4caf50"
}
```

## Правила API

**Emoji:** hex codepoint без префикса → `"1f49e"` (не `"U+1F49E"`, не `"💞"`)

**Priority:** 0 = high, 1 = normal (дефолт), 2 = low.

**State (закрепление):** 0 = pinned, 1 = unpinned (дефолт). Это НЕ статус завершения.

**Checked (завершение):** 0 = пусто, 1 = выполнена, 2 = отменена.

**Deferred (Когда-нибудь):** `"deferred": true` — задача попадает в раздел «Когда-нибудь». Без даты. Для возврата: `"deferred": false`.

**Complete:** число (вероятно 0-100), прогресс-бар.

**Время:** UTC+10 (Хабаровск). `useTime: false` — только дата. `useTime: true` — реальное время.

**Заметки (note):** строка. Два варианта:
- **Plain text:** `"note": "простой текст"` — сохранится как есть.
- **Delta (Quill):** `"note": json.dumps(delta_array)` — JSON-строка с Delta-массивом, приложение рендерит rich text. Атрибуты: `bold`, `italic`, `underline`, `link`, `blockquote`. Последний `insert` обязан заканчиваться на `\n`.
- **Чтение/обновление:** `GET/PATCH /v2/note/N-{taskId}`, поле `content` — Delta JSON-строка.

**Уведомления:**
```json
{
  "notifies": [60, 15],
  "notify": 1,
  "alarmNotify": false
}
```
`notifies` — массив минут от большего к меньшему. `alarmNotify: true` только по явной просьбе.

**Блокноты:** проект с атрибутом `notebook`. Записи в блокноте — задачи с `isNote: true`.

**Группы задач:** при добавлении в проект ставить в базовую группу, если не указано иное.

**Привычки — цвета:** строго строка из списка: `red`, `pink`, `purple`, `deepPurple`, `indigo`, `lightBlue`, `cyan`, `teal`, `green`, `lightGreen`, `lime`, `yellow`, `amber`, `orange`, `deepOrange`, `brown`, `grey`, `blueGrey`. Статус 0 = активная.

**Rate limit:** пауза 0.5 сек между запросами.

## Два аккаунта

- **Артур:** токен в `~/.openclaw/secrets/singularity-api-token`
- **Юля:** токен в `~/.openclaw/secrets/singularity-yulia-api-token`
- Общие проекты (Чай, ИИ-агентство, Наш дом) расшарены через UI → API доступ только через токен владельца (Артур)

## Swagger

Интерактивная документация: `https://api.singularity-app.com/v2/api` (требует токен)

Официальная wiki: `https://singularity-app.ru/wiki/api/`
