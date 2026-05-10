#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Функция для определения правильного URL
get_endpoint_url() {
    local endpoint=$1
    local test_urls=(
        "http://localhost:8080/api/v1${endpoint}"
        "http://localhost:8080/api/v1/secure${endpoint}"
        "http://localhost:8080${endpoint}"
    )
    
    for url in "${test_urls[@]}"; do
        if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "200\|201\|404"; then
            # Проверяем, что эндпоинт существует (не 404)
            if [ "$(curl -s -o /dev/null -w "%{http_code}" "$url")" != "404" ]; then
                echo "$url"
                return 0
            fi
        fi
    done
    echo "http://localhost:8080/api/v1${endpoint}"  # default
}

# Определяем URL для разных эндпоинтов
CREDIT_SCHEDULE_URL=$(get_endpoint_url "/credits/credit_123/schedule")
ANALYTICS_STATS_URL=$(get_endpoint_url "/analytics/stats")
PREDICT_URL=$(get_endpoint_url "/accounts/acc_123/predict")

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Bank API - Универсальное тестирование${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "${YELLOW}Определенные URL:${NC}"
echo "  График платежей: $CREDIT_SCHEDULE_URL"
echo "  Статистика: $ANALYTICS_STATS_URL"
echo "  Прогноз: $PREDICT_URL"
echo ""

# 1. График платежей
echo -e "${YELLOW}1. График платежей:${NC}"
curl -s "$CREDIT_SCHEDULE_URL" | jq '.data | length' 2>/dev/null | xargs echo "Количество платежей:"
curl -s "$CREDIT_SCHEDULE_URL" | jq '.data[0]' 2>/dev/null
echo ""

# 2. Статистика
echo -e "${YELLOW}2. Финансовая статистика:${NC}"
curl -s "$ANALYTICS_STATS_URL?months=3" | jq '.data | length' 2>/dev/null | xargs echo "Месяцев:"
curl -s "$ANALYTICS_STATS_URL?months=3" | jq '.data[0]' 2>/dev/null
echo ""

# 3. Прогноз
echo -e "${YELLOW}3. Прогноз баланса:${NC}"
curl -s "$PREDICT_URL?days=5" | jq '.data | {current: .current_balance, projected: .projected_balance}' 2>/dev/null
echo ""

echo -e "${GREEN}✅ Тестирование завершено!${NC}"
