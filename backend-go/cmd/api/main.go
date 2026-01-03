package main

import (
	"bbm-tracking/internal/config"
	"bbm-tracking/internal/handlers"
	"bbm-tracking/internal/middleware"
	"bbm-tracking/internal/repository"
	"bbm-tracking/internal/services"
	"log"
	"os"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/limiter"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/joho/godotenv"
)

func main() {
	// Load .env
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found")
	}

	// Connect Database
	db := config.ConnectDB()

	// Auto Migrate
	config.MigrateDB(db)

	// Initialize Repositories
	userRepo := repository.NewUserRepository(db)
	spbuRepo := repository.NewSPBURepository(db)
	tripRepo := repository.NewTripRepository(db)
	deliveryRepo := repository.NewDeliveryRepository(db)

	// Initialize Services
	authService := services.NewAuthService(userRepo)
	tripService := services.NewTripService(tripRepo, deliveryRepo, userRepo, spbuRepo)
	spbuService := services.NewSPBUService(spbuRepo)

	// Initialize Handlers
	authHandler := handlers.NewAuthHandler(authService)
	tripHandler := handlers.NewTripHandler(tripService)
	spbuHandler := handlers.NewSPBUHandler(spbuService)

	// Initialize Fiber
	app := fiber.New(fiber.Config{
		ErrorHandler: func(c *fiber.Ctx, err error) error {
			code := fiber.StatusInternalServerError
			if e, ok := err.(*fiber.Error); ok {
				code = e.Code
			}
			return c.Status(code).JSON(fiber.Map{
				"error": err.Error(),
			})
		},
	})

	// Middleware
	app.Use(cors.New(cors.Config{
		AllowOrigins: "*",
		AllowHeaders: "Origin, Content-Type, Accept, Authorization",
	}))
	app.Use(logger.New())

	// Rate Limiting (Anti DDoS)
	app.Use(limiter.New(limiter.Config{
		Max:        100,             // 100 requests
		Expiration: 1 * time.Minute, // per minute
		LimitReached: func(c *fiber.Ctx) error {
			return c.Status(fiber.StatusTooManyRequests).JSON(fiber.Map{
				"error": "Too many requests. Please try again later.",
			})
		},
	}))

	// Routes
	api := app.Group("/api")

	// Health check
	api.Get("/health", func(c *fiber.Ctx) error {
		return c.JSON(fiber.Map{
			"status":  "ok",
			"message": "BBM Tracking API is running",
			"time":    time.Now(),
		})
	})

	// Auth routes (Public)
	auth := api.Group("/auth")
	auth.Post("/login", authHandler.Login)
	auth.Post("/register", authHandler.Register)

	// SPBU routes
	spbu := api.Group("/spbu")
	spbu.Get("/", spbuHandler.GetAllSPBU)                               // Public - driver perlu lihat list SPBU
	spbu.Post("/", middleware.AuthMiddleware(), spbuHandler.CreateSPBU) // Protected - hanya supervisor

	// Trip routes (Protected - butuh login)
	trips := api.Group("/trips", middleware.AuthMiddleware())

	// Untuk Dashboard Supervisor
	trips.Get("/", tripHandler.GetAllTrips)    // Get all trips
	trips.Get("/:id", tripHandler.GetTripByID) // Get trip by ID

	// Untuk Driver Mobile App
	trips.Post("/", tripHandler.CreateTrip)         // Create new trip
	trips.Get("/active", tripHandler.GetActiveTrip) // Get driver's active trip

	// Delivery routes (untuk update status per SPBU)
	delivery := api.Group("/deliveries", middleware.AuthMiddleware())
	delivery.Put("/:delivery_id/tiba", tripHandler.UpdateTiba)                      // Update tiba (dengan GPS)
	delivery.Put("/:delivery_id/mulai-bongkar", tripHandler.UpdateMulaiBongkar)     // Update mulai bongkar
	delivery.Put("/:delivery_id/selesai-bongkar", tripHandler.UpdateSelesaiBongkar) // Update selesai bongkar
	delivery.Post("/next", tripHandler.CreateNextDelivery)                          // Lanjut ke SPBU berikutnya

	// Start server
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("🚀 Server running on http://0.0.0.0:%s", port)
	log.Printf("access from device: http://192.168.216.80:%s", port)
	log.Fatal(app.Listen("0.0.0.0:" + port))
}
