package main

import (
	"bbm-tracking/internal/config"
	"bbm-tracking/internal/handlers"
	"bbm-tracking/internal/middleware"
	"bbm-tracking/internal/repository"
	"bbm-tracking/internal/services"
	"log"
	"os"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
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

	// Initialize Services
	authService := services.NewAuthService(userRepo)
	tripService := services.NewTripService(tripRepo, userRepo, spbuRepo)
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

	// Routes
	api := app.Group("/api")

	// Health check
	api.Get("/health", func(c *fiber.Ctx) error {
		return c.JSON(fiber.Map{
			"status":  "ok",
			"message": "BBM Tracking API is running",
		})
	})

	// Auth routes
	auth := api.Group("/auth")
	auth.Post("/login", authHandler.Login)
	auth.Post("/register", authHandler.Register)

	// SPBU routes
	spbu := api.Group("/spbu")
	spbu.Get("/", spbuHandler.GetAllSPBU)
	spbu.Post("/", middleware.AuthMiddleware(), spbuHandler.CreateSPBU)

	// Trip routes
	trips := api.Group("/trips")
	trips.Get("/", middleware.AuthMiddleware(), tripHandler.GetAllTrips)
	trips.Get("/:id", middleware.AuthMiddleware(), tripHandler.GetTripByID)
	trips.Post("/", middleware.AuthMiddleware(), tripHandler.CreateTrip)
	trips.Put("/:id/tiba", middleware.AuthMiddleware(), tripHandler.UpdateTiba)
	trips.Put("/:id/bongkar", middleware.AuthMiddleware(), tripHandler.UpdateBongkar)
	trips.Put("/:id/selesai", middleware.AuthMiddleware(), tripHandler.UpdateSelesai)

	// Start server
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("🚀 Server running on http://localhost:%s", port)
	log.Fatal(app.Listen(":" + port))
}
