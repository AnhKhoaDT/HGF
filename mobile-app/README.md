# 📱 Hidden Gems Finder - Mobile App

Ứng dụng mobile săn tìm góc sống ảo và quán ẩn với công nghệ AR.

## 🚀 Cài đặt & Chạy

### Yêu cầu
- Flutter SDK 3.0.0+
- Dart SDK 3.0.0+
- Android Studio / Xcode (cho emulator/simulator)

### Các bước chạy

1. **Cài đặt dependencies:**
```bash
flutter pub get
```

2. **Xem danh sách devices:**
```bash
flutter devices
```

3. **Chạy ứng dụng:**
```bash
# Chạy trên device đầu tiên
flutter run

# Hoặc chọn device cụ thể
flutter run -d <device-id>

# Ví dụ:
flutter run -d 649da70        # Android device
flutter run -d windows        # Windows desktop
flutter run -d edge           # Edge browser
```

## 🛠️ Tech Stack

- **Framework:** Flutter 3.x
- **Language:** Dart 3.x
- **State Management:** flutter_bloc + equatable
- **Dependency Injection:** get_it + injectable
- **Networking:** dio (REST API)
- **Maps:** google_maps_flutter
- **Location:** geolocator
- **Video:** video_player
- **Local Storage:** shared_preferences

## 📁 Cấu trúc dự án (Đề xuất)

```
lib/
├── core/                 # Core utilities, constants, themes
│   ├── constants/
│   ├── themes/
│   └── utils/
├── features/            # Feature modules (Clean Architecture)
│   ├── auth/           # Authentication
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── map/            # Map & geospatial
│   ├── gems/           # Gems (địa điểm)
│   ├── video/          # Video feed
│   └── ar/             # AR features
├── shared/             # Shared widgets, models
│   ├── widgets/
│   └── models/
└── main.dart           # Entry point
```

## 🎯 Tính năng

### ✅ Đã hoàn thành
- [x] Setup project với multi-platform support
- [x] UI cơ bản với Material Design 3
- [x] Theme system (Light/Dark mode)

### 🚧 Đang phát triển
- [ ] Authentication UI
- [ ] Map screen với Google Maps
- [ ] Gem list & detail screens
- [ ] Video feed (TikTok-style)
- [ ] AR Wayfinder

### 📋 Kế hoạch
- [ ] Offline mode
- [ ] Push notifications
- [ ] Social features
- [ ] User profile & gamification

## 🔧 Development

### Hot Reload
Khi app đang chạy, bạn có thể:
- Nhấn `r` để hot reload
- Nhấn `R` để hot restart
- Nhấn `q` để thoát

### Build Release

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

**Windows:**
```bash
flutter build windows --release
```

## 📝 Lưu ý

- Cần cấu hình API keys cho Google Maps trong:
  - `android/app/src/main/AndroidManifest.xml`
  - `ios/Runner/AppDelegate.swift`
- AR features yêu cầu device hỗ trợ ARCore (Android) hoặc ARKit (iOS)
- Video streaming cần kết nối internet ổn định

## 🐛 Troubleshooting

### Lỗi build Android
```bash
flutter clean
flutter pub get
flutter run
```

### Lỗi Gradle
```bash
cd android
./gradlew clean
cd ..
flutter run
```

### Lỗi dependencies
```bash
flutter pub cache repair
flutter pub get
```

## 📞 Hỗ trợ

Nếu gặp vấn đề, vui lòng tạo issue hoặc liên hệ team phát triển.

---

**Version:** 1.0.0+1  
**Flutter:** 3.24.5  
**Dart:** 3.5.4
