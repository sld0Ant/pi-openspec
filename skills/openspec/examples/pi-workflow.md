# Пример: Разработка фичи с OpenSpec в Pi

Реальный сценарий — добавление системы уведомлений в существующий проект.

## Контекст

Проект: веб-приложение на TypeScript + React + Node.js. Нужно добавить уведомления о событиях (новые сообщения, обновления статуса).

## Шаг 1: Исследование

```
/opsx:explore
```

> Я хочу добавить уведомления. Какие варианты?

Агент исследует кодовую базу, находит существующие паттерны (WebSocket-соединение уже есть для чата), предлагает варианты:
1. Расширить существующий WebSocket
2. Server-Sent Events
3. Polling

Решаем расширить WebSocket — он уже есть.

## Шаг 2: Создание изменения

```
/opsx:propose add-notifications
```

Агент создаёт полный набор артефактов:

**proposal.md** — Зачем:
- Пользователи не видят новые события без обновления страницы
- Scope: real-time уведомления через WebSocket, UI-компонент, persistence
- Out of scope: email/push-уведомления (отдельное изменение)

**specs/notifications/spec.md** — Что:
```markdown
## ADDED Requirements

### Requirement: Real-time Notifications
The system SHALL deliver notifications to connected users in real-time.

#### Scenario: New message notification
- GIVEN a user is connected via WebSocket
- WHEN another user sends them a message
- THEN a notification appears within 2 seconds

#### Scenario: Notification persistence
- GIVEN a user was offline
- WHEN the user reconnects
- THEN unread notifications are loaded from the database
```

**design.md** — Как:
- Расширить WebSocket-хендлер новым типом событий
- Новая таблица `notifications` в PostgreSQL
- React-компонент NotificationBell в Header

**tasks.md** — Шаги:
```markdown
## 1. Backend
- [ ] 1.1 Создать миграцию для таблицы notifications
- [ ] 1.2 Добавить notification event type в WebSocket handler
- [ ] 1.3 API endpoint GET /notifications

## 2. Frontend
- [ ] 2.1 NotificationBell компонент
- [ ] 2.2 Подписка на WebSocket events
- [ ] 2.3 Notification dropdown с историей
```

## Шаг 3: Корректировка артефактов

Читаем proposal и design. Замечаем, что не учли rate limiting для уведомлений. Редактируем design.md, добавляем задачу в tasks.md.

Артефакты — живые документы, их можно менять в любой момент.

## Шаг 4: Реализация

```
/opsx:apply
```

Агент проходит по tasks.md:
- Создаёт миграцию
- Расширяет WebSocket handler
- Создаёт React-компоненты
- Отмечает задачи `[x]`

Если в процессе обнаруживается проблема — обновляем design.md и продолжаем.

## Шаг 5: Проверка

```bash
openspec status --change add-notifications
```

```
Change: add-notifications
Progress: 4/4 artifacts complete
Tasks: 6/6 complete
```

## Шаг 6: Архивирование

```
/opsx:archive
```

- Дельта-спеки сливаются в `openspec/specs/notifications/spec.md`
- Папка переносится в archive
- Спецификации обновлены

## Результат

После архивирования в проекте:

```
openspec/specs/notifications/spec.md    # Новый спек — источник правды
openspec/changes/archive/2026-02-27-add-notifications/
                                         # Полная история: proposal, design, tasks
```

Следующее изменение (например, email-уведомления) может ссылаться на существующий спек `notifications/spec.md` и расширять его через дельту.
