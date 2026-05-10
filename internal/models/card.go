package models

import "time"

type Card struct {
    ID          string    `json:"id" db:"id"`
    AccountID   string    `json:"account_id" db:"account_id"`
    PanLast4    string    `json:"pan_last4" db:"pan_last4"`
    ExpiryMonth int       `json:"expiry_month" db:"expiry_month"`
    ExpiryYear  int       `json:"expiry_year" db:"expiry_year"`
    CardType    string    `json:"card_type" db:"card_type"`
    Status      string    `json:"status" db:"status"`
    CreatedAt   time.Time `json:"created_at" db:"created_at"`
}

type CreateCardRequest struct {
    AccountID string `json:"account_id"`
    CardType  string `json:"card_type"`
}
