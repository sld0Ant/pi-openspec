# Быстрый старт: от установки до первого изменения

## 1. Установка OpenSpec

```bash
bun add -g @fission-ai/openspec@latest
openspec --version
```

## 2. Инициализация в проекте

```bash
cd your-project
openspec init --tools pi
```

Будет создана структура:

```
openspec/
├── specs/
├── changes/
└── config.yaml

.pi/
├── skills/openspec-*/SKILL.md
└── prompts/opsx-*.md
```

## 3. (Опционально) Настройка конфигурации

Отредактируй `openspec/config.yaml`:

```yaml
schema: spec-driven

context: |
  Tech stack: TypeScript, React, Node.js
  Testing: Vitest
```

## 4. Предложение изменения

В Pi введи:

```
/opsx:propose add-user-notifications
```

OpenSpec создаст:

```
openspec/changes/add-user-notifications/
├── proposal.md     # Зачем: уведомления нужны для…
├── specs/           # Что: требования и сценарии
│   └── notifications/
│       └── spec.md
├── design.md        # Как: WebSocket vs polling, архитектура
└── tasks.md         # Шаги: чеклист реализации
```

## 5. Просмотр и корректировка артефактов

Прочитай сгенерированные файлы. Если нужно что-то поправить — отредактируй напрямую. Артефакты можно менять в любой момент.

```bash
openspec show add-user-notifications
openspec validate add-user-notifications
```

## 6. Реализация

```
/opsx:apply
```

Агент пройдёт по tasks.md, реализует каждую задачу и отметит выполненные `[x]`.

## 7. Проверка статуса

```bash
openspec status --change add-user-notifications
```

Показывает, какие артефакты готовы, какие заблокированы, сколько задач выполнено.

## 8. Архивирование

```
/opsx:archive
```

Что происходит:
1. Дельта-спеки сливаются в `openspec/specs/`
2. Папка изменения переносится в `openspec/changes/archive/2026-02-27-add-user-notifications/`
3. Спецификации обновлены — источник правды отражает новое поведение

## 9. Следующее изменение

Цикл повторяется:

```
/opsx:propose next-feature
```

Каждое изменение строится на обновлённых спецификациях.

## Итого: минимальный workflow

```
openspec init --tools pi        # Один раз
/opsx:propose <название>        # Создать изменение
/opsx:apply                     # Реализовать
/opsx:archive                   # Завершить
```
