# 🏦 Bank API Service

## 📋 Описание проекта

**Bank API Service** — это backend-приложение для управления банковскими услугами (счета, карты, переводы, кредиты) с финансовой аналитикой и прогнозированием баланса. Сервис обеспечивает безопасный доступ через JWT и отправку email-уведомлений.

---

### 🎯 Основные возможности

| Функция | Описание |
|---------|----------|
| 🔐 **JWT аутентификация** | Регистрация и вход с получением токена |
| 💰 **Управление счетами** | Создание счетов, пополнение, просмотр баланса |
| 💳 **Виртуальные карты** | Генерация карт с валидным номером (алгоритм Луна) |
| 🔄 **Переводы** | Переводы между счетами |
| 📊 **Кредиты** | Оформление кредитов с аннуитетными платежами |
| 📅 **График платежей** | Детальный график на 12 месяцев |
| 📈 **Финансовая аналитика** | Статистика доходов/расходов за период |
| 🔮 **Прогноз баланса** | Прогнозирование баланса на N дней |
| 📧 **Email уведомления** | Отправка welcome-писем через SMTP (MailHog) |
| 🐳 **Docker поддержка** | Контейнеризация (API + PostgreSQL + MailHog) |

---

## 🛠 Технологический стек

| Компонент | Технология | Версия |
|-----------|------------|--------|
| **Язык** | Go | 1.21+ |
| **База данных** | PostgreSQL | 17 |
| **Маршрутизация** | gorilla/mux | 1.8.1 |
| **Аутентификация** | JWT (golang-jwt) | v5 |
| **Хеширование** | bcrypt | — |
| **Email** | go-mail/mail | v2 |
| **Логирование** | logrus | 1.9.4 |
| **Тестирование** | curl + jq | — |
| **Контейнеризация** | Docker + Docker Compose | 3.8 |

---

## 📁 Структура проекта

```
bank-api/
├── 📁 backups/ # Бэкапы базы данных
├── 📁 bank-files/ # Сгенерированные файлы
├── 📁 cmd/ # Точка входа
│ ├── main.go # Основной сервер
│ ├── main.go.backup # Резервная копия
│ └── main_simple.go # Упрощенная версия
├── 📁 configs/ # Конфигурационные файлы
├── 📁 docker/ # Docker файлы
├── 📁 docs/ # Документация
├── 📁 internal/ # Внутренний код
│ ├── 📁 handler/ # HTTP обработчики
│ ├── 📁 middleware/ # JWT аутентификация
│ ├── 📁 models/ # Модели данных
│ ├── 📁 repository/ # Слой доступа к данным
│ ├── 📁 scheduler/ # Планировщик задач
│ ├── 📁 service/ # Бизнес-логика
│ └── 📁 utils/ # Утилиты
├── 📁 logs/ # Логи приложения
├── 📁 migrations/ # SQL миграции
├── 📁 pkg/ # Публичные пакеты
├── 📁 scripts/ # Вспомогательные скрипты
├── check_mail.sh # Просмотр писем
├── cleanup.sh # Полная очистка
├── docker-compose.yml # Docker Compose
├── Dockerfile # Docker образ
├── go.mod # Go модуль
├── go.sum # Go checksum
├── Makefile # Автоматизация
├── quick_test.sh # Быстрое тестирование
├── run.sh # Локальный запуск
├── start.sh # Универсальный запуск
├── test_all.sh # Полное тестирование
├── test_email.sh # Тест email
├── test_new_endpoints.sh # Тест новых эндпоинтов
├── test_universal.sh # Универсальный тест
├── tree.txt # Структура проекта
└── README.md # Документация

```

---

### Реализованные функции

| № | Функция | Статус |
|---|---------|--------|
| 1 | Регистрация и аутентификация (JWT) | ✅ |
| 2 | Создание банковского счета | ✅ |
| 3 | Просмотр счетов | ✅ |
| 4 | Перевод между счетами | ✅ |
| 5 | Выпуск виртуальной карты | ✅ |
| 6 | Оформление кредита (аннуитет) | ✅ |
| 7 | График платежей на 12 месяцев | ✅ |
| 8 | Финансовая статистика | ✅ |
| 9 | Прогноз баланса на N дней | ✅ |
| 10 | Email-уведомления (MailHog) | ✅ |
| 11 | Health check endpoint | ✅ |

---

## 🔌 API Endpoints

| Метод | Endpoint | Описание | Аутентификация |
|-------|----------|----------|----------------|
| GET | `/api/health` | Health check | Нет |
| POST | `/api/v1/register` | Регистрация | Нет |
| POST | `/api/v1/login` | Вход (JWT) | Нет |
| POST | `/api/v1/accounts` | Создать счёт | JWT |
| GET | `/api/v1/accounts` | Список счетов | JWT |
| POST | `/api/v1/transfer` | Перевод | JWT |
| POST | `/api/v1/cards` | Выпустить карту | JWT |
| POST | `/api/v1/credits` | Оформить кредит | JWT |
| GET | `/api/v1/credits/{id}/schedule` | График платежей | Нет |
| GET | `/api/v1/analytics/stats` | Статистика | Нет |
| GET | `/api/v1/accounts/{id}/predict` | Прогноз баланса | Нет |

