#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/bankapi_backup_${TIMESTAMP}.sql"

mkdir -p ${BACKUP_DIR}

echo -e "${YELLOW}=== Бэкап базы данных Bank API ===${NC}"

if docker ps | grep -q bank-postgres; then
    docker exec bank-postgres pg_dump -U postgres bankdb > ${BACKUP_FILE} 2>/dev/null
    if [ $? -eq 0 ] && [ -s ${BACKUP_FILE} ]; then
        gzip ${BACKUP_FILE}
        echo -e "${GREEN}✓ Бэкап создан: ${BACKUP_FILE}.gz${NC}"
        ls -lh ${BACKUP_FILE}.gz
    else
        echo -e "${RED}✗ Ошибка создания бэкапа${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ Контейнер bank-postgres не найден${NC}"
    echo -e "${YELLOW}  Запустите сначала: make start-all${NC}"
    exit 1
fi
