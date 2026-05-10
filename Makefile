.PHONY: help build run test clean deps docker-build docker-up docker-down logs health monitor backup restore generate-secrets

# Цвета для вывода
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m

help:
	@echo "$(GREEN)Bank API - Доступные команды$(NC)"
	@echo ""
	@echo "Локальная разработка:"
	@echo "  make build           - Сборка бинарного файла"
	@echo "  make run             - Запуск приложения локально"
	@echo "  make test            - Запуск тестов"
	@echo "  make clean           - Очистка артефактов"
	@echo "  make deps            - Установка зависимостей"
	@echo ""
	@echo "Docker:"
	@echo "  make docker-build    - Сборка Docker образа"
	@echo "  make docker-up       - Запуск всех сервисов"
	@echo "  make docker-down     - Остановка всех сервисов"
	@echo "  make logs            - Просмотр логов"
	@echo ""
	@echo "Утилиты:"
	@echo "  make generate-secrets- Генерация секретов"
	@echo "  make monitor         - Мониторинг статуса"
	@echo "  make health          - Health check"
	@echo "  make backup          - Бэкап базы данных"
	@echo "  make restore         - Восстановление из бэкапа"
	@echo ""
	@echo "Тестирование:"
	@echo "  make quick-test      - Быстрая проверка API"
	@echo "  make full-test       - Полное тестирование"

build:
	go build -o bin/bank-api cmd/main.go

run:
	go run cmd/main.go

test:
	go test -v -cover ./...

clean:
	rm -rf bin/
	rm -rf dist/
	rm -rf logs/*.log
	rm -rf bank-files/*

deps:
	go mod download
	go mod tidy

docker-build:
	docker build -t bank-api:latest .

docker-up:
	@echo "$(YELLOW)Запуск Docker сервисов...$(NC)"
	docker compose up -d
	@echo "$(GREEN)Сервисы запущены:$(NC)"
	@echo "  API: http://localhost:8080"
	@echo "  MailHog: http://localhost:8025"
	@echo "  PostgreSQL: localhost:5432"

docker-down:
	@echo "$(YELLOW)Остановка Docker сервисов...$(NC)"
	docker compose down
	@echo "$(GREEN)Сервисы остановлены$(NC)"

logs:
	docker compose logs -f --tail=100

health:
	@curl -s http://localhost:8080/api/health | jq . 2>/dev/null || curl -s http://localhost:8080/api/health

monitor:
	@./scripts/monitor.sh

backup:
	@./scripts/backup.sh

restore:
	@./scripts/restore.sh

generate-secrets:
	@./scripts/generate_secrets.sh

quick-test:
	@./quick_test.sh

full-test:
	@./test_all.sh

new-test:
	@./test_new_endpoints.sh

email-test:
	@./test_email.sh
