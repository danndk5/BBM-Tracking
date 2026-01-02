package repository

import (
	"bbm-tracking/internal/models"

	"gorm.io/gorm"
)

type TripRepository struct {
	db *gorm.DB
}

func NewTripRepository(db *gorm.DB) *TripRepository {
	return &TripRepository{db: db}
}

func (r *TripRepository) Create(trip *models.Trip) error {
	return r.db.Create(trip).Error
}

func (r *TripRepository) FindByID(id string) (*models.Trip, error) {
	var trip models.Trip
	err := r.db.Preload("Driver").Preload("SPBU").Where("id = ?", id).First(&trip).Error
	return &trip, err
}

func (r *TripRepository) GetAll() ([]models.Trip, error) {
	var trips []models.Trip
	err := r.db.Preload("Driver").Preload("SPBU").Order("created_at DESC").Find(&trips).Error
	return trips, err
}

func (r *TripRepository) Update(trip *models.Trip) error {
	return r.db.Save(trip).Error
}

func (r *TripRepository) GetByDriverID(driverID string) ([]models.Trip, error) {
	var trips []models.Trip
	err := r.db.Preload("SPBU").Where("driver_id = ?", driverID).Order("created_at DESC").Find(&trips).Error
	return trips, err
}
