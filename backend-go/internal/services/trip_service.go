package services

import (
	"bbm-tracking/internal/models"
	"bbm-tracking/internal/repository"
	"bbm-tracking/internal/utils"
	"errors"
	"time"
)

type TripService struct {
	tripRepo     *repository.TripRepository
	deliveryRepo *repository.DeliveryRepository
	userRepo     *repository.UserRepository
	spbuRepo     *repository.SPBURepository
}

func NewTripService(
	tripRepo *repository.TripRepository,
	deliveryRepo *repository.DeliveryRepository,
	userRepo *repository.UserRepository,
	spbuRepo *repository.SPBURepository,
) *TripService {
	return &TripService{
		tripRepo:     tripRepo,
		deliveryRepo: deliveryRepo,
		userRepo:     userRepo,
		spbuRepo:     spbuRepo,
	}
}

// ===== CREATE TRIP & FIRST DELIVERY =====

type CreateTripRequest struct {
	DriverID       string  `json:"driver_id"`
	Awak1Nama      string  `json:"awak1_nama"`
	Awak1NoPekerja string  `json:"awak1_no_pekerja"`
	Awak2Nama      *string `json:"awak2_nama"`
	Awak2NoPekerja *string `json:"awak2_no_pekerja"`
	NomorKendaraan string  `json:"nomor_kendaraan"`
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

	// Check if driver has active trip
	activeTrip, _ := s.tripRepo.GetActiveTrip(req.DriverID)
	if activeTrip != nil {
		return nil, errors.New("driver already has an active trip")
	}

	// Create Trip (parent)
	trip := &models.Trip{
		DriverID:       req.DriverID,
		Awak1Nama:      req.Awak1Nama,
		Awak1NoPekerja: req.Awak1NoPekerja,
		Awak2Nama:      req.Awak2Nama,
		Awak2NoPekerja: req.Awak2NoPekerja,
		NomorKendaraan: req.NomorKendaraan,
		Status:         "active",
	}

	if err := s.tripRepo.Create(trip); err != nil {
		return nil, err
	}

	// Create first Delivery (child)
	delivery := &models.Delivery{
		TripID:       trip.ID,
		SPBUID:       req.SPBUID,
		JamBerangkat: time.Now(), // SERVER TIME
		Status:       "berangkat",
	}

	if err := s.deliveryRepo.Create(delivery); err != nil {
		return nil, err
	}

	return s.tripRepo.FindByID(trip.ID)
}

// ===== UPDATE TIBA (dengan GPS validation) =====

type UpdateTibaRequest struct {
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
}

func (s *TripService) UpdateTiba(deliveryID string, req UpdateTibaRequest) (*models.Delivery, error) {
	delivery, err := s.deliveryRepo.FindByID(deliveryID)
	if err != nil {
		return nil, errors.New("delivery not found")
	}

	if delivery.Status != "berangkat" {
		return nil, errors.New("delivery already updated")
	}

	// Get SPBU location
	spbu, err := s.spbuRepo.FindByID(delivery.SPBUID)
	if err != nil {
		return nil, errors.New("SPBU not found")
	}

	// GPS Validation (jika SPBU punya koordinat)
	if spbu.Latitude != nil && spbu.Longitude != nil {
		if !utils.IsWithinRadius(
			req.Latitude, req.Longitude,
			*spbu.Latitude, *spbu.Longitude,
			spbu.Radius,
		) {
			return nil, errors.New("driver not at SPBU location")
		}
	}

	// Update dengan SERVER TIME
	now := time.Now()
	delivery.JamTiba = &now
	delivery.LatitudeTiba = &req.Latitude
	delivery.LongitudeTiba = &req.Longitude
	delivery.Status = "tiba"
	delivery.SyncedAt = &now

	if err := s.deliveryRepo.Update(delivery); err != nil {
		return nil, err
	}

	return delivery, nil
}

// ===== UPDATE MULAI BONGKAR =====

func (s *TripService) UpdateMulaiBongkar(deliveryID string) (*models.Delivery, error) {
	delivery, err := s.deliveryRepo.FindByID(deliveryID)
	if err != nil {
		return nil, errors.New("delivery not found")
	}

	if delivery.Status != "tiba" {
		return nil, errors.New("must arrive first before bongkar")
	}

	now := time.Now()
	delivery.JamMulaiBongkar = &now
	delivery.Status = "bongkar"
	delivery.SyncedAt = &now

	if err := s.deliveryRepo.Update(delivery); err != nil {
		return nil, err
	}

	return delivery, nil
}

// ===== UPDATE SELESAI BONGKAR =====

type UpdateSelesaiBongkarRequest struct {
	IsLanjut bool `json:"is_lanjut"`
}

func (s *TripService) UpdateSelesaiBongkar(deliveryID string, req UpdateSelesaiBongkarRequest) (*models.Delivery, error) {
	delivery, err := s.deliveryRepo.FindByID(deliveryID)
	if err != nil {
		return nil, errors.New("delivery not found")
	}

	if delivery.Status != "bongkar" {
		return nil, errors.New("must start bongkar first")
	}

	now := time.Now()
	delivery.JamSelesaiBongkar = &now
	delivery.Status = "selesai"
	delivery.IsLanjut = req.IsLanjut
	delivery.SyncedAt = &now

	if err := s.deliveryRepo.Update(delivery); err != nil {
		return nil, err
	}

	// Jika tidak lanjut, complete the trip
	if !req.IsLanjut {
		trip, _ := s.tripRepo.FindByID(delivery.TripID)
		if trip != nil {
			trip.Status = "completed"
			s.tripRepo.Update(trip)
		}
	}

	return delivery, nil
}

// ===== CREATE NEXT DELIVERY (Lanjut ke SPBU berikutnya) =====

type CreateNextDeliveryRequest struct {
	TripID string `json:"trip_id"`
	SPBUID string `json:"spbu_id"`
}

func (s *TripService) CreateNextDelivery(req CreateNextDeliveryRequest) (*models.Delivery, error) {
	// Validate trip exists and active
	trip, err := s.tripRepo.FindByID(req.TripID)
	if err != nil {
		return nil, errors.New("trip not found")
	}

	if trip.Status != "active" {
		return nil, errors.New("trip is not active")
	}

	// Validate SPBU exists
	_, err = s.spbuRepo.FindByID(req.SPBUID)
	if err != nil {
		return nil, errors.New("SPBU not found")
	}

	// Check if previous delivery is selesai
	activeDelivery, _ := s.deliveryRepo.GetActiveDelivery(req.TripID)
	if activeDelivery != nil && activeDelivery.Status != "selesai" {
		return nil, errors.New("complete previous delivery first")
	}

	// Create new delivery
	delivery := &models.Delivery{
		TripID:       req.TripID,
		SPBUID:       req.SPBUID,
		JamBerangkat: time.Now(), // SERVER TIME
		Status:       "berangkat",
	}

	if err := s.deliveryRepo.Create(delivery); err != nil {
		return nil, err
	}

	return s.deliveryRepo.FindByID(delivery.ID)
}

// ===== GET FUNCTIONS =====

func (s *TripService) GetAllTrips() ([]models.Trip, error) {
	return s.tripRepo.GetAll()
}

func (s *TripService) GetTripByID(tripID string) (*models.Trip, error) {
	return s.tripRepo.FindByID(tripID)
}

func (s *TripService) GetActiveTrip(driverID string) (*models.Trip, error) {
	return s.tripRepo.GetActiveTrip(driverID)
}
