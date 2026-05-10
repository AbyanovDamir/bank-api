package service

import (
    "bank-api/internal/models"
    "bank-api/internal/utils"
    "github.com/google/uuid"
    "github.com/sirupsen/logrus"
)

type AuthService struct {
    emailService *EmailService
}

func NewAuthService() *AuthService {
    return &AuthService{
        emailService: NewEmailService(),
    }
}

func (s *AuthService) Register(req *models.RegisterRequest) (*models.AuthResponse, error) {
    userID := uuid.New().String()
    token, _ := utils.GenerateJWTToken(userID)
    
    response := &models.AuthResponse{
        Token: token,
        User: &models.User{
            ID:       userID,
            Username: req.Username,
            Email:    req.Email,
        },
    }
    
    // Отправляем приветственное письмо
    go func() {
        if err := s.emailService.SendWelcomeEmail(req.Email, req.Username); err != nil {
            logrus.WithError(err).Warn("Failed to send welcome email")
        } else {
            logrus.WithField("to", req.Email).Info("Welcome email sent")
        }
    }()
    
    return response, nil
}

func (s *AuthService) Login(req *models.LoginRequest) (*models.AuthResponse, error) {
    token, _ := utils.GenerateJWTToken(uuid.New().String())
    return &models.AuthResponse{
        Token: token,
        User: &models.User{
            ID:       uuid.New().String(),
            Username: "user",
            Email:    req.Email,
        },
    }, nil
}
