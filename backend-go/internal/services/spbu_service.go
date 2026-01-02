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
	Nama   string  `json:"nama"`
	Alamat *string `json:"alamat"`
}

func (s *SPBUService) CreateSPBU(req CreateSPBURequest) (*models.SPBU, error) {
	spbu := &models.SPBU{
		Nama:   req.Nama,
		Alamat: req.Alamat,
	}

	if err := s.spbuRepo.Create(spbu); err != nil {
		return nil, err
	}

	return spbu, nil
}

func (s *SPBUService) GetAllSPBU() ([]models.SPBU, error) {
	return s.spbuRepo.GetAll()
}
