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
  "note": [{"insert": "Описание задачи\n"}]
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

**Priority:** 0 = высокий, 1 = обычный (по умолчанию), 2 = низкий. Значение 3+ вызывает 400.

**Время:** GMT+3. `useTime: false` — только дата. `useTime: true` — реальное время.

**Заметки (note):** Delta format — массив операций напрямую `[{},...]`, НЕ `{"ops":[...]}`. Последний `insert` обязан заканчиваться на `\n`.

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
