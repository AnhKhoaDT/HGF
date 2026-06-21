package router

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"hidden-gems-finder/internal/config"
	"hidden-gems-finder/internal/delivery/http/handlers"
	"hidden-gems-finder/internal/delivery/http/middleware"
	"hidden-gems-finder/pkg/jwt"
)

// SetupRouter configures and returns the Gin router
func SetupRouter(
	cfg *config.Config,
	authHandler *handlers.AuthHandler,
	jwtManager *jwt.JWTManager,
) *gin.Engine {
	// Set Gin mode
	if cfg.Server.Mode == "release" {
		gin.SetMode(gin.ReleaseMode)
	}

	router := gin.Default()

	// CORS middleware
	router.Use(cors.New(cors.Config{
		AllowOrigins:     cfg.Server.AllowOrigins,
		AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Accept", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
	}))

	// Health check endpoint
	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"status":  "ok",
			"message": "Hidden Gems Finder API is running",
			"version": "1.0.0",
		})
	})

	// API v1 routes
	v1 := router.Group("/api/v1")
	{
		// Ping endpoint
		v1.GET("/ping", func(c *gin.Context) {
			c.JSON(200, gin.H{"message": "pong"})
		})

		// Auth routes (public)
		auth := v1.Group("/auth")
		{
			auth.POST("/register", authHandler.Register)
			auth.POST("/login", authHandler.Login)
			auth.POST("/refresh", authHandler.RefreshToken)
			auth.POST("/logout", authHandler.Logout)

			// Protected auth routes
			authProtected := auth.Group("")
			authProtected.Use(middleware.AuthMiddleware(jwtManager))
			{
				authProtected.GET("/me", authHandler.GetMe)
				authProtected.PUT("/profile", authHandler.UpdateProfile)
				authProtected.POST("/logout-all", authHandler.LogoutAll)
			}
		}

		// Protected routes
		protected := v1.Group("")
		protected.Use(middleware.AuthMiddleware(jwtManager))
		{
			// Add more protected routes here (gems, videos, etc.)
		}
	}

	return router
}
