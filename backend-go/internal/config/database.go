package config

import (
	"bbm-tracking/internal/models"
	"fmt"
	"log"
	"os"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

func ConnectDB() *gorm.DB {
	host := os.Getenv("DB_HOST")
	port := os.Getenv("DB_PORT")
	user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASSWORD")
	dbname := os.Getenv("DB_NAME")
	sslmode := os.Getenv("DB_SSLMODE")

	dsn := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=%s",
		host, port, user, password, dbname, sslmode,
	)

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info),
	})

	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	log.Println("✅ Database connected successfully")
	return db
}

func MigrateDB(db *gorm.DB) {
	err := db.AutoMigrate(
		&models.User{},
		&models.SPBU{},
		&models.Trip{},
		&models.Delivery{}, // NEW
	)

	if err != nil {
		log.Fatal("Failed to migrate database:", err)
	}

	// Create indexes for performance
	db.Exec("CREATE INDEX IF NOT EXISTS idx_trips_driver_id ON trips(driver_id)")
	db.Exec("CREATE INDEX IF NOT EXISTS idx_trips_status ON trips(status)")
	db.Exec("CREATE INDEX IF NOT EXISTS idx_deliveries_trip_id ON deliveries(trip_id)")
	db.Exec("CREATE INDEX IF NOT EXISTS idx_deliveries_status ON deliveries(status)")
	db.Exec("CREATE INDEX IF NOT EXISTS idx_deliveries_jam_berangkat ON deliveries(jam_berangkat)")

	log.Println("✅ Database migrated successfully with indexes")
}
