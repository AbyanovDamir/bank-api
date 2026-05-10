package utils

import (
    "crypto/hmac"
    "crypto/sha256"
    "encoding/hex"
)

type CryptoUtil struct{}

func NewCryptoUtil() *CryptoUtil {
    return &CryptoUtil{}
}

func (c *CryptoUtil) ComputeHMAC(data string) string {
    h := hmac.New(sha256.New, []byte("test-secret"))
    h.Write([]byte(data))
    return hex.EncodeToString(h.Sum(nil))
}
