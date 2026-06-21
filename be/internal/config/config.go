package config

import (
	"fmt"
	"time"

	"github.com/spf13/viper"
)

// Config holds all configuration for the application
type Config struct {
	Server   ServerConfig
	Database DatabaseConfig
	Redis    RedisConfig
	JWT      JWTConfig
}

// ServerConfig holds server configuration
type ServerConfig struct {
	Port         string
	Mode         string // debug, release
	AllowOrigins []string
}

// DatabaseConfig holds database configuration
type DatabaseConfig struct {
	Host     string
	Port     int
	User     string
	Password string
	DBName   string
	SSLMode  string
}

// RedisConfig holds Redis configuration
type RedisConfig struct {
	Host     string
	Port     int
	Password string
	DB       int
}

// JWTConfig holds JWT configuration
type JWTConfig struct {
	SecretKey            string
	AccessTokenDuration  time.Duration
	RefreshTokenDuration time.Duration
}


// LoadConfig loads configuration from the .env file
func LoadConfig() (*Config, error) {
	viper.SetConfigFile(".env")
	viper.SetConfigType("env")

	// Read from config file
	if err := viper.ReadInConfig(); err != nil {
		return nil, fmt.Errorf("error reading .env file: %w (please create a .env file from .env.example)", err)
	}

	// Override with environment variables
	viper.AutomaticEnv()

	config := &Config{
		Server: ServerConfig{
			Port:         viper.GetString("SERVER_PORT"),
			Mode:         viper.GetString("SERVER_MODE"),
			AllowOrigins: viper.GetStringSlice("ALLOW_ORIGINS"),
		},
		Database: DatabaseConfig{
			Host:     viper.GetString("DB_HOST"),
			Port:     viper.GetInt("DB_PORT"),
			User:     viper.GetString("DB_USER"),
			Password: viper.GetString("DB_PASSWORD"),
			DBName:   viper.GetString("DB_NAME"),
			SSLMode:  viper.GetString("DB_SSLMODE"),
		},
		Redis: RedisConfig{
			Host:     viper.GetString("REDIS_HOST"),
			Port:     viper.GetInt("REDIS_PORT"),
			Password: viper.GetString("REDIS_PASSWORD"),
			DB:       viper.GetInt("REDIS_DB"),
		},
		JWT: JWTConfig{
			SecretKey:            viper.GetString("JWT_SECRET"),
			AccessTokenDuration:  viper.GetDuration("JWT_ACCESS_TOKEN_DURATION"),
			RefreshTokenDuration: viper.GetDuration("JWT_REFRESH_TOKEN_DURATION"),
		},
	}

	// Validate critical parameters (fail fast)
	if config.Server.Port == "" {
		return nil, fmt.Errorf("SERVER_PORT is not set in .env")
	}
	if config.Database.Host == "" {
		return nil, fmt.Errorf("DB_HOST is not set in .env")
	}
	if config.JWT.SecretKey == "" {
		return nil, fmt.Errorf("JWT_SECRET is not set in .env")
	}

	return config, nil
}

// GetDatabaseDSN returns PostgreSQL connection string
func (c *Config) GetDatabaseDSN() string {
	return fmt.Sprintf(
		"host=%s port=%d user=%s password=%s dbname=%s sslmode=%s",
		c.Database.Host,
		c.Database.Port,
		c.Database.User,
		c.Database.Password,
		c.Database.DBName,
		c.Database.SSLMode,
	)
}

// GetRedisDSN returns Redis connection string
func (c *Config) GetRedisDSN() string {
	if c.Redis.Password != "" {
		return fmt.Sprintf("redis://:%s@%s:%d/%d", c.Redis.Password, c.Redis.Host, c.Redis.Port, c.Redis.DB)
	}
	return fmt.Sprintf("redis://%s:%d/%d", c.Redis.Host, c.Redis.Port, c.Redis.DB)
}
