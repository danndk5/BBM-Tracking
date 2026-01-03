package services

import (
	"bbm-tracking/internal/models"
	"bbm-tracking/internal/repository"
	"bbm-tracking/internal/utils"
	"errors"

	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	userRepo *repository.UserRepository
}

func NewAuthService(userRepo *repository.UserRepository) *AuthService {
	return &AuthService{userRepo: userRepo}
}

type LoginRequest struct {
	NoPekerja string `json:"no_pekerja"` // CHANGED from username
	Password  string `json:"password"`
}

type RegisterRequest struct {
	NoPekerja string `json:"no_pekerja"` // CHANGED from username
	Password  string `json:"password"`
	Role      string `json:"role"`
	Nama      string `json:"nama"`
}

type AuthResponse struct {
	Token string      `json:"token"`
	User  models.User `json:"user"`
}

func (s *AuthService) Login(req LoginRequest) (*AuthResponse, error) {
	user, err := s.userRepo.FindByNoPekerja(req.NoPekerja)
	if err != nil {
		return nil, errors.New("invalid credentials")
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password)); err != nil {
		return nil, errors.New("invalid credentials")
	}

	token, err := utils.GenerateToken(user.ID, user.Role)
	if err != nil {
		return nil, err
	}

	return &AuthResponse{
		Token: token,
		User:  *user,
	}, nil
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

	return &AuthResponse{
		Token: token,
		User:  *user,
	}, nil
}
