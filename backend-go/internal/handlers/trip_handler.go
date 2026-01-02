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

	return c.Status(fiber.StatusCreated).JSON(trip)
}

func (h *TripHandler) GetAllTrips(c *fiber.Ctx) error {
	trips, err := h.tripService.GetAllTrips()
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.JSON(trips)
}

func (h *TripHandler) GetTripByID(c *fiber.Ctx) error {
	tripID := c.Params("id")
	trip, err := h.tripService.GetTripByID(tripID)
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Trip not found",
		})
	}

	return c.JSON(trip)
}

func (h *TripHandler) UpdateTiba(c *fiber.Ctx) error {
	tripID := c.Params("id")
	trip, err := h.tripService.UpdateTiba(tripID)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.JSON(trip)
}

func (h *TripHandler) UpdateBongkar(c *fiber.Ctx) error {
	tripID := c.Params("id")
	trip, err := h.tripService.UpdateBongkar(tripID)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.JSON(trip)
}

func (h *TripHandler) UpdateSelesai(c *fiber.Ctx) error {
	tripID := c.Params("id")
	var req services.UpdateSelesaiRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid request body",
		})
	}

	trip, err := h.tripService.UpdateSelesai(tripID, req)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.JSON(trip)
}
