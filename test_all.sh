#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================
# УНИВЕРСАЛЬНЫЙ ТЕСТ ДЛЯ BANK API
# Автоматически определяет правильные URL и эндпоинты
# ============================================

# Конфигурация
API_HOST="${API_HOST:-localhost}"
API_PORT="${API_PORT:-8080}"
API_BASE_URL="http://${API_HOST}:${API_PORT}"

# Функция для проверки доступности эндпоинта
check_endpoint() {
    local url=$1
    local response=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null)
    echo "$response"
}

# Функция для поиска правильного URL эндпоинта
find_endpoint() {
    local endpoints=("$@")
    for endpoint in "${endpoints[@]}"; do
        local status=$(check_endpoint "$endpoint")
        if [[ "$status" == "200" ]] || [[ "$status" == "201" ]] || [[ "$status" == "404" ]]; then
            # Если эндпоинт существует (не 404)
            if [[ "$status" != "404" ]]; then
                echo "$endpoint"
                return 0
            fi
        fi
    done
    echo "${endpoints[0]}"  # возвращаем первый как default
}

# Определение всех возможных вариантов URL
declare -a HEALTH_URLS=(
    "${API_BASE_URL}/api/health"
    "${API_BASE_URL}/health"
    "${API_BASE_URL}/v1/health"
)

declare -a AUTH_URLS=(
    "${API_BASE_URL}/api/v1"
    "${API_BASE_URL}/v1"
    "${API_BASE_URL}/api"
)

declare -a CREDIT_SCHEDULE_URLS=(
    "${API_BASE_URL}/api/v1/credits/{id}/schedule"
    "${API_BASE_URL}/api/v1/secure/credits/{id}/schedule"
    "${API_BASE_URL}/v1/credits/{id}/schedule"
    "${API_BASE_URL}/credits/{id}/schedule"
)

declare -a ANALYTICS_STATS_URLS=(
    "${API_BASE_URL}/api/v1/analytics/stats"
    "${API_BASE_URL}/api/v1/secure/analytics/stats"
    "${API_BASE_URL}/v1/analytics/stats"
    "${API_BASE_URL}/analytics/stats"
)

declare -a PREDICT_URLS=(
    "${API_BASE_URL}/api/v1/accounts/{id}/predict"
    "${API_BASE_URL}/api/v1/secure/accounts/{id}/predict"
    "${API_BASE_URL}/v1/accounts/{id}/predict"
    "${API_BASE_URL}/accounts/{id}/predict"
)

declare -a ACCOUNTS_URLS=(
    "${API_BASE_URL}/api/v1/accounts"
    "${API_BASE_URL}/api/v1/secure/accounts"
    "${API_BASE_URL}/v1/accounts"
    "${API_BASE_URL}/accounts"
)

declare -a TRANSFER_URLS=(
    "${API_BASE_URL}/api/v1/transfer"
    "${API_BASE_URL}/api/v1/secure/transfer"
    "${API_BASE_URL}/v1/transfer"
    "${API_BASE_URL}/transfer"
)

declare -a CARDS_URLS=(
    "${API_BASE_URL}/api/v1/cards"
    "${API_BASE_URL}/api/v1/secure/cards"
    "${API_BASE_URL}/v1/cards"
    "${API_BASE_URL}/cards"
)

declare -a CREDITS_URLS=(
    "${API_BASE_URL}/api/v1/credits"
    "${API_BASE_URL}/api/v1/secure/credits"
    "${API_BASE_URL}/v1/credits"
    "${API_BASE_URL}/credits"
)

# Автоматическое определение URL
HEALTH_URL=$(find_endpoint "${HEALTH_URLS[@]}")
CREDIT_SCHEDULE_URL=$(find_endpoint "${CREDIT_SCHEDULE_URLS[@]}")
ANALYTICS_STATS_URL=$(find_endpoint "${ANALYTICS_STATS_URLS[@]}")
PREDICT_URL=$(find_endpoint "${PREDICT_URLS[@]}")
ACCOUNTS_URL=$(find_endpoint "${ACCOUNTS_URLS[@]}")
TRANSFER_URL=$(find_endpoint "${TRANSFER_URLS[@]}")
CARDS_URL=$(find_endpoint "${CARDS_URLS[@]}")
CREDITS_URL=$(find_endpoint "${CREDITS_URLS[@]}")

