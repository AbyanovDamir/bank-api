#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}=== MailHog Email Viewer ===${NC}"

# Получаем письма
RESPONSE=$(curl -s http://localhost:8025/api/v2/messages)
TOTAL=$(echo "$RESPONSE" | jq '.total')

echo -e "${GREEN}📧 Всего писем: ${TOTAL}${NC}\n"

if [ "$TOTAL" -eq 0 ]; then
    echo "Нет писем. Зарегистрируйте пользователя для отправки письма:"
    echo "  curl -X POST http://localhost:8080/api/v1/register \\"
    echo "    -H 'Content-Type: application/json' \\"
    echo "    -d '{\"username\":\"test\",\"email\":\"test@mailhog.local\",\"password\":\"123\"}'"
else
    echo "Последние 5 писем:"
    echo "$RESPONSE" | jq -r '.items[0:5][] | "  [\(.Created[0:19])] \(.Content.Headers.Subject[0]) → \(.Content.Headers.To[0])"'
fi

echo -e "\n${GREEN}🌐 Открыть в браузере: http://localhost:8025${NC}"
