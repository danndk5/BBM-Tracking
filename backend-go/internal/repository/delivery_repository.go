package repository

import (
	"bbm-tracking/internal/models"

	"gorm.io/gorm"
)

type DeliveryRepository struct {
	db *gorm.DB
}

func NewDeliveryRepository(db *gorm.DB) *DeliveryRepository {
	return &DeliveryRepository{db: db}
}

func (r *DeliveryRepository) Create(delivery *models.Delivery) error {
	return r.db.Create(delivery).Error
}

func (r *DeliveryRepository) FindByID(id string) (*models.Delivery, error) {
	var delivery models.Delivery
	err := r.db.Preload("SPBU").Where("id = ?", id).First(&delivery).Error
	return &delivery, err
}

func (r *DeliveryRepository) Update(delivery *models.Delivery) error {
	return r.db.Save(delivery).Error
}

func (r *DeliveryRepository) GetByTripID(tripID string) ([]models.Delivery, error) {
	var deliveries []models.Delivery
	err := r.db.Preload("SPBU").Where("trip_id = ?", tripID).Order("created_at ASC").Find(&deliveries).Error
	return deliveries, err
}

func (r *DeliveryRepository) GetActiveDelivery(tripID string) (*models.Delivery, error) {
	var delivery models.Delivery
	err := r.db.Preload("SPBU").
		Where("trip_id = ? AND status != ?", tripID, "selesai").
		Order("created_at DESC").
		First(&delivery).Error
	return &delivery, err
}