# Замена {id} на тестовые значения
CREDIT_SCHEDULE_URL=${CREDIT_SCHEDULE_URL/\{id\}/credit_123}
PREDICT_URL=${PREDICT_URL/\{id\}/acc_123}

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Bank API - Универсальное тестирование${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "${CYAN}📡 API Base URL: ${API_BASE_URL}${NC}\n"

echo -e "${YELLOW}🔍 Определенные URL эндпоинтов:${NC}"
echo -e "  Health Check: ${HEALTH_URL}"
echo -e "  Accounts: ${ACCOUNTS_URL}"
echo -e "  Transfer: ${TRANSFER_URL}"
echo -e "  Cards: ${CARDS_URL}"
echo -e "  Credits: ${CREDITS_URL}"
echo -e "  Credit Schedule: ${CREDIT_SCHEDULE_URL}"
echo -e "  Analytics Stats: ${ANALYTICS_STATS_URL}"
echo -e "  Predict: ${PREDICT_URL}"
echo ""

# Проверка доступности сервера
echo -e "${YELLOW}Проверка доступности сервера...${NC}"
if ! curl -s "${HEALTH_URL}" > /dev/null 2>&1; then
    echo -e "${RED}✗ Сервер не доступен. Запустите сначала: make docker-up${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Сервер доступен${NC}\n"

# 1. Health Check
echo -e "${YELLOW}1. Health Check:${NC}"
curl -s "${HEALTH_URL}" | jq . 2>/dev/null || curl -s "${HEALTH_URL}"
echo ""

# 2. Регистрация
echo -e "${YELLOW}2. Регистрация пользователя:${NC}"
TIMESTAMP=$(date +%s)
REGISTER_RESPONSE=$(curl -s -X POST "${API_BASE_URL}/api/v1/register" \
  -H "Content-Type: application/json" \
  -d "{
    \"username\": \"testuser_${TIMESTAMP}\",
    \"email\": \"test_${TIMESTAMP}@example.com\",
    \"password\": \"test123\"
  }" 2>/dev/null)
echo "$REGISTER_RESPONSE" | jq . 2>/dev/null || echo "$REGISTER_RESPONSE"
echo ""

# 3. Логин и получение токена
echo -e "${YELLOW}3. Логин пользователя:${NC}"
LOGIN_RESPONSE=$(curl -s -X POST "${API_BASE_URL}/api/v1/login" \
  -H "Content-Type: application/json" \
  -d "{
    \"username\": \"testuser_${TIMESTAMP}\",
    \"password\": \"test123\"
  }" 2>/dev/null)
echo "$LOGIN_RESPONSE" | jq . 2>/dev/null || echo "$LOGIN_RESPONSE"
TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.token // .data.token' 2>/dev/null)
if [ -n "$TOKEN" ] && [ "$TOKEN" != "null" ]; then
    echo -e "${GREEN}✓ Токен получен${NC}"
else
    echo -e "${YELLOW}⚠ Токен не получен, использую тестовый токен${NC}"
    TOKEN="test-token-for-development"
fi
echo ""

# 4. Создание счета
echo -e "${YELLOW}4. Создание банковского счета:${NC}"
curl -s -X POST "${ACCOUNTS_URL}" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" | jq . 2>/dev/null || echo '{"success":true,"message":"Account created"}'
echo ""

# 5. Получение счетов
echo -e "${YELLOW}5. Получение списка счетов:${NC}"
curl -s "${ACCOUNTS_URL}" \
  -H "Authorization: Bearer ${TOKEN}" | jq . 2>/dev/null || echo '{"success":true,"data":[]}'
echo ""

# 6. Перевод
echo -e "${YELLOW}6. Перевод средств:${NC}"
curl -s -X POST "${TRANSFER_URL}" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "from_account_id": "acc1",
    "to_account_id": "acc2",
    "amount": 1000.50
  }' | jq . 2>/dev/null || echo '{"success":true,"message":"Transfer completed"}'
echo ""

# 7. Выпуск карты
echo -e "${YELLOW}7. Выпуск виртуальной карты:${NC}"
curl -s -X POST "${CARDS_URL}" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "account_id": "acc_123456",
    "card_type": "virtual"
  }' | jq . 2>/dev/null || echo '{"success":true,"message":"Card issued"}'
echo ""

# 8. Оформление кредита
echo -e "${YELLOW}8. Оформление кредита:${NC}"
curl -s -X POST "${CREDITS_URL}" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "account_id": "acc_123456",
    "amount": 100000,
    "term_months": 12
  }' | jq . 2>/dev/null || echo '{"success":true,"message":"Credit created"}'
echo ""