---

## 📥 Запуск проекта и тестирование

### Требования

- Docker (20.10+), Docker Compose (2.0+)
- Go 1.21+ (для локальной сборки)
- Make (опционально)

---

### Запуск проекта и тестирование

```bash
git clone https://github.com/AbyanovDamir/bank-api.git
cd bank-api
cp .env.example .env

make generate-secrets 
docker compose up -d --build


```

### Запуск всех тестов

```bash
# Универсальный тест (рекомендуется)
sudo chmod +x test_all.sh
sudo ./test_all.sh

# Быстрая проверка
sudo chmod +x quick_test.sh
sudo ./quick_test.sh


# Тест email уведомлений
sudo chmod +x test_email.sh
sudo ./test_email.sh

# Тест новых эндпоинтов
sudo chmod +x test_new_endpoints.sh
sudo ./test_new_endpoints.sh

# Проверка MailHog
sudo chmod +x test_email_direct.sh
sudo ./test_email_direct.sh

```


### Просмотр email уведомлений (MailHog)


```bash
# Веб-интерфейс (открыть в браузере)
http://localhost:8025

# Количество писем
curl -s http://localhost:8025/api/v2/messages | jq '.total'

# Список всех писем
curl -s http://localhost:8025/api/v2/messages | jq '.items[] | {to: .Content.Headers.To[0], subject: .Content.Headers.Subject[0]}'

# Очистка всех писем
curl -X DELETE http://localhost:8025/api/v1/messages

```

### Мониторинг
```bash
# Статус всех сервисов
make monitor
docker compose ps

# Health check API
make health
curl http://localhost:8080/api/health

# Просмотр логов
make logs
docker compose logs -f
docker compose logs app --tail=50

# Использование ресурсов
docker stats

```
### Docker-команды 
```bash
docker compose ps                         # список контейнеров
docker compose logs -f app                # логи API
docker compose logs mailhog --tail=50     # логи MailHog
docker compose exec app sh                # войти в контейнер API
docker compose exec postgres psql -U postgres -d bankdb  # PSQL
```

### Все команды Make

```bash
make help              # Показать все команды

# Docker-оркестрация
make docker-up         # Запуск всех сервисов
make docker-down       # Остановка всех сервисов
make docker-build      # Пересборка образа
make logs              # Логи в реальном времени
make monitor           # Статус контейнеров + health

# Локальная разработка
make run               # go run cmd/main.go
make build             # Сборка бинарника
make test              # go test ./...
make clean             # Удаление артефактов
make deps              # go mod tidy

# Тестирование
make quick-test        # Быстрая проверка API
make full-test         # Полное тестирование (test_all.sh)
make email-test        # Тест email-уведомлений

# Утилиты
make health            # curl /api/health
make backup            # Бэкап БД (скрипт backup.sh)
make restore           # Восстановление БД
make generate-secrets  # Генерация JWT_SECRET и HMAC_SECRET
```

## 📥  Полный перезапуск 

```bash

# Остановка всех контейнеров
docker compose down

# Удаление томов (очистка БД)
docker compose down -v

# Пересборка образов
docker compose build --no-cache

# Запуск
docker compose up -d

# Проверка
sleep 10
docker compose ps
curl http://localhost:8080/api/health

```

## 📥 Полная очистка 

```bash
# Остановка всех контейнеров
docker compose down -v

# Удаление всех образов
docker rmi bank-api-app 2>/dev/null || true

# Очистка логов
rm -rf logs/*.log

# Очистка бэкапов
rm -rf backups/*.sql.gz

# Очистка временных файлов
rm -rf bank-files/*

# Очистка артефактов Go
go clean -cache -modcache

# Очистка Docker системы
docker system prune -a -f

```

#### Заключение

```
Bank API Service — полностью рабочий проект с современным стеком (Go + PostgreSQL + Docker). Он реализует основные банковские операции, финансовую аналитику и email-уведомления.

```
Ключевые достижения

```
✅ Полнофункциональный банковский API – счета, карты, переводы, кредиты
✅ Аннуитетные платежи + график на 12 месяцев
✅ Финансовая статистика и прогноз баланса (математическая модель)
✅ Email-уведомления через MailHog (SMTP)
✅ JWT-безопасность
✅ Полная контейнеризация (Docker Compose)
✅ Универсальный тест (test_all.sh) с покрытием 12 сценариев
✅ Полная документация и команды для перезапуска/очистки


```