package handlers

import (
	"bbm-tracking/internal/services"
	"log"

	"github.com/gofiber/fiber/v2"
)

type AuthHandler struct {
	authService *services.AuthService
}

func NewAuthHandler(authService *services.AuthService) *AuthHandler {
	return &AuthHandler{authService: authService}
}

func (h *AuthHandler) Login(c *fiber.Ctx) error {
	var req services.LoginRequest
	if err := c.BodyParser(&req); err != nil {
		log.Printf("❌ LOGIN: Invalid request body: %v", err)
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid request body",
		})
	}

	log.Printf("📝 LOGIN REQUEST: NoPekerja=%s", req.NoPekerja)

	response, err := h.authService.Login(req)
	if err != nil {
		log.Printf("❌ LOGIN FAILED: %v", err)
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	log.Printf("✅ LOGIN SUCCESS!")
	log.Printf("   User ID: %s", response.User.ID)
	log.Printf("   Nama: %s", response.User.Nama)
	log.Printf("   Token Length: %d", len(response.Token))
	log.Printf("📤 RESPONSE YANG DIKIRIM KE FLUTTER:")
	log.Printf("   response.User.ID = %s", response.User.ID)

	return c.JSON(response)
}

func (h *AuthHandler) Register(c *fiber.Ctx) error {
	var req services.RegisterRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid request body",
		})
	}

	response, err := h.authService.Register(req)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.Status(fiber.StatusCreated).JSON(response)
}
