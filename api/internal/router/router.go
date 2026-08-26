package router

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers"
	"github.com/TranVinhHien/sol-bet88.git/internal/services"
)

// SetupRouter initializes and configures the gin router
func SetupRouter(
	authHandler *handlers.AuthHandler,
	authService *services.AuthService,
	uploadHandler *handlers.UploadHandler,
	adminDivHandler *handlers.AdministrativeDivisionHandler,
	categoryHandler *handlers.CategoryHandler,
	placeHandler *handlers.PlaceHandler,
) *gin.Engine {
	r := gin.Default()

	// CORS configuration
	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Accept", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
	}))

	// Serve static files
	r.Static("/public", "./public")
	r.GET("/", func(c *gin.Context) { c.File("./public/login.html") })
	r.GET("/login", func(c *gin.Context) { c.File("./public/login.html") })
	r.GET("/dashboard", func(c *gin.Context) { c.File("./public/dashboard.html") })

	// Health check
	r.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok"})
	})

	// Swagger documentation
	r.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	// API routes
	api := r.Group("/api/v1")
	{
		// Auth routes (public)
		auth := api.Group("/auth")
		{
			auth.POST("/register", authHandler.Register)
			auth.POST("/login", authHandler.Login)
			auth.POST("/refresh", authHandler.RefreshToken)
			auth.POST("/logout", authHandler.Logout)
			auth.GET("/me", handlers.AuthMiddleware(authService), authHandler.GetMe)
			auth.PUT("/me", handlers.AuthMiddleware(authService), authHandler.UpdateMe)
			auth.PUT("/me/password", handlers.AuthMiddleware(authService), authHandler.UpdatePassword)
		}

		// Place, Category, and Division routes
		divisions := api.Group("/administrative-divisions")
		{
			divisions.POST("", adminDivHandler.CreateDivision)
			divisions.GET("", adminDivHandler.ListDivisions)
			divisions.GET("/:id", adminDivHandler.GetDivision)
			divisions.PUT("/:id", adminDivHandler.UpdateDivision)
			divisions.DELETE("/:id", adminDivHandler.DeleteDivision)
		}

		categories := api.Group("/categories")
		{
			categories.POST("", categoryHandler.CreateCategory)
			categories.GET("", categoryHandler.ListCategories)
			categories.GET("/:id", categoryHandler.GetCategory)
			categories.PUT("/:id", categoryHandler.UpdateCategory)
			categories.DELETE("/:id", categoryHandler.DeleteCategory)
		}

		places := api.Group("/places")
		{
			places.POST("", placeHandler.CreatePlace)
			places.GET("", placeHandler.ListPlaces)
			places.GET("/:id", placeHandler.GetPlace)
			places.PUT("/:id", placeHandler.UpdatePlace)
			places.DELETE("/:id", placeHandler.DeletePlace)
		}

		// Protected routes
		protected := api.Group("")
		protected.Use(handlers.AuthMiddleware(authService))
		{
			// Add other protected routes here
			protected.POST("/upload", uploadHandler.UploadImage)
		}
	}

	return r
}
