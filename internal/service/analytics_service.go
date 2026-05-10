package service

import (
    "math"
    "time"
    "bank-api/internal/models"
)

type AnalyticsService struct{}

func NewAnalyticsService() *AnalyticsService {
    return &AnalyticsService{}
}

func (s *AnalyticsService) GetMonthlyStats(months int) []models.AnalyticsResponse {
    stats := []models.AnalyticsResponse{}
    now := time.Now()
    
    for i := months - 1; i >= 0; i-- {
        monthDate := now.AddDate(0, -i, 0)
        month := monthDate.Format("2006-01")
        
        income := 50000 + float64(i*1000)
        expense := 30000 + float64(i*500)
        
        stats = append(stats, models.AnalyticsResponse{
            Month:         month,
            TotalIncome:   math.Round(income*100) / 100,
            TotalExpense:  math.Round(expense*100) / 100,
            BalanceChange: math.Round((income-expense)*100) / 100,
        })
    }
    
    return stats
}

func (s *AnalyticsService) PredictBalance(accountID string, days int, currentBalance float64) models.PredictionResponse {
    predictions := make([]float64, days)
    avgDailyChange := 100.0
    volatility := 50.0
    
    for i := 0; i < days; i++ {
        randomChange := avgDailyChange + (float64(i%10)-5)*volatility/10
        if i > 0 {
            predictions[i] = predictions[i-1] + randomChange
        } else {
            predictions[i] = currentBalance + randomChange
        }
        if predictions[i] < 0 {
            predictions[i] = 0
        }
        predictions[i] = math.Round(predictions[i]*100) / 100
    }
    
    return models.PredictionResponse{
        AccountID:        accountID,
        Days:             days,
        Predictions:      predictions,
        CurrentBalance:   currentBalance,
        ProjectedBalance: predictions[days-1],
    }
}
