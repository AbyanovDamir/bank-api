package service

import (
    "math"
    "time"
    "bank-api/internal/models"
)

type CreditService struct{}

func NewCreditService() *CreditService {
    return &CreditService{}
}

func (s *CreditService) CalculateAnnuityPayment(amount float64, annualRate float64, months int) float64 {
    monthlyRate := annualRate / 12 / 100
    if monthlyRate == 0 {
        return amount / float64(months)
    }
    numerator := monthlyRate * math.Pow(1+monthlyRate, float64(months))
    denominator := math.Pow(1+monthlyRate, float64(months)) - 1
    return amount * (numerator / denominator)
}

func (s *CreditService) GeneratePaymentSchedule(creditID string, amount float64, annualRate float64, months int) []models.PaymentScheduleResponse {
    monthlyPayment := s.CalculateAnnuityPayment(amount, annualRate, months)
    monthlyRate := annualRate / 12 / 100
    remainingDebt := amount
    schedules := []models.PaymentScheduleResponse{}
    
    for i := 1; i <= months; i++ {
        interestPayment := remainingDebt * monthlyRate
        principalPayment := monthlyPayment - interestPayment
        
        if principalPayment > remainingDebt {
            principalPayment = remainingDebt
        }
        
        schedule := models.PaymentScheduleResponse{
            CreditID:      creditID,
            PaymentNumber: i,
            DueDate:       time.Now().AddDate(0, i, 0).Format("2006-01-02"),
            AmountDue:     math.Round(monthlyPayment*100) / 100,
            PrincipalDue:  math.Round(principalPayment*100) / 100,
            InterestDue:   math.Round(interestPayment*100) / 100,
            Status:        "pending",
        }
        schedules = append(schedules, schedule)
        remainingDebt -= principalPayment
    }
    
    return schedules
}
