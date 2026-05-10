package handler

import (
    "encoding/json"
    "net/http"
    "strconv"
    "github.com/gorilla/mux"
    "bank-api/internal/service"
)

type AnalyticsHandler struct {
    analyticsService *service.AnalyticsService
}

func NewAnalyticsHandler() *AnalyticsHandler {
    return &AnalyticsHandler{
        analyticsService: service.NewAnalyticsService(),
    }
}

func (h *AnalyticsHandler) GetStats(w http.ResponseWriter, r *http.Request) {
    months := 6
    if m := r.URL.Query().Get("months"); m != "" {
        if val, err := strconv.Atoi(m); err == nil && val > 0 && val <= 12 {
            months = val
        }
    }
    
    stats := h.analyticsService.GetMonthlyStats(months)
    
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(map[string]interface{}{
        "success": true,
        "data":    stats,
    })
}

func (h *AnalyticsHandler) PredictBalance(w http.ResponseWriter, r *http.Request) {
    vars := mux.Vars(r)
    accountID := vars["id"]
    
    days := 30
    if d := r.URL.Query().Get("days"); d != "" {
        if val, err := strconv.Atoi(d); err == nil && val > 0 && val <= 365 {
            days = val
        }
    }
    
    currentBalance := 10000.0
    prediction := h.analyticsService.PredictBalance(accountID, days, currentBalance)
    
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(map[string]interface{}{
        "success": true,
        "data":    prediction,
    })
}
