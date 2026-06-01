# 💎 Hidden Gems Finder

Hệ thống săn tìm "Góc Sống Ảo" & Quán Ẩn với công nghệ AR, video streaming và geospatial search.

## 📁 Cấu trúc dự án

```
Flutter_Go/
├── BE-HGF/                    # Backend Go API
├── hidden_gems_finder/        # Flutter Mobile App
├── roadMap.html              # Tài liệu kiến trúc & lộ trình
└── README.md                 # File này
```

## 🚀 Quick Start

### Backend (Go)

```bash
cd BE-HGF
go mod tidy
cp .env.example .env
# Chỉnh sửa .env với thông tin database của bạn
go run main.go
```

Server chạy tại: `http://localhost:8080`

**API Endpoints:**
- `GET /health` - Health check
- `GET /api/v1/ping` - Test endpoint

### Mobile App (Flutter)

```bash
cd hidden_gems_finder

# Cài dependencies
flutter pub get

# Chạy trên device
flutter devices                    # Xem danh sách devices
flutter run                        # Chạy trên device đầu tiên
flutter run -d android            # Chạy trên Android
flutter run -d windows            # Chạy trên Windows
flutter run -d edge               # Chạy trên Edge browser
```

## 🛠️ Tech Stack

### Backend
- **Language:** Go 1.22+
- **Framework:** Gin
- **Database:** PostgreSQL + PostGIS
- **Cache:** Redis
- **API:** REST + gRPC

### Mobile
- **Framework:** Flutter 3.x
- **State Management:** flutter_bloc + equatable
- **DI:** get_it + injectable
- **Networking:** dio (REST) + gRPC
- **Maps:** Google Maps / Mapbox
- **AR:** ARCore (Android) / ARKit (iOS)
- **Video:** video_player
- **Local Storage:** shared_preferences

## 📋 Yêu cầu hệ thống

### Backend
- Go 1.22 trở lên
- PostgreSQL 14+ với PostGIS extension
- Redis 6+ (optional)

### Mobile
- Flutter SDK 3.0.0+
- Dart SDK 3.0.0+
- Android Studio (cho Android development)
- Xcode (cho iOS development - chỉ trên macOS)

## 🎯 Tính năng chính

### ✅ Phase 1: Foundation (Đã hoàn thành)
- [x] Setup backend Go với Gin framework
- [x] Setup Flutter project với multi-platform support
- [x] Cấu trúc dự án cơ bản

### 🚧 Phase 2: Core Features (Đang phát triển)
- [ ] Authentication (Firebase + JWT)
- [ ] User management & gamification
- [ ] Geospatial search với PostGIS
- [ ] Map integration
- [ ] Gem CRUD APIs

### 📋 Phase 3: Advanced Features (Kế hoạch)
- [ ] Video streaming (TikTok-style feed)
- [ ] AR Wayfinder
- [ ] Offline caching
- [ ] Push notifications
- [ ] Social features (like, comment, share)

## 📖 Tài liệu

Xem file `roadMap.html` để biết chi tiết về:
- Kiến trúc hệ thống
- Database schema (PostGIS)
- API specifications
- Lộ trình phát triển 5 giai đoạn
- Thuật toán tối ưu

## 🤝 Đóng góp

Dự án đang trong giai đoạn phát triển. Mọi đóng góp đều được chào đón!

## 📝 License

Private project - All rights reserved

---

**Phát triển bởi:** Hidden Gems Team  
**Phiên bản:** 1.0.0 (Alpha)  
**Cập nhật:** 2026-06-01
