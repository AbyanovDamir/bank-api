package utils

import (
    "errors"
    "os"
    "time"
    "github.com/golang-jwt/jwt/v5"
)

var jwtSecret = []byte(os.Getenv("JWT_SECRET"))

func GenerateJWTToken(userID string) (string, error) {
    secret := jwtSecret
    if len(secret) == 0 {
        secret = []byte("default-secret-key-for-development-32-chars!!")
    }
    claims := jwt.RegisteredClaims{
        Subject:   userID,
        ExpiresAt: jwt.NewNumericDate(time.Now().Add(24 * time.Hour)),
        IssuedAt:  jwt.NewNumericDate(time.Now()),
    }
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    return token.SignedString(secret)
}

func ValidateJWTToken(tokenString string) (string, error) {
    secret := jwtSecret
    if len(secret) == 0 {
        secret = []byte("default-secret-key-for-development-32-chars!!")
    }
    
    claims := &jwt.RegisteredClaims{}
    token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
        return secret, nil
    })
    if err != nil {
        return "", err
    }
    if !token.Valid {
        return "", errors.New("invalid token")
    }
    return claims.Subject, nil
}
