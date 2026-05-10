#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Bank API Starter ===${NC}"

# Проверка .env
if [ ! -f .env ]; then
    echo -e "${YELLOW}.env не найден. Генерация...${NC}"
    ./scripts/generate_secrets.sh
fi

# Экспорт переменных
export $(grep -v '^#' .env | xargs)

echo -e "${GREEN}✓ Конфигурация загружена${NC}"
echo -e "${GREEN}🚀 Запуск сервера на http://localhost:8080${NC}\n"

go run cmd/main.go
