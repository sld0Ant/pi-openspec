#!/usr/bin/env bash
set -euo pipefail

MIN_NODE_MAJOR=20
MIN_NODE_MINOR=19

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

log()   { echo -e "${GREEN}[openspec]${NC} $*"; }
error() { echo -e "${RED}[openspec]${NC} $*" >&2; }

check_node() {
    if ! command -v node &>/dev/null; then
        error "Node.js не найден. Установи версию >= ${MIN_NODE_MAJOR}.${MIN_NODE_MINOR}.0"
        error "https://nodejs.org или: nvm install ${MIN_NODE_MAJOR}"
        exit 1
    fi

    local version
    version=$(node --version | sed 's/^v//')
    local major minor
    major=$(echo "$version" | cut -d. -f1)
    minor=$(echo "$version" | cut -d. -f2)

    if (( major < MIN_NODE_MAJOR )) || (( major == MIN_NODE_MAJOR && minor < MIN_NODE_MINOR )); then
        error "Node.js $version — требуется >= ${MIN_NODE_MAJOR}.${MIN_NODE_MINOR}.0"
        error "Обнови: nvm install ${MIN_NODE_MAJOR} && nvm use ${MIN_NODE_MAJOR}"
        exit 1
    fi

    log "Node.js $version ✓"
}

install_openspec() {
    if command -v bun &>/dev/null; then
        log "Установка через bun..."
        bun add -g @fission-ai/openspec@latest
    elif command -v npm &>/dev/null; then
        log "Установка через npm..."
        npm install -g @fission-ai/openspec@latest
    else
        error "Ни bun, ни npm не найдены. Установи один из них."
        exit 1
    fi

    if ! command -v openspec &>/dev/null; then
        error "openspec не найден после установки. Проверь PATH."
        exit 1
    fi

    log "OpenSpec $(openspec --version) установлен ✓"
}

init_project() {
    local target="${1:-.}"

    if [[ ! -d "$target" ]]; then
        error "Директория $target не существует"
        exit 1
    fi

    log "Инициализация OpenSpec в $target..."
    log "(openspec init может задать интерактивные вопросы о профиле и конфигурации)"
    cd "$target"
    openspec init --tools pi
    log "Проект инициализирован ✓"
    log ""
    log "Сгенерированные файлы:"
    find .pi/skills -name '*.md' -type f 2>/dev/null | while read -r f; do
        log "  $f"
    done
    find .pi/prompts -name '*.md' -type f 2>/dev/null | while read -r f; do
        log "  $f"
    done
}

main() {
    log "=== Установка OpenSpec для Pi ==="
    log ""

    check_node
    install_openspec

    if [[ "${1:-}" == "--init" ]]; then
        init_project "${2:-.}"
    else
        log ""
        log "Для инициализации в проекте:"
        log "  cd your-project && openspec init --tools pi"
        log ""
        log "Или запусти этот скрипт с --init:"
        log "  bash install.sh --init /path/to/project"
    fi

    log ""
    log "Готово! Используй /opsx:propose для первого изменения."
}

main "$@"
