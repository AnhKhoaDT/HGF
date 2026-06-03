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
	Firebase FirebaseConfig
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

// FirebaseConfig holds Firebase configuration
type FirebaseConfig struct {
	CredentialsPath string
	ProjectID       string
}

// LoadConfig loads configuration from environment variables and config files
func LoadConfig() (*Config, error) {
	viper.SetConfigName("config")
	viper.SetConfigType("yaml")
	viper.AddConfigPath(".")
	viper.AddConfigPath("./config")
	viper.AddConfigPath("/etc/hidden-gems-finder/")

	// Set defaults
	setDefaults()

	// Read from config file (optional)
	if err := viper.ReadInConfig(); err != nil {
		if _, ok := err.(viper.ConfigFileNotFoundError); !ok {
			return nil, err
		}
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
		Firebase: FirebaseConfig{
			CredentialsPath: viper.GetString("FIREBASE_CREDENTIALS_PATH"),
			ProjectID:       viper.GetString("FIREBASE_PROJECT_ID"),
		},
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

func setDefaults() {
	// Server defaults
	viper.SetDefault("SERVER_PORT", "8080")
	viper.SetDefault("SERVER_MODE", "debug")
	viper.SetDefault("ALLOW_ORIGINS", []string{"*"})

	// Database defaults
	viper.SetDefault("DB_HOST", "localhost")
	viper.SetDefault("DB_PORT", 5432)
	viper.SetDefault("DB_USER", "postgres")
	viper.SetDefault("DB_PASSWORD", "postgres")
	viper.SetDefault("DB_NAME", "hidden_gems_db")
	viper.SetDefault("DB_SSLMODE", "disable")

	// Redis defaults
	viper.SetDefault("REDIS_HOST", "localhost")
	viper.SetDefault("REDIS_PORT", 6379)
	viper.SetDefault("REDIS_PASSWORD", "")
	viper.SetDefault("REDIS_DB", 0)

	// JWT defaults
	viper.SetDefault("JWT_SECRET", "your-secret-key-change-in-production")
	viper.SetDefault("JWT_ACCESS_TOKEN_DURATION", 15*time.Minute)
	viper.SetDefault("JWT_REFRESH_TOKEN_DURATION", 7*24*time.Hour) // 7 days

	// Firebase defaults
	viper.SetDefault("FIREBASE_CREDENTIALS_PATH", "")
	viper.SetDefault("FIREBASE_PROJECT_ID", "")
}
