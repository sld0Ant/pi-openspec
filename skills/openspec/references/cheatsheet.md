# Шпаргалка OpenSpec

## Структура каталогов

```
openspec/
├── specs/                  # Источник правды — текущее поведение системы
│   └── <домен>/
│       └── spec.md
├── changes/                # Активные изменения
│   ├── <название>/
│   │   ├── proposal.md     # Зачем и что меняем
│   │   ├── specs/          # Дельта-спеки (ADDED/MODIFIED/REMOVED)
│   │   │   └── <домен>/
│   │   │       └── spec.md
│   │   ├── design.md       # Технический подход
│   │   └── tasks.md        # Чеклист реализации
│   └── archive/            # Завершённые изменения
└── config.yaml             # Конфигурация проекта
```

## OPSX-команды (слэш-команды в Pi)

### Core Profile (по умолчанию)

```
/opsx:propose <название>    Создать изменение + артефакты планирования
/opsx:explore               Исследовать идею перед созданием изменения
/opsx:apply [название]      Реализовать задачи из tasks.md
/opsx:archive [название]    Архивировать изменение, слить спеки
```

### Expanded Profile

```
/opsx:new <название>        Создать каркас изменения (без артефактов)
/opsx:continue [название]   Создать следующий артефакт по зависимостям
/opsx:ff [название]         Быстро создать все артефакты планирования
/opsx:verify [название]     Проверить реализацию vs артефакты
/opsx:sync [название]       Слить дельта-спеки в основные
/opsx:bulk-archive          Архивировать несколько изменений
/opsx:onboard               Интерактивное обучение
```

## CLI-команды (терминал)

### Управление

```bash
openspec init [--tools pi]           Инициализация в проекте
openspec update                      Обновить сгенерированные файлы
openspec list [--specs|--changes]    Список спеков или изменений
openspec show <название>             Детали изменения/спека
openspec view                        Интерактивный дашборд
openspec validate [--all]            Валидация спеков и изменений
openspec archive <название>          Архивировать изменение
```

### Схемы

```bash
openspec schemas                     Список доступных схем
openspec schema init <имя>           Создать кастомную схему
openspec schema fork <из> <в>        Форкнуть схему для кастомизации
openspec schema validate <имя>       Валидировать схему
openspec schema which <имя>          Откуда берётся схема
```

### Workflow-команды

```bash
openspec status --change <имя>       Статус артефактов изменения
openspec instructions <артефакт>     Инструкции для создания артефакта
openspec templates                   Пути к шаблонам
```

### Настройки

```bash
openspec config list                 Все текущие настройки
openspec config profile              Переключение workflow-профиля
openspec config set <key> <value>    Установить параметр
```

## Граф зависимостей артефактов (spec-driven)

```
              proposal
                 │
       ┌─────────┴─────────┐
       ▼                   ▼
     specs              design
       │                   │
       └─────────┬─────────┘
                 ▼
              tasks
                 │
                 ▼
            implement
```

- `proposal` — корень, не зависит ни от чего
- `specs` и `design` — зависят от proposal, можно создавать параллельно
- `tasks` — зависит от specs И design
- Реализация (`apply`) — требует tasks

## Дельта-спеки

Описывают изменения относительно текущих спецификаций:

```markdown
# Delta for Auth

## ADDED Requirements

### Requirement: Two-Factor Authentication
The system MUST support TOTP-based two-factor authentication.

#### Scenario: 2FA login
- GIVEN a user with 2FA enabled
- WHEN the user submits valid credentials
- THEN an OTP challenge is presented

## MODIFIED Requirements

### Requirement: Session Timeout
The system SHALL expire sessions after 15 minutes.
(Previously: 30 minutes)

## REMOVED Requirements

### Requirement: Remember Me
(Deprecated in favor of 2FA)
```

При архивировании:
- **ADDED** → добавляются в основной спек
- **MODIFIED** → заменяют существующее требование
- **REMOVED** → удаляются из основного спека

## RFC 2119 ключевые слова

| Слово | Сила |
|-------|------|
| **MUST / SHALL** | Обязательное требование |
| **SHOULD** | Рекомендуемое, допустимы исключения |
| **MAY** | Опциональное |

## Типичные workflow

### Быстрая фича

```
/opsx:propose → /opsx:apply → /opsx:archive
```

### Исследование + фича (expanded)

```
/opsx:explore → /opsx:new → /opsx:continue (повторять) → /opsx:apply → /opsx:verify → /opsx:archive
```

### Параллельная работа

```
/opsx:apply change-a    # Работаем над A
                         # Переключение контекста
/opsx:new change-b      # Создаём B
/opsx:ff change-b       # Артефакты для B
/opsx:apply change-b    # Реализуем B
/opsx:archive change-b  # Завершаем B
/opsx:apply change-a    # Возвращаемся к A
```

## Когда обновлять изменение vs создать новое

**Обновляй**, если:
- Тот же intent, уточнённая реализация
- Scope сужается (MVP сначала, остальное потом)
- Кодовая база оказалась не такой, как ожидалось

**Создавай новое**, если:
- Intent принципиально изменился
- Scope разросся до другой работы
- Исходное изменение можно завершить самостоятельно

Быстрый тест: >50% overlap со старым → обновляй. <50% → новое изменение.

## Полезные ссылки

- [OpenSpec GitHub](https://github.com/Fission-AI/OpenSpec)
- [OpenSpec документация](https://github.com/Fission-AI/OpenSpec/tree/main/docs)
- [OpenSpec Discord](https://discord.gg/YctCnvvshC)
