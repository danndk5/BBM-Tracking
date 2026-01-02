package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type SPBU struct {
	ID        string    `gorm:"type:uuid;primaryKey" json:"id"`
	Nama      string    `gorm:"unique;not null" json:"nama"`
	Alamat    *string   `json:"alamat"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

func (s *SPBU) BeforeCreate(tx *gorm.DB) error {
	s.ID = uuid.New().String()
	return nil
}
