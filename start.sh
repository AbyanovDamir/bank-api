#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Bank API - Универсальный запуск${NC}"
echo -e "${GREEN}========================================${NC}"

# Проверка аргументов
MODE=${1:-docker}

case $MODE in
    docker)
        echo -e "${YELLOW}Запуск в Docker режиме...${NC}"
        make docker-up
        ;;
    local)
        echo -e "${YELLOW}Запуск в локальном режиме...${NC}"
        
        # Запуск зависимостей если нужно
        if ! docker ps | grep -q postgres; then
            echo "Запуск PostgreSQL..."
            docker run -d --name bank-postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres:17
        fi
        
        if ! docker ps | grep -q mailhog; then
            echo "Запуск MailHog..."
            docker run -d --name bank-mailhog -p 1025:1025 -p 8025:8025 mailhog/mailhog
        fi
        
        echo -e "${GREEN}Запуск приложения...${NC}"
        make run
        ;;
    test)
        echo -e "${YELLOW}Запуск тестов...${NC}"
        make full-test
        ;;
    *)
        echo "Использование: ./start.sh [docker|local|test]"
        echo "  docker - запуск в Docker контейнерах (по умолчанию)"
        echo "  local  - локальный запуск с зависимостями в Docker"
        echo "  test   - запуск тестов"
        ;;
esac
