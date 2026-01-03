package handlers

import (
	"bbm-tracking/internal/services"

	"github.com/gofiber/fiber/v2"
)

type TripHandler struct {
	tripService *services.TripService
}

func NewTripHandler(tripService *services.TripService) *TripHandler {
	return &TripHandler{tripService: tripService}
}

// ===== CREATE TRIP =====
func (h *TripHandler) CreateTrip(c *fiber.Ctx) error {
	var req services.CreateTripRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid request body",
		})
	}

	trip, err := h.tripService.CreateTrip(req)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "Trip created successfully",
		"data":    trip,
	})
}

// ===== UPDATE TIBA (dengan GPS validation) =====
func (h *TripHandler) UpdateTiba(c *fiber.Ctx) error {
	deliveryID := c.Params("delivery_id")

	var req services.UpdateTibaRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid request body",
		})
	}

	delivery, err := h.tripService.UpdateTiba(deliveryID, req)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.JSON(fiber.Map{
		"message": "Arrived at SPBU",
		"data":    delivery,
	})
}

// ===== UPDATE MULAI BONGKAR =====
func (h *TripHandler) UpdateMulaiBongkar(c *fiber.Ctx) error {
	deliveryID := c.Params("delivery_id")

	delivery, err := h.tripService.UpdateMulaiBongkar(deliveryID)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.JSON(fiber.Map{
		"message": "Started unloading",
		"data":    delivery,
	})
}

// ===== UPDATE SELESAI BONGKAR =====
func (h *TripHandler) UpdateSelesaiBongkar(c *fiber.Ctx) error {
	deliveryID := c.Params("delivery_id")

	var req services.UpdateSelesaiBongkarRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid request body",
		})
	}

	delivery, err := h.tripService.UpdateSelesaiBongkar(deliveryID, req)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.JSON(fiber.Map{
		"message": "Unloading completed",
		"data":    delivery,
	})
}

// ===== CREATE NEXT DELIVERY (Lanjut SPBU berikutnya) =====
func (h *TripHandler) CreateNextDelivery(c *fiber.Ctx) error {
	var req services.CreateNextDeliveryRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid request body",
		})
	}

	delivery, err := h.tripService.CreateNextDelivery(req)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "Next delivery created",
		"data":    delivery,
	})
}

// ===== GET ALL TRIPS (untuk Dashboard Supervisor) =====
func (h *TripHandler) GetAllTrips(c *fiber.Ctx) error {
	trips, err := h.tripService.GetAllTrips()
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.JSON(fiber.Map{
		"message": "Trips retrieved successfully",
		"data":    trips,
	})
}

// ===== GET TRIP BY ID =====
func (h *TripHandler) GetTripByID(c *fiber.Ctx) error {
	tripID := c.Params("id")
	trip, err := h.tripService.GetTripByID(tripID)
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Trip not found",
		})
	}

	return c.JSON(fiber.Map{
		"message": "Trip retrieved successfully",
		"data":    trip,
	})
}

// ===== GET ACTIVE TRIP (untuk Driver) =====
func (h *TripHandler) GetActiveTrip(c *fiber.Ctx) error {
	// Get driver ID from JWT token
	driverID := c.Locals("userID").(string)

	trip, err := h.tripService.GetActiveTrip(driverID)
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "No active trip found",
		})
	}

	return c.JSON(fiber.Map{
		"message": "Active trip retrieved",
		"data":    trip,
	})
}
