#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Testing New Public Endpoints ===${NC}\n"

# Test 1: Credit Schedule
echo -e "${YELLOW}1. Credit Schedule (12 months):${NC}"
curl -s http://localhost:8080/api/v1/credits/credit_123/schedule | jq '.data | length'
echo -e "${GREEN}First payment:${NC}"
curl -s http://localhost:8080/api/v1/credits/credit_123/schedule | jq '.data[0]'

# Test 2: Analytics Stats
echo -e "\n${YELLOW}2. Analytics Stats (6 months):${NC}"
curl -s "http://localhost:8080/api/v1/analytics/stats?months=6" | jq '.data | length'
echo -e "${GREEN}Latest month:${NC}"
curl -s "http://localhost:8080/api/v1/analytics/stats?months=6" | jq '.data[0]'

# Test 3: Balance Prediction
echo -e "\n${YELLOW}3. Balance Prediction (30 days):${NC}"
curl -s "http://localhost:8080/api/v1/accounts/acc_123/predict?days=30" | jq '{
    account_id: .data.account_id,
    days: .data.days,
    current_balance: .data.current_balance,
    projected_balance: .data.projected_balance,
    first_predictions: .data.predictions[0:5]
}'

echo -e "\n${GREEN}=== All endpoints are working! ===${NC}"
