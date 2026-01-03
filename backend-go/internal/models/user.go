package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type User struct {
	ID        string    `gorm:"type:uuid;primaryKey" json:"id"`
	NoPekerja string    `gorm:"unique;not null;index" json:"no_pekerja"` // LOGIN USERNAME
	Password  string    `gorm:"not null" json:"-"`
	Role      string    `gorm:"not null;index" json:"role"` // "driver" atau "supervisor"
	Nama      string    `gorm:"not null" json:"nama"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

func (u *User) BeforeCreate(tx *gorm.DB) error {
	u.ID = uuid.New().String()
	return nil
}
