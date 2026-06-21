package database

import (
	"fmt"
	"log"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

func NewPostgresDB(dsn string, isDebug bool) (*gorm.DB, error) {
	config := &gorm.Config{}
	
	if isDebug {
		config.Logger = logger.Default.LogMode(logger.Info)
	} else {
		config.Logger = logger.Default.LogMode(logger.Error)
	}

	db, err := gorm.Open(postgres.Open(dsn), config)
	if err != nil {
		return nil, fmt.Errorf("failed to connect to database: %w", err)
	}

	sqlDB, err := db.DB()
	if err != nil {
		return nil, fmt.Errorf("failed to get underlying sql.DB: %w", err)
	}

	sqlDB.SetMaxIdleConns(10)
	sqlDB.SetMaxOpenConns(100)

	log.Println("✅ Database connection established")
	return db, nil
}

func AutoMigrate(db *gorm.DB) error {
	log.Println("🔄 Checking database extensions...")
	
	// Enable PostGIS
	if err := db.Exec("CREATE EXTENSION IF NOT EXISTS postgis").Error; err != nil {
		return fmt.Errorf("failed to enable PostGIS: %w", err)
	}

	log.Println("✅ Database verification completed")
	return nil
}
