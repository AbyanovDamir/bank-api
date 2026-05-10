package models

import "time"

type Transaction struct {
    ID          string     `json:"id" db:"id"`
    FromAccountID *string  `json:"from_account_id" db:"from_account_id"`
    ToAccountID   *string  `json:"to_account_id" db:"to_account_id"`
    Amount      float64    `json:"amount" db:"amount"`
    Type        string     `json:"type" db:"type"`
    Status      string     `json:"status" db:"status"`
    CreatedAt   time.Time  `json:"created_at" db:"created_at"`
}
