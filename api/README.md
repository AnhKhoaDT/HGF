# TripWise Go Backend API

The core RESTful backend service for the TripWise application. Built using Go, structured in accordance with **Clean Architecture** patterns, and optimized for PostgreSQL/CockroachDB.

## Features

- **User Authentication**: JWT-based auth (Sign Up, Login, Refresh Token, Profile management).
- **Media Upload**: Direct file/image upload functionality to AWS S3.
- **Viper Configuration**: Clean configuration loading via `app.development.yaml`.
- **Database Management**: GORM integration with automated Goose database migrations.

## Project Structure

```
api/
├── cmd/
│   └── server/          # Application entrypoint (main.go)
└── internal/
    ├── config/          # Configurations and Viper setup
    ├── database/        # GORM db connection & Goose migrations
    ├── handlers/        # Gin controllers and middleware
    │   └── dto/         # Request & response data transfer objects
    ├── models/          # GORM model schemas
    ├── repository/      # Database access layer
    └── services/        # Business logic layer
```

## Getting Started

### 1. Configure the environment

Copy/create the development configurations:
Create `app.development.yaml` in the root of the `api` folder and populate it with your variables:

```yaml
app:
  name: "tripwise-core-svc"
  version: "dev"

http_server:
  host: "0.0.0.0"
  port: 8080
  grpc_port: 8080
  allow_origins: ["*"]
  allow_methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]
  allow_headers: ["*"]
  mode: "debug"
  log_level: "debug"

token:
  secret: "your-jwt-secret-key"
  access_token_expiration_time: 3600
  refresh_token_expiration_time: 86400

cockroach_db:
  host: "localhost"
  port: 5432
  user: "postgres"
  password: "yourpassword"
  db_name: "travel"
  ssl_mode: "disable"
  max_open_conns: 10
  max_idle_conns: 5
  conn_max_lifetime: "10m"

aws:
  region: "ap-northeast-2"
  access_key_id: "your-aws-access-key-id"
  secret_access_key: "your-aws-secret-key"
  bucket_name: "your-aws-bucket-name"
```

### 2. Install dependencies

```bash
go mod tidy
```

### 3. Run the API

```bash
go run cmd/server/main.go
```
The API server will listen on the port configured in `http_server.port` (default is `:8080`).
