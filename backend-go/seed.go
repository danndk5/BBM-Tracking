package main

import (
	"bbm-tracking/internal/config"
	"bbm-tracking/internal/models"
	"log"

	"github.com/joho/godotenv"
	"golang.org/x/crypto/bcrypt"
)

func main() {
	// Load .env
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found")
	}

	// Connect Database
	db := config.ConnectDB()

	// Hash password
	hashedPassword, _ := bcrypt.GenerateFromPassword([]byte("password123"), bcrypt.DefaultCost)

	// Create Supervisor
	supervisor := models.User{
		NoPekerja: "SUP001",
		Password:  string(hashedPassword),
		Role:      "supervisor",
		Nama:      "Pak Bambang Supervisor",
	}
	db.FirstOrCreate(&supervisor, models.User{NoPekerja: "SUP001"})

	// Create Drivers
	driver1 := models.User{
		NoPekerja: "DRV001",
		Password:  string(hashedPassword),
		Role:      "driver",
		Nama:      "Budi Santoso",
	}
	db.FirstOrCreate(&driver1, models.User{NoPekerja: "DRV001"})

	driver2 := models.User{
		NoPekerja: "DRV002",
		Password:  string(hashedPassword),
		Role:      "driver",
		Nama:      "Ahmad Rifai",
	}
	db.FirstOrCreate(&driver2, models.User{NoPekerja: "DRV002"})

	driver3 := models.User{
		NoPekerja: "DRV003",
		Password:  string(hashedPassword),
		Role:      "driver",
		Nama:      "Siti Aminah",
	}
	db.FirstOrCreate(&driver3, models.User{NoPekerja: "DRV003"})

	// Create SPBUs with GPS coordinates (Jakarta area)
	lat1 := -6.200000
	lon1 := 106.816666
	spbu1 := models.SPBU{
		Nama:      "SPBU Merkurius",
		Alamat:    stringPtr("Jl. Raya Merkurius No. 123, Jakarta"),
		Latitude:  &lat1,
		Longitude: &lon1,
		Radius:    100,
	}
	db.FirstOrCreate(&spbu1, models.SPBU{Nama: "SPBU Merkurius"})

	lat2 := -6.175110
	lon2 := 106.865036
	spbu2 := models.SPBU{
		Nama:      "SPBU Venus",
		Alamat:    stringPtr("Jl. Venus Raya No. 456, Jakarta"),
		Latitude:  &lat2,
		Longitude: &lon2,
		Radius:    100,
	}
	db.FirstOrCreate(&spbu2, models.SPBU{Nama: "SPBU Venus"})

	lat3 := -6.302100
	lon3 := 106.731537
	spbu3 := models.SPBU{
		Nama:      "SPBU Mars",
		Alamat:    stringPtr("Jl. Mars Utara No. 789, Jakarta"),
		Latitude:  &lat3,
		Longitude: &lon3,
		Radius:    150,
	}
	db.FirstOrCreate(&spbu3, models.SPBU{Nama: "SPBU Mars"})

	log.Println("✅ Seed data created successfully!")
	log.Println("")
	log.Println("=== LOGIN CREDENTIALS ===")
	log.Println("Supervisor:")
	log.Println("  No Pekerja: SUP001")
	log.Println("  Password: password123")
	log.Println("")
	log.Println("Drivers:")
	log.Println("  Driver 1 - No Pekerja: DRV001, Password: password123")
	log.Println("  Driver 2 - No Pekerja: DRV002, Password: password123")
	log.Println("  Driver 3 - No Pekerja: DRV003, Password: password123")
}

func stringPtr(s string) *string {
	return &s
}
