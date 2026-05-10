#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Bank API - Мониторинг сервисов${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Проверка Bank API
echo -e "${YELLOW}Bank API Status:${NC}"
if curl -s http://localhost:8080/api/health > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Bank API - работает${NC}"
    RESPONSE=$(curl -s http://localhost:8080/api/health)
    echo "$RESPONSE" | jq . 2>/dev/null || echo "$RESPONSE"
else
    echo -e "${RED}✗ Bank API - не отвечает${NC}"
fi

# Проверка PostgreSQL
echo -e "\n${YELLOW}PostgreSQL Status:${NC}"
if docker ps | grep -q postgres; then
    echo -e "${GREEN}✓ PostgreSQL - запущен${NC}"
else
    echo -e "${RED}✗ PostgreSQL - не запущен${NC}"
fi

# Проверка MailHog
echo -e "\n${YELLOW}MailHog Status:${NC}"
if curl -s http://localhost:8025 > /dev/null 2>&1; then
    echo -e "${GREEN}✓ MailHog - работает${NC}"
    echo "  Web: http://localhost:8025"
else
    echo -e "${RED}✗ MailHog - не запущен${NC}"
fi

echo -e "\n${BLUE}========================================${NC}"
