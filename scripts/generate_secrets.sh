#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}=== Генерация секретов для Bank API ===${NC}"

# Функция генерации случайного ключа
generate_secret() {
    local length=$1
    tr -dc 'A-Za-z0-9!@#$%^&*()_+' < /dev/urandom 2>/dev/null | head -c $length
}

# Создание бэкапа старого .env
if [ -f .env ]; then
    BACKUP_FILE=".env.backup.$(date +%Y%m%d_%H%M%S)"
    cp .env $BACKUP_FILE
    echo -e "${GREEN}✓ Создан бэкап: $BACKUP_FILE${NC}"
fi

# Генерация новых секретов
JWT_SECRET=$(generate_secret 32)
HMAC_SECRET=$(generate_secret 32)
DB_PASSWORD=$(generate_secret 16)

# Создание .env файла
echo "# Database Configuration" > .env
echo "DB_HOST=localhost" >> .env
echo "DB_PORT=5432" >> .env
echo "DB_USER=postgres" >> .env
echo "DB_PASSWORD=${DB_PASSWORD}" >> .env
echo "DB_NAME=bankdb" >> .env
echo "DB_SSL_MODE=disable" >> .env
echo "" >> .env
echo "# JWT Authentication" >> .env
echo "JWT_SECRET=${JWT_SECRET}" >> .env
echo "" >> .env
echo "# HMAC Security" >> .env
echo "HMAC_SECRET=${HMAC_SECRET}" >> .env
echo "" >> .env
echo "# SMTP Configuration" >> .env
echo "SMTP_HOST=localhost" >> .env
echo "SMTP_PORT=1025" >> .env
echo "SMTP_USER=" >> .env
echo "SMTP_PASS=" >> .env
echo "SMTP_FROM=noreply@bankapi.com" >> .env
echo "" >> .env
echo "# Server Configuration" >> .env
echo "SERVER_PORT=8080" >> .env
echo "LOG_LEVEL=info" >> .env

echo -e "${GREEN}✓ Секреты сгенерированы:${NC}"
echo "  JWT_SECRET: ${JWT_SECRET}"
echo "  HMAC_SECRET: ${HMAC_SECRET}"
echo "  DB_PASSWORD: ${DB_PASSWORD}"
echo ""
echo -e "${GREEN}✅ Готово!${NC}"
