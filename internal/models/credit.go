package models

import "time"

type Credit struct {
    ID             string    `json:"id" db:"id"`
    UserID         string    `json:"user_id" db:"user_id"`
    AccountID      string    `json:"account_id" db:"account_id"`
    Amount         float64   `json:"amount" db:"amount"`
    InterestRate   float64   `json:"interest_rate" db:"interest_rate"`
    MonthlyPayment float64   `json:"monthly_payment" db:"monthly_payment"`
    TermMonths     int       `json:"term_months" db:"term_months"`
    Status         string    `json:"status" db:"status"`
    CreatedAt      time.Time `json:"created_at" db:"created_at"`
}

type CreateCreditRequest struct {
    AccountID  string  `json:"account_id"`
    Amount     float64 `json:"amount"`
    TermMonths int     `json:"term_months"`
}

type PaymentScheduleResponse struct {
    CreditID      string  `json:"credit_id"`
    PaymentNumber int     `json:"payment_number"`
    DueDate       string  `json:"due_date"`
    AmountDue     float64 `json:"amount_due"`
    PrincipalDue  float64 `json:"principal_due"`
    InterestDue   float64 `json:"interest_due"`
    Status        string  `json:"status"`
}

type AnalyticsResponse struct {
    Month         string  `json:"month"`
    TotalIncome   float64 `json:"total_income"`
    TotalExpense  float64 `json:"total_expense"`
    BalanceChange float64 `json:"balance_change"`
}

type PredictionResponse struct {
    AccountID   string    `json:"account_id"`
    Days        int       `json:"days"`
    Predictions []float64 `json:"predictions"`
    CurrentBalance float64 `json:"current_balance"`
    ProjectedBalance float64 `json:"projected_balance"`
}
