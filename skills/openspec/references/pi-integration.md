# Интеграция OpenSpec с Pi

## Как OpenSpec интегрируется с Pi

OpenSpec при инициализации (`openspec init --tools pi`) генерирует два типа файлов:

### Skills (`.pi/skills/openspec-*/SKILL.md`)

Каждая OPSX-команда генерируется как отдельный скилл:

```
.pi/skills/
├── openspec-propose/SKILL.md
├── openspec-explore/SKILL.md
├── openspec-apply-change/SKILL.md
└── openspec-archive-change/SKILL.md
```

Pi автоматически обнаруживает эти скиллы и показывает их агенту. При совпадении задачи агент загружает полный SKILL.md и следует инструкциям.

### Prompt Templates (`.pi/prompts/opsx-*.md`)

Prompt-шаблоны дают быстрый доступ к командам через `/`:

```
.pi/prompts/
├── opsx-propose.md
├── opsx-explore.md
├── opsx-apply.md
└── opsx-archive.md
```

В Pi пользователь вводит `/opsx-propose add-dark-mode` — шаблон разворачивается в промпт, аргументы передаются согласно формату, определённому OpenSpec.

## Взаимодействие скиллов и промптов

```
Пользователь: /opsx-propose add-dark-mode
         │
         ▼
Pi загружает prompt template opsx-propose.md
         │
         ▼
Агент видит инструкции + вызывает openspec CLI
         │
         ▼
openspec status / openspec instructions (JSON) → структурированные данные
         │
         ▼
Агент создаёт артефакты по шаблонам и зависимостям
```

## Управление профилями

По умолчанию OpenSpec устанавливает **core profile** (4 команды: propose, explore, apply, archive).

Для расширенного набора:

```bash
openspec config profile
# Выбрать нужные workflows
openspec update
# Перегенерирует скиллы и промпты в .pi/
```

## Обновление после апгрейда OpenSpec

```bash
bun add -g @fission-ai/openspec@latest
cd your-project
openspec update
```

`openspec update` перегенерирует все файлы в `.pi/skills/` и `.pi/prompts/` с актуальными инструкциями.

## Конфигурация проекта

Файл `openspec/config.yaml` влияет на генерацию артефактов:

```yaml
schema: spec-driven

context: |
  Tech stack: TypeScript, React, Node.js
  Testing: Vitest
  Language: Russian — все артефакты на русском

rules:
  proposal:
    - Включать план отката
  specs:
    - Формат Given/When/Then для сценариев
  design:
    - Включать диаграммы для сложных потоков
```

- **context** — вставляется во все артефакты
- **rules** — вставляются только в соответствующий артефакт

## Совместимость с другими Pi-скиллами

### OpenSpec + Trio Workflow

OpenSpec и trio (Planner → Executor → Reviewer) — разные подходы к планированию:

| Аспект | OpenSpec | Trio |
|--------|----------|------|
| Персистентность | Спеки живут в репозитории | План в контексте чата |
| Область | Spec-driven development | HTML/CSS/frontend |
| Итеративность | Дельта-спеки, архивирование | Один цикл plan → build → review |

Можно комбинировать:
- OpenSpec для планирования и спецификаций
- Trio для ревью реализации

### OpenSpec + Другие скиллы

OpenSpec не конфликтует с другими скиллами. Автогенерированные скиллы (`openspec-*`) загружаются по запросу и не влияют на остальные.

## Поддерживаемые delivery-режимы

OpenSpec позволяет выбрать, что генерировать:

| Режим | Что создаётся |
|-------|--------------|
| **Skills only** | Только `.pi/skills/openspec-*/SKILL.md` |
| **Commands only** | Только `.pi/prompts/opsx-*.md` |
| **Both** (по умолчанию) | И скиллы, и промпт-шаблоны |

Настройка: `openspec config profile` → выбрать delivery mode.

## Отключение телеметрии

OpenSpec собирает анонимную статистику (только имена команд и версию).

```bash
export OPENSPEC_TELEMETRY=0
# или
export DO_NOT_TRACK=1
```
