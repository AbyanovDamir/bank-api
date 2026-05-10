package service

import (
    "fmt"
    "github.com/go-mail/mail/v2"
    "github.com/sirupsen/logrus"
)

type EmailService struct {
    dialer *mail.Dialer
    from   string
}

func NewEmailService() *EmailService {
    dialer := mail.NewDialer("mailhog", 1025, "", "")
    return &EmailService{
        dialer: dialer,
        from:   "noreply@bankapi.com",
    }
}

func (s *EmailService) SendWelcomeEmail(to, name string) error {
    m := mail.NewMessage()
    m.SetHeader("From", s.from)
    m.SetHeader("To", to)
    m.SetHeader("Subject", "Welcome to Bank API!")
    
    body := fmt.Sprintf(`
        <h1>Welcome %s!</h1>
        <p>Thank you for registering with Bank API.</p>
        <p>You can now use our services:</p>
        <ul>
            <li>Create bank accounts</li>
            <li>Issue virtual cards</li>
            <li>Apply for credits</li>
            <li>Make transfers</li>
        </ul>
        <br>
        <p>Best regards,<br>Bank API Team</p>
    `, name)
    
    m.SetBody("text/html", body)
    
    if err := s.dialer.DialAndSend(m); err != nil {
        logrus.WithError(err).Error("Failed to send welcome email")
        return err
    }
    
    logrus.WithField("to", to).Info("Welcome email sent successfully")
    return nil
}
