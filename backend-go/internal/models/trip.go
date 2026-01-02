package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Trip struct {
	ID             string     `gorm:"type:uuid;primaryKey" json:"id"`
	DriverID       string     `gorm:"type:uuid;not null" json:"driver_id"`
	Driver         User       `gorm:"foreignKey:DriverID" json:"driver,omitempty"`
	Awak1Nama      string     `gorm:"not null" json:"awak1_nama"`
	Awak1NoPekerja string     `gorm:"not null" json:"awak1_no_pekerja"`
	Awak2Nama      *string    `json:"awak2_nama"`
	Awak2NoPekerja *string    `json:"awak2_no_pekerja"`
	SPBUID         string     `gorm:"type:uuid;not null" json:"spbu_id"`
	SPBU           SPBU       `gorm:"foreignKey:SPBUID" json:"spbu,omitempty"`
	JamPengisian   time.Time  `gorm:"not null" json:"jam_pengisian"`
	JamTiba        *time.Time `json:"jam_tiba"`
	JamBongkar     *time.Time `json:"jam_bongkar"`
	JamSelesai     *time.Time `json:"jam_selesai"`
	Status         string     `gorm:"not null;default:'berangkat'" json:"status"` // berangkat, tiba, bongkar, selesai
	IsLanjut       bool       `gorm:"default:false" json:"is_lanjut"`
	CreatedAt      time.Time  `json:"created_at"`
	UpdatedAt      time.Time  `json:"updated_at"`
}

func (t *Trip) BeforeCreate(tx *gorm.DB) error {
	t.ID = uuid.New().String()
	return nil
}
