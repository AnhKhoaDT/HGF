package main

import (
	"log"
	"net/http"
	"os"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

// Chạy server đơn giản không cần database để test
func main() {
	log.Println("🚀 Starting Hidden Gems Finder API Server (No DB Mode)...")

	port := os.Getenv("SERVER_PORT")
	if port == "" {
		port = "8080"
	}

	gin.SetMode(gin.DebugMode)
	router := gin.Default()

	// CORS
	router.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Accept", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
	}))

	// Health check
	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"status":  "ok",
			"message": "Hidden Gems Finder API is running",
			"version": "1.0.0",
			"mode":    "no-database",
		})
	})

	// Ping
	router.GET("/api/v1/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{"message": "pong"})
	})

	// Mock auth endpoints
	v1 := router.Group("/api/v1")
	{
		auth := v1.Group("/auth")
		{
			auth.POST("/register", func(c *gin.Context) {
				c.JSON(200, gin.H{
					"message": "Register endpoint (database required)",
					"error":   "Please setup PostgreSQL database to use this feature",
				})
			})

			auth.POST("/login", func(c *gin.Context) {
				c.JSON(200, gin.H{
					"message": "Login endpoint (database required)",
					"error":   "Please setup PostgreSQL database to use this feature",
				})
			})
		}
	}

	log.Printf("🌐 Server starting on port %s", port)
	log.Printf("📚 Health check: http://localhost:%s/health", port)
	log.Println("⚠️  Running in NO-DATABASE mode - setup PostgreSQL for full features")
	
	if err := router.Run(":" + port); err != nil && err != http.ErrServerClosed {
		log.Fatalf("❌ Failed to start server: %v", err)
	}
}
