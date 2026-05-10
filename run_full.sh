#!/bin/bash

export DB_HOST=localhost
export DB_PORT=5433
export DB_USER=postgres
export DB_PASSWORD=postgres
export DB_NAME=bankdb
export JWT_SECRET=super-secret-jwt-key-2024
export HMAC_SECRET=hmac-secret-key-2024
export SMTP_HOST=localhost
export SMTP_PORT=1025

# Запуск с full версией (если есть)
go run cmd/main.go
