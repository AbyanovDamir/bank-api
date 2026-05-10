#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}=== Bank API Quick Test ===${NC}\n"

# Test 1: Health
echo -n "Health check: "
HEALTH_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/health)
if [ "$HEALTH_RESPONSE" = "200" ]; then
    echo -e "${GREEN}✓ OK${NC}"
else
    echo -e "${RED}✗ Failed (HTTP $HEALTH_RESPONSE)${NC}"
fi

# Test 2: Register
echo -n "Registration: "
REGISTER_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:8080/api/v1/register \
  -H "Content-Type: application/json" \
  -d '{"username":"quick","email":"quick@test.com","password":"123"}')
if [ "$REGISTER_RESPONSE" = "201" ] || [ "$REGISTER_RESPONSE" = "200" ]; then
    echo -e "${GREEN}✓ OK${NC}"
else
    echo -e "${RED}✗ Failed (HTTP $REGISTER_RESPONSE)${NC}"
fi

# Test 3: Login
echo -n "Login: "
LOGIN_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:8080/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{"username":"quick","password":"123"}')
if [ "$LOGIN_RESPONSE" = "200" ]; then
    echo -e "${GREEN}✓ OK${NC}"
else
    echo -e "${RED}✗ Failed (HTTP $LOGIN_RESPONSE)${NC}"
fi

# Test 4: Accounts
echo -n "Get accounts: "
ACCOUNTS_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/v1/secure/accounts)
if [ "$ACCOUNTS_RESPONSE" = "200" ]; then
    echo -e "${GREEN}✓ OK${NC}"
else
    echo -e "${RED}✗ Failed (HTTP $ACCOUNTS_RESPONSE)${NC}"
fi

echo -e "\n${GREEN}=== Done ===${NC}"
