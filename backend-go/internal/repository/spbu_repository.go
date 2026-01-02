package repository

import (
	"bbm-tracking/internal/models"

	"gorm.io/gorm"
)

type SPBURepository struct {
	db *gorm.DB
}

func NewSPBURepository(db *gorm.DB) *SPBURepository {
	return &SPBURepository{db: db}
}

func (r *SPBURepository) Create(spbu *models.SPBU) error {
	return r.db.Create(spbu).Error
}

func (r *SPBURepository) FindByID(id string) (*models.SPBU, error) {
	var spbu models.SPBU
	err := r.db.Where("id = ?", id).First(&spbu).Error
	return &spbu, err
}

func (r *SPBURepository) GetAll() ([]models.SPBU, error) {
	var spbus []models.SPBU
	err := r.db.Find(&spbus).Error
	return spbus, err
}
