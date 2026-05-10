#!/bin/bash

echo "========================================="
echo "   Тестирование отправки email через MailHog"
echo "========================================="

# Регистрация пользователя
echo -e "\n1. Регистрация пользователя:"
REGISTER_RESPONSE=$(curl -s -X POST http://localhost:8080/api/v1/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "email_test_user",
    "email": "test@example.com",
    "password": "password123"
  }')
echo "$REGISTER_RESPONSE" | jq .

# Проверка писем в MailHog
echo -e "\n2. Проверка писем в MailHog:"
sleep 2
EMAILS=$(curl -s http://localhost:8025/api/v2/messages)
COUNT=$(echo "$EMAILS" | jq '.total')
echo "Количество писем: $COUNT"

if [ "$COUNT" -gt 0 ]; then
    echo -e "\n3. Содержание письма:"
    echo "$EMAILS" | jq '.items[0].Content.Body'
    
    echo -e "\n✅ Email успешно отправлен и получен MailHog!"
    echo "   Откройте http://localhost:8025 для просмотра"
else
    echo -e "\n❌ Письма не найдены"
fi

echo -e "\n========================================="
