package handler

import (
    "encoding/json"
    "net/http"
)

type AccountHandler struct{}

func NewAccountHandler() *AccountHandler {
    return &AccountHandler{}
}

func (h *AccountHandler) CreateAccount(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusCreated)
    json.NewEncoder(w).Encode(map[string]interface{}{
        "success": true,
        "data": map[string]interface{}{
            "id":       "acc_123456",
            "balance":  0,
            "currency": "RUB",
        },
    })
}

func (h *AccountHandler) GetAccounts(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(map[string]interface{}{
        "success": true,
        "data": []map[string]interface{}{
            {"id": "acc_123456", "balance": 10000, "currency": "RUB"},
        },
    })
}