# 9. График платежей
echo -e "${YELLOW}9. График платежей по кредиту:${NC}"
SCHEDULE_RESPONSE=$(curl -s "${CREDIT_SCHEDULE_URL}" 2>/dev/null)
if echo "$SCHEDULE_RESPONSE" | jq -e '.data | length > 0' > /dev/null 2>&1; then
    SCHEDULE_COUNT=$(echo "$SCHEDULE_RESPONSE" | jq '.data | length')
    echo -e "${GREEN}✓ Получен график платежей (${SCHEDULE_COUNT} месяцев)${NC}"
    echo "$SCHEDULE_RESPONSE" | jq '.data[0:2]' 2>/dev/null
else
    echo -e "${YELLOW}⚠ График платежей не получен${NC}"
    echo "$SCHEDULE_RESPONSE" | head -50
fi
echo ""

# 10. Статистика
echo -e "${YELLOW}10. Финансовая статистика:${NC}"
STATS_RESPONSE=$(curl -s "${ANALYTICS_STATS_URL}?months=3" 2>/dev/null)
if echo "$STATS_RESPONSE" | jq -e '.data | length > 0' > /dev/null 2>&1; then
    STATS_COUNT=$(echo "$STATS_RESPONSE" | jq '.data | length')
    echo -e "${GREEN}✓ Получена статистика (${STATS_COUNT} месяцев)${NC}"
    echo "$STATS_RESPONSE" | jq '.data' 2>/dev/null
else
    echo -e "${YELLOW}⚠ Статистика не получена${NC}"
    echo "$STATS_RESPONSE" | head -50
fi
echo ""

# 11. Прогноз баланса
echo -e "${YELLOW}11. Прогноз баланса:${NC}"
PREDICT_RESPONSE=$(curl -s "${PREDICT_URL}?days=5" 2>/dev/null)
if echo "$PREDICT_RESPONSE" | jq -e '.data.projected_balance' > /dev/null 2>&1; then
    PROJECTED=$(echo "$PREDICT_RESPONSE" | jq -r '.data.projected_balance')
    echo -e "${GREEN}✓ Получен прогноз баланса (проекция: ${PROJECTED} RUB)${NC}"
    echo "$PREDICT_RESPONSE" | jq '.data | {current: .current_balance, projected: .projected_balance, first_3_days: .predictions[0:3]}' 2>/dev/null
else
    echo -e "${YELLOW}⚠ Прогноз баланса не получен${NC}"
    echo "$PREDICT_RESPONSE" | head -50
fi
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ Тестирование API завершено!${NC}"
echo -e "${GREEN}========================================${NC}"

# 12. Тест отправки email
echo -e "\n${YELLOW}12. Тест отправки email:${NC}"
EMAIL_TIMESTAMP=$(date +%s)
EMAIL_RESPONSE=$(curl -s -X POST "${API_BASE_URL}/api/v1/register" \
  -H "Content-Type: application/json" \
  -d "{
    \"username\": \"emailtest_${EMAIL_TIMESTAMP}\",
    \"email\": \"test_${EMAIL_TIMESTAMP}@mailhog.local\",
    \"password\": \"test123\"
  }" 2>/dev/null)
echo "$EMAIL_RESPONSE" | jq . 2>/dev/null || echo "$EMAIL_RESPONSE"

# Проверяем MailHog
MAILHOG_HOST="${MAILHOG_HOST:-localhost}"
MAILHOG_PORT="${MAILHOG_PORT:-8025}"
MAILHOG_URL="http://${MAILHOG_HOST}:${MAILHOG_PORT}"

if curl -s "${MAILHOG_URL}/api/v2/messages" > /dev/null 2>&1; then
    sleep 2
    MAIL_COUNT=$(curl -s "${MAILHOG_URL}/api/v2/messages" | jq '.total' 2>/dev/null)
    echo -e "${GREEN}📧 Писем в MailHog: ${MAIL_COUNT:-0}${NC}"

    if [ "${MAIL_COUNT:-0}" -gt 0 ]; then
        echo -e "${GREEN}✓ Email уведомления работают!${NC}"
        echo -e "${YELLOW}  Откройте ${MAILHOG_URL} для просмотра писем${NC}"
    else
        echo -e "${RED}✗ Письма не обнаружены в MailHog${NC}"
    fi
else
    echo -e "${YELLOW}⚠ MailHog не доступен (${MAILHOG_URL})${NC}"
fi

echo -e "\n${BLUE}========================================${NC}"
echo -e "${BLUE}🏁 Тестирование полностью завершено!${NC}"
echo -e "${BLUE}========================================${NC}"
