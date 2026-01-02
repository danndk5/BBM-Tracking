package handlers

import (
	"bbm-tracking/internal/services"

	"github.com/gofiber/fiber/v2"
)

type SPBUHandler struct {
	spbuService *services.SPBUService
}

func NewSPBUHandler(spbuService *services.SPBUService) *SPBUHandler {
	return &SPBUHandler{spbuService: spbuService}
}

func (h *SPBUHandler) CreateSPBU(c *fiber.Ctx) error {
	var req services.CreateSPBURequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid request body",
		})
	}

	spbu, err := h.spbuService.CreateSPBU(req)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.Status(fiber.StatusCreated).JSON(spbu)
}

func (h *SPBUHandler) GetAllSPBU(c *fiber.Ctx) error {
	spbus, err := h.spbuService.GetAllSPBU()
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.JSON(spbus)
}
