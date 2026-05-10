package handler

import (
    "encoding/json"
    "net/http"
    "github.com/gorilla/mux"
    "bank-api/internal/service"
)

type CreditHandler struct {
    creditService *service.CreditService
}

func NewCreditHandler() *CreditHandler {
    return &CreditHandler{
        creditService: service.NewCreditService(),
    }
}

func (h *CreditHandler) GetSchedule(w http.ResponseWriter, r *http.Request) {
    vars := mux.Vars(r)
    creditID := vars["id"]
    
    amount := 100000.0
    interestRate := 12.5
    termMonths := 12
    
    schedules := h.creditService.GeneratePaymentSchedule(creditID, amount, interestRate, termMonths)
    
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(map[string]interface{}{
        "success": true,
        "data":    schedules,
    })
}
