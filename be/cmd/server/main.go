package main

import (
	"fmt"
	"log"
	"net/http"

	"hidden-gems-finder/internal/config"
	"hidden-gems-finder/internal/delivery/http/handlers"
	"hidden-gems-finder/internal/delivery/http/router"
	"hidden-gems-finder/internal/repo"
	"hidden-gems-finder/internal/usecase"
	"hidden-gems-finder/pkg/database"
	"hidden-gems-finder/pkg/jwt"
)

func main() {
	// Load configuration
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load config: %v", err)
	}

	// Initialize database
	db, err := database.NewPostgresDB(cfg.GetDatabaseDSN(), cfg.Server.Mode == "debug")
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	// Run migrations
	if err := database.AutoMigrate(db); err != nil {
		log.Fatalf("Failed to run migrations: %v", err)
	}

	// Initialize JWT Manager
	jwtManager := jwt.NewJWTManager(
		cfg.JWT.SecretKey,
		cfg.JWT.AccessTokenDuration,
		cfg.JWT.RefreshTokenDuration,
	)

	// Initialize repositories, usecases, handlers
	userRepo := repo.NewPostgresUserRepository(db)
	refreshTokenRepo := repo.NewPostgresRefreshTokenRepository(db)

	authUseCase := usecase.NewAuthUseCase(userRepo, refreshTokenRepo, jwtManager)
	authHandler := handlers.NewAuthHandler(authUseCase)

	// Setup router
	r := router.SetupRouter(cfg, authHandler, jwtManager)

	// Start server
	addr := fmt.Sprintf(":%s", cfg.Server.Port)
	log.Printf("🌐 Server starting on port %s", cfg.Server.Port)
	if err := http.ListenAndServe(addr, r); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
