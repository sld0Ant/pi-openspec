---
name: openspec
description: Установка, настройка и использование OpenSpec (spec-driven development) в Pi. Используй когда пользователь хочет работать с OpenSpec, планировать изменения через спецификации, или выполнять команды /opsx:propose, /opsx:apply, /opsx:archive.
---

# OpenSpec для Pi

OpenSpec — фреймворк спецификационно-управляемой разработки (SDD). Позволяет согласовать требования до написания кода: человек и AI выравниваются на спецификациях, затем реализуют, затем архивируют.

## Требования

- **Node.js ≥ 20.19.0** (`node --version`)
- **bun** (предпочтительно) или npm
- **Платформы**: Linux, macOS, WSL

## Установка

```bash
bash scripts/install.sh
```

(Запускай из директории скилла)

Скрипт:
1. Проверяет версию Node.js
2. Устанавливает `@fission-ai/openspec` глобально
3. Запускает `openspec init --tools pi` в текущем проекте

### Ручная установка

```bash
bun add -g @fission-ai/openspec@latest
cd your-project
openspec init --tools pi
```

## Как это работает

После `openspec init --tools pi` в проекте появляются:

```
openspec/
├── specs/              # Источник правды: как система работает сейчас
├── changes/            # Предлагаемые изменения (по папке на каждое)
└── config.yaml         # Конфигурация проекта (опционально)

.pi/
├── skills/openspec-*/SKILL.md    # Автогенерированные скиллы OpenSpec
└── prompts/opsx-*.md             # Автогенерированные prompt-шаблоны
```

OpenSpec сам генерирует скиллы и промпты для Pi. Данный скилл — **мета-руководство** по эффективному использованию.

## Основные команды (core profile)

> **Синтаксис:** В документации OpenSpec команды пишутся через двоеточие (`/opsx:propose`). В Pi prompt templates вызываются через дефис (`/opsx-propose`). Оба варианта эквивалентны — Pi распознаёт свой формат автоматически.

| Команда | Pi prompt | Назначение |
|---------|-----------|------------|
| `/opsx:propose <название>` | `/opsx-propose` | Создать изменение + все артефакты планирования |
| `/opsx:explore` | `/opsx-explore` | Исследовать идею до фиксации в изменение |
| `/opsx:apply` | `/opsx-apply` | Реализовать задачи из tasks.md |
| `/opsx:archive` | `/opsx-archive` | Архивировать завершённое изменение, слить спеки |

### Расширенные команды (expanded profile)

Включить: `openspec config profile` → выбрать workflows → `openspec update`

| Команда | Pi prompt | Назначение |
|---------|-----------|------------|
| `/opsx:new` | `/opsx-new` | Создать каркас изменения |
| `/opsx:continue` | `/opsx-continue` | Создать следующий артефакт по зависимостям |
| `/opsx:ff` | `/opsx-ff` | Создать все артефакты планирования за раз |
| `/opsx:verify` | `/opsx-verify` | Проверить реализацию на соответствие артефактам |
| `/opsx:sync` | `/opsx-sync` | Слить дельта-спеки в основные |
| `/opsx:bulk-archive` | `/opsx-bulk-archive` | Архивировать несколько изменений |
| `/opsx:onboard` | `/opsx-onboard` | Интерактивное обучение workflow |

## Быстрый старт

```
Ты: /opsx:propose add-dark-mode
AI: Создал openspec/changes/add-dark-mode/
    ✓ proposal.md — зачем и что меняем
    ✓ specs/       — требования и сценарии
    ✓ design.md    — технический подход
    ✓ tasks.md     — чеклист реализации

Ты: /opsx:apply
AI: Реализую задачи...
    ✓ 1.1 Создан ThemeContext
    ✓ 1.2 Добавлены CSS-переменные
    Все задачи выполнены!

Ты: /opsx:archive
AI: ✓ Спеки слиты в openspec/specs/
    ✓ Изменение перенесено в archive/
```

## Конфигурация проекта

Скопируй шаблон конфига в проект:

```bash
cp templates/config-minimal.yaml your-project/openspec/config.yaml
```

Или полный вариант с примерами:

```bash
cp templates/config-full.yaml your-project/openspec/config.yaml
```

(Пути относительны от директории скилла)

## Обновление после апгрейда

```bash
bun add -g @fission-ai/openspec@latest
cd your-project
openspec update
```

## Troubleshooting

### Команды не распознаются

```bash
openspec update    # Перегенерировать скиллы и промпты
```

Убедись, что `.pi/skills/` существует и содержит `openspec-*` файлы.

### "Node.js version too old"

OpenSpec требует Node.js ≥ 20.19.0. Обнови:

```bash
# nvm
nvm install 20
nvm use 20

# Или напрямую с https://nodejs.org
```

### Артефакты генерируются некорректно

- Добавь контекст проекта в `openspec/config.yaml`
- Используй `/opsx:continue` вместо `/opsx:ff` для большего контроля
- Добавь правила (`rules`) для конкретных артефактов

### Изменение не найдено

```bash
openspec list              # Список активных изменений
openspec show <название>   # Детали конкретного изменения
```

## Reference-документы

- [Шпаргалка](references/cheatsheet.md) — Ключевые команды и концепции
- [Интеграция с Pi](references/pi-integration.md) — Как Pi и OpenSpec работают вместе
- [Быстрый старт](examples/quick-start.md) — Пошаговое руководство
- [Пример workflow в Pi](examples/pi-workflow.md) — Реальный сценарий разработки
