package services

import (
	"bbm-tracking/internal/models"
	"bbm-tracking/internal/repository"
	"bbm-tracking/internal/utils"
	"errors"
	"log"

	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	userRepo *repository.UserRepository
}

func NewAuthService(userRepo *repository.UserRepository) *AuthService {
	return &AuthService{userRepo: userRepo}
}

type LoginRequest struct {
	NoPekerja string `json:"no_pekerja"`
	Password  string `json:"password"`
}

type RegisterRequest struct {
	NoPekerja string `json:"no_pekerja"`
	Password  string `json:"password"`
	Role      string `json:"role"`
	Nama      string `json:"nama"`
}

type UserResponse struct {
	ID        string `json:"id"`
	NoPekerja string `json:"no_pekerja"`
	Nama      string `json:"nama"`
	Role      string `json:"role"`
	CreatedAt string `json:"created_at"`
}

type AuthResponse struct {
	Token string       `json:"token"`
	User  UserResponse `json:"user"`
}

func (s *AuthService) Login(req LoginRequest) (*AuthResponse, error) {
	user, err := s.userRepo.FindByNoPekerja(req.NoPekerja)
	if err != nil {
		log.Printf("❌ User not found: %s", req.NoPekerja)
		return nil, errors.New("invalid credentials")
	}

	log.Printf("✅ User found: %s (ID: %s)", user.Nama, user.ID)

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password)); err != nil {
		log.Printf("❌ Password mismatch for user: %s", req.NoPekerja)
		return nil, errors.New("invalid credentials")
	}

	log.Printf("✅ Password correct")

	token, err := utils.GenerateToken(user.ID, user.Role)
	if err != nil {
		log.Printf("❌ Token generation failed: %v", err)
		return nil, err
	}

	log.Printf("✅ Token generated (length: %d)", len(token))
	log.Printf("📤 Preparing response...")
	log.Printf("   User ID: %s", user.ID)
	log.Printf("   User ID Type: %T", user.ID)
	log.Printf("   Nama: %s", user.Nama)
	log.Printf("   No Pekerja: %s", user.NoPekerja)

	// Return response WITHOUT password
	response := &AuthResponse{
		Token: token,
		User: UserResponse{
			ID:        user.ID,
			NoPekerja: user.NoPekerja,
			Nama:      user.Nama,
			Role:      user.Role,
			CreatedAt: user.CreatedAt.Format("2006-01-02T15:04:05Z07:00"),
		},
	}

	log.Printf("✅ Response prepared. User.ID in response: %s", response.User.ID)

	return response, nil
}

func (s *AuthService) Register(req RegisterRequest) (*AuthResponse, error) {
	// Check if no_pekerja already exists
	_, err := s.userRepo.FindByNoPekerja(req.NoPekerja)
	if err == nil {
		return nil, errors.New("nomor pekerja already exists")
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}

	user := &models.User{
		NoPekerja: req.NoPekerja,
		Password:  string(hashedPassword),
		Role:      req.Role,
		Nama:      req.Nama,
	}

	if err := s.userRepo.Create(user); err != nil {
		return nil, err
	}

	token, err := utils.GenerateToken(user.ID, user.Role)
	if err != nil {
		return nil, err
	}

	// Return response WITHOUT password
	return &AuthResponse{
		Token: token,
		User: UserResponse{
			ID:        user.ID,
			NoPekerja: user.NoPekerja,
			Nama:      user.Nama,
			Role:      user.Role,
			CreatedAt: user.CreatedAt.Format("2006-01-02T15:04:05Z07:00"),
		},
	}, nil
}
