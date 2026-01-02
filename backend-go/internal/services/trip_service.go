package services

import (
	"bbm-tracking/internal/models"
	"bbm-tracking/internal/repository"
	"errors"
	"time"
)

type TripService struct {
	tripRepo *repository.TripRepository
	userRepo *repository.UserRepository
	spbuRepo *repository.SPBURepository
}

func NewTripService(tripRepo *repository.TripRepository, userRepo *repository.UserRepository, spbuRepo *repository.SPBURepository) *TripService {
	return &TripService{
		tripRepo: tripRepo,
		userRepo: userRepo,
		spbuRepo: spbuRepo,
	}
}

type CreateTripRequest struct {
	DriverID       string  `json:"driver_id"`
	Awak1Nama      string  `json:"awak1_nama"`
	Awak1NoPekerja string  `json:"awak1_no_pekerja"`
	Awak2Nama      *string `json:"awak2_nama"`
	Awak2NoPekerja *string `json:"awak2_no_pekerja"`
	SPBUID         string  `json:"spbu_id"`
}

func (s *TripService) CreateTrip(req CreateTripRequest) (*models.Trip, error) {
	// Validate driver exists
	_, err := s.userRepo.FindByID(req.DriverID)
	if err != nil {
		return nil, errors.New("driver not found")
	}

	// Validate SPBU exists
	_, err = s.spbuRepo.FindByID(req.SPBUID)
	if err != nil {
		return nil, errors.New("SPBU not found")
	}

	trip := &models.Trip{
		DriverID:       req.DriverID,
		Awak1Nama:      req.Awak1Nama,
		Awak1NoPekerja: req.Awak1NoPekerja,
		Awak2Nama:      req.Awak2Nama,
		Awak2NoPekerja: req.Awak2NoPekerja,
		SPBUID:         req.SPBUID,
		JamPengisian:   time.Now(),
		Status:         "berangkat",
	}

	if err := s.tripRepo.Create(trip); err != nil {
		return nil, err
	}

	return s.tripRepo.FindByID(trip.ID)
}

func (s *TripService) UpdateTiba(tripID string) (*models.Trip, error) {
	trip, err := s.tripRepo.FindByID(tripID)
	if err != nil {
		return nil, errors.New("trip not found")
	}

	if trip.Status != "berangkat" {
		return nil, errors.New("trip already updated")
	}

	now := time.Now()
	trip.JamTiba = &now
	trip.Status = "tiba"

	if err := s.tripRepo.Update(trip); err != nil {
		return nil, err
	}

	return trip, nil
}

func (s *TripService) UpdateBongkar(tripID string) (*models.Trip, error) {
	trip, err := s.tripRepo.FindByID(tripID)
	if err != nil {
		return nil, errors.New("trip not found")
	}

	if trip.Status != "tiba" {
		return nil, errors.New("must arrive first before bongkar")
	}

	now := time.Now()
	trip.JamBongkar = &now
	trip.Status = "bongkar"

	if err := s.tripRepo.Update(trip); err != nil {
		return nil, err
	}

	return trip, nil
}

type UpdateSelesaiRequest struct {
	IsLanjut bool `json:"is_lanjut"`
}

func (s *TripService) UpdateSelesai(tripID string, req UpdateSelesaiRequest) (*models.Trip, error) {
	trip, err := s.tripRepo.FindByID(tripID)
	if err != nil {
		return nil, errors.New("trip not found")
	}

	if trip.Status != "bongkar" {
		return nil, errors.New("must bongkar first before selesai")
	}

	now := time.Now()
	trip.JamSelesai = &now
	trip.Status = "selesai"
	trip.IsLanjut = req.IsLanjut

	if err := s.tripRepo.Update(trip); err != nil {
		return nil, err
	}

	return trip, nil
}

func (s *TripService) GetAllTrips() ([]models.Trip, error) {
	return s.tripRepo.GetAll()
}

func (s *TripService) GetTripByID(tripID string) (*models.Trip, error) {
	return s.tripRepo.FindByID(tripID)
}
