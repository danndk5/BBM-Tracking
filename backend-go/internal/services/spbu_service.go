package services

import (
	"bbm-tracking/internal/models"
	"bbm-tracking/internal/repository"
)

type SPBUService struct {
	spbuRepo *repository.SPBURepository
}

func NewSPBUService(spbuRepo *repository.SPBURepository) *SPBUService {
	return &SPBUService{spbuRepo: spbuRepo}
}

type CreateSPBURequest struct {
	Nama      string   `json:"nama"`
	Alamat    *string  `json:"alamat"`
	Latitude  *float64 `json:"latitude"`
	Longitude *float64 `json:"longitude"`
	Radius    *float64 `json:"radius"` // Opsional, default 100m
}

func (s *SPBUService) CreateSPBU(req CreateSPBURequest) (*models.SPBU, error) {
	spbu := &models.SPBU{
		Nama:      req.Nama,
		Alamat:    req.Alamat,
		Latitude:  req.Latitude,
		Longitude: req.Longitude,
	}

	if req.Radius != nil {
		spbu.Radius = *req.Radius
	} else {
		spbu.Radius = 100 // Default 100 meter
	}

	if err := s.spbuRepo.Create(spbu); err != nil {
		return nil, err
	}

	return spbu, nil
}

func (s *SPBUService) GetAllSPBU() ([]models.SPBU, error) {
	return s.spbuRepo.GetAll()
}
