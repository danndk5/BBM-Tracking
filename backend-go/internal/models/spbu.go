package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type SPBU struct {
	ID        string    `gorm:"type:uuid;primaryKey" json:"id"`
	Nama      string    `gorm:"unique;not null;index" json:"nama"`
	Alamat    *string   `json:"alamat"`
	Latitude  *float64  `json:"latitude"`                  // GPS koordinat SPBU
	Longitude *float64  `json:"longitude"`                 // GPS koordinat SPBU
	Radius    float64   `gorm:"default:100" json:"radius"` // Radius dalam meter untuk validasi (default 100m)
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

func (s *SPBU) BeforeCreate(tx *gorm.DB) error {
	s.ID = uuid.New().String()
	return nil
}
