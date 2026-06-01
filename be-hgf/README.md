# 🔧 Hidden Gems Finder - Backend API

Backend API cho ứng dụng Hidden Gems Finder, xây dựng bằng Go với Gin framework.

## 🚀 Quick Start

### Yêu cầu
- Go 1.22 trở lên
- PostgreSQL 14+ với PostGIS extension
- Redis 6+ (optional, cho caching)

### Cài đặt & Chạy

1. **Clone và di chuyển vào thư mục:**
```bash
cd BE-HGF
```

2. **Cài đặt dependencies:**
```bash
go mod tidy
```

3. **Tạo file `.env`:**
```bash
cp .env.example .env
```

4. **Chỉnh sửa `.env` với thông tin của bạn:**
```env
PORT=8080
DATABASE_URL=postgresql://user:password@localhost:5432/hidden_gems_db?sslmode=disable
REDIS_URL=redis://localhost:6379
JWT_SECRET=your-secret-key-here
```

5. **Chạy server:**
```bash
go run main.go
```

Server sẽ chạy tại `http://localhost:8080`

## 📡 API Endpoints

### Health Check
```http
GET /health
```

**Response:**
```json
{
  "status": "ok",
  "message": "Hidden Gems Finder API is running"
}
```

### API v1

#### Ping
```http
GET /api/v1/ping
```

**Response:**
```json
{
  "message": "pong"
}
```

## 🛠️ Tech Stack

- **Language:** Go 1.22+
- **Framework:** Gin (Web framework)
- **Database:** PostgreSQL + PostGIS
- **ORM:** GORM
- **Cache:** Redis
- **Auth:** JWT + Firebase Auth
- **API:** REST + gRPC

## 📁 Cấu trúc dự án (Đề xuất)

```
BE-HGF/
├── cmd/
│   └── server/
│       └── main.go          # Entry point
├── internal/
│   ├── config/              # Configuration
│   ├── models/              # Database models
│   ├── handlers/            # HTTP handlers
│   ├── services/            # Business logic
│   ├── repositories/        # Data access layer
│   └── middleware/          # Middleware (auth, cors, etc.)
├── pkg/
│   └── utils/               # Shared utilities
├── migrations/              # Database migrations
├── .env.example             # Environment template
├── .gitignore
├── go.mod
├── go.sum
├── main.go                  # Current entry point
└── README.md
```

## 🗄️ Database Schema (PostGIS)

### Tables (Kế hoạch)

**users**
- id (uuid, primary key)
- email (string, unique)
- username (string, unique)
- firebase_uid (string, unique)
- level (int) - Gamification level
- exp_points (int)
- created_at, updated_at

**gems** (Địa điểm)
- id (uuid, primary key)
- name (string)
- description (text)
- location (geography(Point, 4326)) - PostGIS
- address (string)
- category (string)
- difficulty_level (int)
- created_by (uuid, foreign key -> users)
- created_at, updated_at

**videos**
- id (uuid, primary key)
- gem_id (uuid, foreign key -> gems)
- user_id (uuid, foreign key -> users)
- video_url (string)
- thumbnail_url (string)
- duration (int)
- views_count (int)
- likes_count (int)
- created_at, updated_at

## 🎯 Roadmap

### ✅ Phase 1: Foundation (Đã hoàn thành)
- [x] Setup Go project với Gin
- [x] Basic health check endpoint
- [x] Environment configuration

### 🚧 Phase 2: Core APIs (Đang phát triển)
- [ ] Database setup (PostgreSQL + PostGIS)
- [ ] User authentication (Firebase + JWT)
- [ ] User CRUD APIs
- [ ] Gems CRUD APIs
- [ ] Geospatial queries

### 📋 Phase 3: Advanced Features
- [ ] Video upload & streaming
- [ ] Redis caching layer
- [ ] gRPC services
- [ ] Real-time features (WebSocket)
- [ ] Search & filtering
- [ ] Recommendation system

## 🔧 Development

### Run with hot reload
```bash
# Install air for hot reload
go install github.com/cosmtrek/air@latest

# Run with air
air
```

### Run tests
```bash
go test ./...
```

### Build
```bash
go build -o bin/server main.go
```

### Run production
```bash
./bin/server
```

## 🐳 Docker (Kế hoạch)

```bash
# Build image
docker build -t hidden-gems-api .

# Run container
docker run -p 8080:8080 --env-file .env hidden-gems-api
```

## 📝 Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| PORT | Server port | 8080 |
| DATABASE_URL | PostgreSQL connection string | - |
| REDIS_URL | Redis connection string | - |
| JWT_SECRET | JWT signing secret | - |
| FIREBASE_PROJECT_ID | Firebase project ID | - |

## 🔒 Security

- JWT authentication
- Firebase Auth integration
- CORS middleware
- Rate limiting (kế hoạch)
- Input validation
- SQL injection prevention (GORM)

## 📞 Support

Nếu gặp vấn đề, vui lòng tạo issue hoặc liên hệ team phát triển.

---

**Version:** 1.0.0  
**Go:** 1.22+  
**Framework:** Gin
