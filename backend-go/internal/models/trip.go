package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

// Trip adalah parent (satu perjalanan driver)
type Trip struct {
	ID             string     `gorm:"type:uuid;primaryKey" json:"id"`
	DriverID       string     `gorm:"type:uuid;not null;index" json:"driver_id"`
	Driver         User       `gorm:"foreignKey:DriverID" json:"driver,omitempty"`
	Awak1Nama      string     `gorm:"not null" json:"awak1_nama"`
	Awak1NoPekerja string     `gorm:"not null;index" json:"awak1_no_pekerja"`
	Awak2Nama      *string    `json:"awak2_nama"`
	Awak2NoPekerja *string    `json:"awak2_no_pekerja"`
	NomorKendaraan string     `gorm:"not null;index" json:"nomor_kendaraan"`
	Status         string     `gorm:"not null;default:'active';index" json:"status"` // active, completed
	CreatedAt      time.Time  `gorm:"index" json:"created_at"`
	UpdatedAt      time.Time  `json:"updated_at"`
	Deliveries     []Delivery `gorm:"foreignKey:TripID" json:"deliveries,omitempty"`
}

func (t *Trip) BeforeCreate(tx *gorm.DB) error {
	t.ID = uuid.New().String()
	return nil
}

// Delivery adalah child (per SPBU)
type Delivery struct {
	ID                string     `gorm:"type:uuid;primaryKey" json:"id"`
	TripID            string     `gorm:"type:uuid;not null;index" json:"trip_id"`
	Trip              Trip       `gorm:"foreignKey:TripID" json:"trip,omitempty"`
	SPBUID            string     `gorm:"type:uuid;not null;index" json:"spbu_id"`
	SPBU              SPBU       `gorm:"foreignKey:SPBUID" json:"spbu,omitempty"`
	JamBerangkat      time.Time  `gorm:"not null;index" json:"jam_berangkat"`              // Server time saat klik "Berangkat"
	JamTiba           *time.Time `json:"jam_tiba"`                                         // Server time saat klik "Tiba"
	JamMulaiBongkar   *time.Time `json:"jam_mulai_bongkar"`                                // Server time saat klik "Mulai Bongkar"
	JamSelesaiBongkar *time.Time `json:"jam_selesai_bongkar"`                              // Server time saat klik "Selesai Bongkar"
	LatitudeTiba      *float64   `json:"latitude_tiba"`                                    // GPS saat tiba
	LongitudeTiba     *float64   `json:"longitude_tiba"`                                   // GPS saat tiba
	Status            string     `gorm:"not null;default:'berangkat';index" json:"status"` // berangkat, tiba, bongkar, selesai
	IsLanjut          bool       `gorm:"default:false" json:"is_lanjut"`                   // Apakah lanjut ke SPBU berikutnya
	SyncedAt          *time.Time `json:"synced_at"`                                        // Untuk offline sync
	CreatedAt         time.Time  `gorm:"index" json:"created_at"`
	UpdatedAt         time.Time  `json:"updated_at"`
}

func (d *Delivery) BeforeCreate(tx *gorm.DB) error {
	d.ID = uuid.New().String()
	return nil
}
