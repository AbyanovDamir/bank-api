#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}=== Очистка Bank API ===${NC}"

# Остановка контейнеров
echo -e "${YELLOW}1. Остановка Docker контейнеров...${NC}"
docker compose down -v 2>/dev/null
docker stop bank-postgres bank-mailhog 2>/dev/null
docker rm bank-postgres bank-mailhog 2>/dev/null

# Очистка бинарных файлов
echo -e "${YELLOW}2. Очистка бинарных файлов...${NC}"
rm -rf bin/ dist/

# Очистка логов
echo -e "${YELLOW}3. Очистка логов...${NC}"
rm -rf logs/*.log
rm -rf bank-files/*

# Очистка бэкапов (оставить последние 3)
echo -e "${YELLOW}4. Очистка старых бэкапов...${NC}"
cd backups 2>/dev/null && ls -t *.sql.gz 2>/dev/null | tail -n +4 | xargs -r rm && cd ..

# Опционально: очистка Docker
echo -e "${YELLOW}5. Очистка неиспользуемых Docker образов? (y/n)${NC}"
read -r answer
if [ "$answer" = "y" ]; then
    docker system prune -f
    echo -e "${GREEN}✓ Docker очищен${NC}"
fi

echo -e "${GREEN}✅ Очистка завершена!${NC}"
