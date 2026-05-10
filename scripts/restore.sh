#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

BACKUP_DIR="./backups"

echo -e "${YELLOW}=== Восстановление базы данных Bank API ===${NC}"

BACKUPS=($(ls -t ${BACKUP_DIR}/bankapi_backup_*.sql.gz 2>/dev/null))

if [ ${#BACKUPS[@]} -eq 0 ]; then
    echo -e "${RED}✗ Бэкапы не найдены${NC}"
    exit 1
fi

echo -e "${YELLOW}Доступные бэкапы:${NC}"
for i in "${!BACKUPS[@]}"; do
    SIZE=$(du -h ${BACKUPS[$i]} | cut -f1)
    echo "  $((i+1)). $(basename ${BACKUPS[$i]}) (${SIZE})"
done

echo -e "\n${YELLOW}Выберите бэкап для восстановления (1-${#BACKUPS[@]}):${NC}"
read -r choice

if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#BACKUPS[@]} ]; then
    SELECTED="${BACKUPS[$((choice-1))]}"
    echo -e "${YELLOW}Выбран: $(basename ${SELECTED})${NC}"
else
    echo -e "${RED}✗ Неверный выбор${NC}"
    exit 1
fi

echo -e "${RED}ВНИМАНИЕ: Это перезапишет текущую базу данных!${NC}"
echo -e "${YELLOW}Продолжить? (yes/no):${NC}"
read -r confirm

if [ "$confirm" != "yes" ]; then
    echo -e "${YELLOW}Операция отменена${NC}"
    exit 0
fi

if docker ps | grep -q bank-postgres; then
    gunzip -c ${SELECTED} | docker exec -i bank-postgres psql -U postgres -d bankdb 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ База данных восстановлена${NC}"
    else
        echo -e "${RED}✗ Ошибка восстановления${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ Контейнер bank-postgres не найден${NC}"
    exit 1
fi
