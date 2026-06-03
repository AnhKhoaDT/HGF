# 🔧 Hidden Gems Finder - Backend API

Backend API cho ứng dụng Hidden Gems Finder với **Clean Architecture**.

## ✅ Authentication System Implemented

- Firebase Authentication Integration
- JWT Token Management (Access + Refresh)
- User Registration & Login
- Token Refresh & Revocation
- User Profile Management
- Gamification System (EXP, Levels, Titles)
- PostgreSQL + PostGIS Database

## 🚀 Cách Chạy

### Bước 1: Cài đặt Dependencies

```bash
# Di chuyển vào thư mục backend
cd be-hgf

# Install Go dependencies
go mod download
```

### Bước 2: Setup Database

**Option A: Sử dụng Docker (Recommended)**
```bash
# Start PostgreSQL with PostGIS
docker-compose up -d postgres

# Kiểm tra database đã chạy
docker ps
```

**Option B: PostgreSQL Local**
```bash
# Tạo database
createdb hidden_gems_db

# Enable PostGIS extension
psql -d hidden_gems_db -c "CREATE EXTENSION IF NOT EXISTS postgis;"

# Chạy migrations
psql -U postgres -d hidden_gems_db -f migrations/001_init_schema.sql
```

### Bước 3: Cấu hình Environment

```bash
# Copy file example
cp .env.example .env

# Sửa file .env với thông tin của bạn
# Ít nhất cần config:
# - DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME
# - JWT_SECRET (đổi thành chuỗi ngẫu nhiên)
```

**.env tối thiểu:**
```env
SERVER_PORT=8080
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=hidden_gems_db
JWT_SECRET=your-secret-change-this-in-production
```

### Bước 4: Chạy Server

```bash
# Chạy development
go run cmd/server/main.go

# Hoặc build và chạy
go build -o bin/server cmd/server/main.go
./bin/server
```

Server chạy tại: **http://localhost:8080**

### Bước 5: Test API

```bash
# Health check
curl http://localhost:8080/health

# Ping
curl http://localhost:8080/api/v1/ping
```

**Expected response:**
```json
{
  "status": "ok",
  "message": "Hidden Gems Finder API is running",
  "version": "1.0.0"
}
```

## 📡 API Endpoints

### Public
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login
- `POST /api/v1/auth/refresh` - Refresh access token
- `POST /api/v1/auth/logout` - Logout

### Protected (requires Authorization header)
- `GET /api/v1/auth/me` - Get user profile
- `PUT /api/v1/auth/profile` - Update profile
- `POST /api/v1/auth/logout-all` - Logout all devices

## 🛠️ Tech Stack

- **Go 1.22+** với Gin framework
- **PostgreSQL 14+** với PostGIS
- **GORM** ORM
- **Firebase Auth + JWT**
- **Clean Architecture**

## 📁 Project Structure

```
be-hgf/
├── cmd/server/              # Entry point
├── internal/
│   ├── config/              # Configuration
│   ├── domain/
│   │   ├── entities/        # Domain entities
│   │   └── repositories/    # Repository interfaces
│   ├── repo/                # Repository implementations
│   ├── usecase/             # Business logic
│   └── delivery/http/
│       ├── handlers/        # HTTP handlers
│       ├── middleware/      # Middleware
│       └── router/          # Router
├── pkg/
│   ├── database/            # Database connection
│   ├── firebase/            # Firebase client
│   └── jwt/                 # JWT manager
└── migrations/              # SQL migrations
```

## 🎮 Gamification System

| Level | EXP | Title |
|-------|-----|-------|
| 1-4 | 0-399 | Nhà Thám Hiểm |
| 5-9 | 500-899 | Thám Hiểm Viên |
| 10-19 | 1000-1899 | Nhà Thám Hiểm Kỳ Cựu |
| 20-29 | 2000-2899 | Chuyên Gia Khám Phá |
| 30-39 | 3000-3899 | Thợ Săn Quán Ẩn |
| 40-49 | 4000-4899 | Bậc Thầy Săn Gem |
| 50+ | 5000+ | Huyền Thoại Thám Hiểm |

**Formula:** Level = (ExpPoints / 100) + 1

## 🐳 Docker

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## 🎯 Roadmap

### ✅ Phase 1: Auth (Completed)
- [x] Firebase Auth integration
- [x] JWT token management
- [x] User CRUD
- [x] Gamification system

### 📋 Phase 2: Core Features (Next)
- [ ] Gems CRUD APIs
- [ ] Geospatial queries
- [ ] Video upload
- [ ] AR navigation endpoints

---

**Version:** 1.0.0  
**Status:** ✅ Auth System Ready

