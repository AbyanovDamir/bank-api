#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Testing MailHog Directly ===${NC}"

# Проверка, что MailHog доступен
if ! curl -s http://localhost:8025/api/v2/messages > /dev/null 2>&1; then
    echo -e "${RED}✗ MailHog не доступен${NC}"
    exit 1
fi

echo -e "${GREEN}✓ MailHog доступен${NC}"

# Отправляем письмо через SMTP (через API MailHog - правильный endpoint)
echo -e "\n${YELLOW}Отправка тестового письма через API MailHog...${NC}"

# Правильный API endpoint для отправки (через curl)
curl -s -X POST http://localhost:8025/api/v1/messages \
  -H "Content-Type: application/json" \
  -d '{
    "from": "bank@test.com",
    "to": ["test@mailhog.local"],
    "subject": "Test Email from Bank API",
    "body": "<h1>Hello!</h1><p>This is a test email.</p>"
  }' 2>/dev/null | grep -q "200\|201" && echo -e "${GREEN}✓ Письмо отправлено через API${NC}" || echo -e "${YELLOW}⚠ API отправка не работает (используем только SMTP)${NC}"

echo -e "\n${YELLOW}=== Проверка MailHog ===${NC}"
sleep 2

# Получаем список писем
MAIL_RESPONSE=$(curl -s http://localhost:8025/api/v2/messages)
TOTAL=$(echo "$MAIL_RESPONSE" | jq '.total')
echo -e "${GREEN}📧 Всего писем в MailHog: ${TOTAL}${NC}"

if [ "$TOTAL" -gt 0 ]; then
    echo -e "\n${YELLOW}Список писем:${NC}"
    echo "$MAIL_RESPONSE" | jq -r '.items[] | "  📧 \(.Content.Headers.Subject[0] | .[0:50]) → \(.Content.Headers.To[0])"'
    
    echo -e "\n${YELLOW}Последнее письмо:${NC}"
    echo "$MAIL_RESPONSE" | jq -r '.items[0] | "  От: \(.Content.Headers.From[0])\n  Кому: \(.Content.Headers.To[0])\n  Тема: \(.Content.Headers.Subject[0])\n  Дата: \(.Created)"'
fi

echo -e "\n${GREEN}📧 Open MailHog Web Interface: http://localhost:8025${NC}"
echo -e "${YELLOW}💡 Все письма, отправленные Bank API, появляются здесь автоматически${NC}"
