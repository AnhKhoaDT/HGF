package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"hidden-gems-finder/internal/config"
	"hidden-gems-finder/internal/delivery/http/handlers"
	"hidden-gems-finder/internal/delivery/http/router"
	"hidden-gems-finder/internal/repo"
	"hidden-gems-finder/internal/usecase"
	"hidden-gems-finder/pkg/database"
	"hidden-gems-finder/pkg/firebase"
	"hidden-gems-finder/pkg/jwt"
)

func main() {
	log.Println("🚀 Starting Hidden Gems Finder API Server...")

	// Load configuration
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("❌ Failed to load config: %v", err)
	}

	log.Printf("✅ Configuration loaded (Mode: %s, Port: %s)", cfg.Server.Mode, cfg.Server.Port)

	// Initialize database
	db, err := database.NewPostgresDB(cfg.GetDatabaseDSN(), cfg.Server.Mode == "debug")
	if err != nil {
		log.Fatalf("❌ Failed to connect to database: %v", err)
	}

	// Run migrations
	if err := database.AutoMigrate(db); err != nil {
		log.Fatalf("❌ Failed to run migrations: %v", err)
	}

	// Initialize Firebase Auth
	firebaseAuth, err := firebase.NewAuthClient(context.Background(), cfg.Firebase.CredentialsPath)
	if err != nil {
		log.Fatalf("❌ Failed to initialize Firebase: %v", err)
	}
	log.Println("✅ Firebase Auth initialized")

	// Initialize JWT Manager
	jwtManager := jwt.NewJWTManager(
		cfg.JWT.SecretKey,
		cfg.JWT.AccessTokenDuration,
		cfg.JWT.RefreshTokenDuration,
	)
	log.Println("✅ JWT Manager initialized")

	// Initialize repositories
	userRepo := repo.NewPostgresUserRepository(db)
	refreshTokenRepo := repo.NewPostgresRefreshTokenRepository(db)
	log.Println("✅ Repositories initialized")

	// Initialize use cases
	authUseCase := usecase.NewAuthUseCase(userRepo, refreshTokenRepo, firebaseAuth, jwtManager)
	log.Println("✅ Use cases initialized")

	// Initialize handlers
	authHandler := handlers.NewAuthHandler(authUseCase)
	log.Println("✅ Handlers initialized")

	// Setup router
	r := router.SetupRouter(cfg, authHandler, jwtManager)
	log.Println("✅ Router configured")

	// Start server with graceful shutdown
	srv := &http.Server{
		Addr:    fmt.Sprintf(":%s", cfg.Server.Port),
		Handler: r,
	}

	// Channel to listen for interrupt signals
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)

	// Start server in a goroutine
	go func() {
		log.Printf("🌐 Server starting on port %s", cfg.Server.Port)
		log.Printf("📚 API Documentation: http://localhost:%s/health", cfg.Server.Port)
		
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("❌ Failed to start server: %v", err)
		}
	}()

	log.Println("✅ Server is ready to handle requests!")
	log.Println("Press CTRL+C to stop")

	// Block until we receive a signal
	<-quit
	log.Println("🛑 Shutting down server...")

	// Create context with timeout for graceful shutdown
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	// Shutdown server
	if err := srv.Shutdown(ctx); err != nil {
		log.Printf("❌ Server forced to shutdown: %v", err)
	}

	// Close database connection
	sqlDB, err := db.DB()
	if err == nil {
		sqlDB.Close()
	}

	log.Println("✅ Server stopped gracefully")
}
