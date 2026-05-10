package main

import (
    "database/sql"
    "encoding/json"
    "fmt"
    "net/http"
    "time"
    "github.com/gorilla/mux"
    _ "github.com/lib/pq"
    "github.com/sirupsen/logrus"
)

type HealthResponse struct {
    Status    string `json:"status"`
    Timestamp string `json:"timestamp"`
    Database  string `json:"database"`
}

func main() {
    // Подключение к PostgreSQL
    connStr := "host=localhost port=5433 user=postgres password=postgres dbname=bankdb sslmode=disable"
    db, err := sql.Open("postgres", connStr)
    if err != nil {
        logrus.Warn("Database connection warning:", err)
    } else {
        defer db.Close()
        if err := db.Ping(); err != nil {
            logrus.Warn("Database ping failed:", err)
        } else {
            logrus.Info("Database connected successfully")
        }
    }
    
    r := mux.NewRouter()
    
    // Health check endpoint
    r.HandleFunc("/api/health", func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json")
        
        // Проверка базы данных
        dbStatus := "connected"
        if db != nil {
            if err := db.Ping(); err != nil {
                dbStatus = "disconnected"
            }
        } else {
            dbStatus = "not_configured"
        }
        
        response := HealthResponse{
            Status:    "ok",
            Timestamp: time.Now().Format(time.RFC3339),
            Database:  dbStatus,
        }
        json.NewEncoder(w).Encode(response)
    }).Methods("GET")
    
    // Простой тестовый endpoint
    r.HandleFunc("/api/v1/test", func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json")
        json.NewEncoder(w).Encode(map[string]string{
            "message": "Bank API is working!",
            "version": "1.0.0",
        })
    }).Methods("GET")
    
    port := "8080"
    logrus.WithField("port", port).Info("Bank API server started")
    logrus.Info("Available endpoints:")
    logrus.Info("  GET http://localhost:8080/api/health")
    logrus.Info("  GET http://localhost:8080/api/v1/test")
    
    if err := http.ListenAndServe(":"+port, r); err != nil {
        logrus.Fatal(err)
    }
}
