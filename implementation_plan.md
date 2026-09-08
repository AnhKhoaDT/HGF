# 📋 TripWise — Task Tracker (Backend & Frontend Mobile)

> **Dựa trên:** [tasks-assignment.md](file:///home/kai/Personal/Plan_Travel/Plan_Travel/tasks-assignment.md) & [task_core_system.md](file:///home/kai/Personal/Plan_Travel/Plan_Travel/task_core_system.md)
>
> **Trạng thái hiện tại (21/08/2026):** Sprint 1 (Auth & Setup) đã hoàn tất cơ bản. Chuẩn bị bước vào Sprint 2 (Core Data & Map).

---

## 📊 Tổng quan Trạng thái Hiện tại

### ✅ Đã Hoàn Thành (Sprint 1)

| Layer | Hạng mục | Trạng thái |
| :--- | :--- | :---: |
| **BE** | DB Schema: `user_credentials`, `user_profiles`, `categories`, `places`, `itineraries`, `itinerary_days`, `itinerary_items` | ✅ |
| **BE** | API Auth: Register, Login, Refresh Token, Logout, GetMe, UpdateMe, UpdatePassword | ✅ |
| **BE** | API CRUD: Categories, Places, Administrative Divisions | ✅ |
| **BE** | Upload Service (S3/R2) | ✅ |
| **FE** | UI Auth: Login, SignUp, Welcome Page | ✅ |
| **FE** | Secure Token Storage (`flutter_secure_storage`) | ✅ |
| **FE** | Redux Store + AuthController (Clean Architecture) | ✅ |
| **FE** | Home Dashboard + Bottom Navigation (4 tabs) | ✅ |
| **FE** | Profile Page + Security Settings | ✅ |
| **FE** | Feature modules: `places`, `categories`, `explore`, `trips` (cấu trúc Clean Architecture) | ✅ |

---

## 🔥 Sprint 2: Core Data, Home Overview & Bản đồ Khám phá

### 💻 Backend (Go)

- `[x]` **BE-2.1: API Home Overview `/api/home/overview`**
  - `[ ]` Tạo handler `home_overview.go` trả về JSON tổng hợp: `featured_places` (6 items), `categories` (tất cả active)
  - `[ ]` Đăng ký route `GET /api/home/overview` trong [router.go](file:///home/kai/Personal/Plan_Travel/Plan_Travel/api/internal/router/router.go)
  - `[ ]` Viết service `home_service.go` gom dữ liệu từ `PlaceRepository` và `CategoryRepository`

- `[ ]` **BE-2.2: Bật PostGIS & Truy vấn địa lý**
  - `[ ]` Uncomment `CREATE EXTENSION postgis` trong [001_init.sql](file:///home/kai/Personal/Plan_Travel/Plan_Travel/api/internal/database/migrations/001_init.sql#L5)
  - `[ ]` Tạo migration `003_add_geom_column.sql`: thêm cột `geom GEOMETRY(Point, 4326)` cho bảng `places`, tạo spatial index
  - `[ ]` Viết trigger tự động cập nhật `geom` từ cột `lat`/`lng` khi INSERT/UPDATE

- `[ ]` **BE-2.3: API Gems Nearby (Truy vấn xung quanh GPS)**
  - `[ ]` `GET /api/places/nearby?lat=...&lng=...&radius=5000` — dùng `ST_DWithin` trên cột `geom`
  - `[ ]` Hỗ trợ lọc theo `category_id`, `limit`, `page`
  - `[ ]` Trả về khoảng cách (km) từ vị trí người dùng đến mỗi place

- `[ ]` **BE-2.4: API Place Detail & Reviews**
  - `[ ]` `GET /api/places/:id` — trả về đầy đủ: images, category, division, reviews
  - `[ ]` Tạo migration `004_add_reviews.sql`: bảng `place_reviews` (user_id, place_id, rating, content, images, created_at)
  - `[ ]` `POST /api/places/:id/reviews` — đăng đánh giá (yêu cầu Auth)
  - `[ ]` `GET /api/places/:id/reviews` — danh sách reviews phân trang

- `[ ]` **BE-2.5: API Bounding Box (Map viewport)**
  - `[ ]` `GET /api/places/bbox?ne_lat=...&ne_lng=...&sw_lat=...&sw_lng=...` — dùng `ST_MakeEnvelope` + `ST_Intersects`
  - `[ ]` Trả về danh sách places nằm trong khung nhìn bản đồ

---

### 📱 Frontend Mobile (Flutter)

- `[ ]` **FE-2.1: Tích hợp Home Overview API**
  - `[ ]` Kết nối `HomePage` với API `/home/overview` thực tế (hiện đang fallback)
  - `[ ]` Xử lý error states & empty states chuẩn (hiện tại `catch` im lặng)

- `[ ]` **FE-2.2: Trang Chi Tiết Địa Điểm (Place Detail Page)**
  - `[ ]` Tạo feature `lib/features/places/presentation/pages/place_detail_page.dart`
  - `[ ]` UI: Ảnh banner trượt (PageView), thông tin mô tả, rating, giờ mở cửa
  - `[ ]` Nút "Thêm vào Bộ sưu tập" / "Thêm vào Wishlist"
  - `[ ]` Danh sách Reviews phân trang
  - `[ ]` UI "Đăng đánh giá": Chọn sao (1-5), nhập cảm nghĩ, đính kèm hình ảnh
  - `[ ]` Đăng ký route `/place-detail` trong [main.dart](file:///home/kai/Personal/Plan_Travel/Plan_Travel/mobile-app/lib/main.dart)

- `[ ]` **FE-2.3: Bản đồ Khám phá (Interactive Map)**
  - `[ ]` Thêm package `google_maps_flutter` và cấu hình API Key (Android/iOS)
  - `[ ]` Thêm package `geolocator` — xin quyền định vị
  - `[ ]` Hiển thị Pins cho các Places trên bản đồ
  - `[ ]` Marker Clustering khi zoom out (dùng package clustering)
  - `[ ]` Thanh lọc thể loại (Category chips) phía trên bản đồ
  - `[ ]` Card Preview (vuốt ngang) hiển thị tóm tắt Place khi chạm Pin
  - `[ ]` Tích hợp vào tab Explore hoặc tạo tab Map mới

- `[ ]` **FE-2.4: Feature `places` Clean Architecture hoàn chỉnh**
  - `[ ]` Tạo `GetPlaceDetailUseCase`, `SubmitReviewUseCase`, `GetNearbyPlacesUseCase`
  - `[ ]` Tạo `PlacesController` (hoặc BLoC) quản lý state chi tiết & reviews

---

## 🤖 Sprint 3: AI Travel Planner & Itinerary

### 💻 Backend (Go)

- `[ ]` **BE-3.1: Tích hợp LLM (Gemini API)**
  - `[ ]` Tạo `llm_service.go` kết nối Gemini API
  - `[ ]` Viết prompt template: Nhận đầu vào (tỉnh/thành, ngân sách, số ngày, sở thích) → trả về danh sách places gợi ý
  - `[ ]` Parse output LLM → map với Places trong DB theo tên/tọa độ

- `[ ]` **BE-3.2: Engine Sinh Lịch Trình + Routing**
  - `[ ]` `POST /api/itineraries/generate` — sinh 3 phương án lịch trình
  - `[ ]` Tích hợp OSRM / Google Directions API để sắp xếp thứ tự di chuyển tối ưu
  - `[ ]` Trả về cấu trúc: `itinerary → days → items (places + time slots)`

- `[ ]` **BE-3.3: API CRUD Itineraries**
  - `[ ]` `POST /api/itineraries` — lưu lịch trình người dùng chọn
  - `[ ]` `GET /api/itineraries` — danh sách lịch trình của user (phân trang)
  - `[ ]` `GET /api/itineraries/:id` — chi tiết lịch trình (kèm days & items)
  - `[ ]` `PUT /api/itineraries/:id` — cập nhật thông tin lịch trình
  - `[ ]` `PUT /api/itineraries/:id/items/reorder` — sắp xếp lại thứ tự items
  - `[ ]` `DELETE /api/itineraries/:id` — xóa lịch trình

- `[ ]` **BE-3.4: API Distance Matrix (Proxy + Cache)**
  - `[ ]` Tạo `distance_service.go` proxy gọi Goong Maps / Google Maps Matrix API
  - `[ ]` Nhận mảng tọa độ → trả về ma trận khoảng cách & thời gian
  - `[ ]` Cache kết quả trong Redis (TTL 24h) để tiết kiệm chi phí API

---

### 📱 Frontend Mobile (Flutter)

- `[ ]` **FE-3.1: Feature `trips` — Giao diện Quản lý Lịch trình**
  - `[ ]` Tạo Clean Architecture đầy đủ cho `lib/features/trips/`: Entity, Model, Repository, UseCases, Controller
  - `[ ]` Màn hình danh sách chuyến đi (`TripsListPage`)
  - `[ ]` Màn hình chi tiết lịch trình: Timeline theo ngày (Day 1, Day 2...) với danh sách places
  - `[ ]` Swipe-to-delete cho items, popup form chỉnh sửa
  - `[ ]` Bản đồ mini chỉ đường giữa các điểm trong ngày

- `[ ]` **FE-3.2: Luồng Tạo Lịch Trình AI (Multi-step Form)**
  - `[ ]` Step 1: Chọn điểm đến (tỉnh/thành)
  - `[ ]` Step 2: Chọn ngày khởi hành & kết thúc
  - `[ ]` Step 3: Thiết lập ngân sách
  - `[ ]` Step 4: Chọn sở thích (Thiên nhiên, Ẩm thực, Văn hóa, Biển...)
  - `[ ]` Step 5: Chọn nhịp độ di chuyển (Thong thả / Vừa phải / Dồn dập)
  - `[ ]` Màn hình Loading sinh động khi chờ API AI xử lý
  - `[ ]` Hiển thị & so sánh 3 phương án lịch trình (TabView)

- `[ ]` **FE-3.3: Kéo thả sắp xếp lại lịch trình**
  - `[ ]` Sử dụng `ReorderableListView` để kéo thả items trong ngày
  - `[ ]` Gọi API `reorder` sau khi thả xong
  - `[ ]` Hiển thị nhãn khoảng cách & thời gian giữa các điểm (từ Distance Matrix API)
  - `[ ]` Cảnh báo trực quan nếu thời gian di chuyển > thời gian rảnh

- `[ ]` **FE-3.4: Tổng quan Ngân sách Chuyến đi**
  - `[ ]` Thẻ tổng quan ngân sách dạng "thẻ tín dụng" trên màn hình chuyến đi
  - `[ ]` ProgressBar cảnh báo chuyển cam/đỏ khi vượt 90% budget
  - `[ ]` Form nhập chi phí cho từng activity

---

## 🌐 Sprint 4: Tương tác Xã hội & Nâng cao

### 💻 Backend (Go)

- `[ ]` **BE-4.1: Hệ thống Collections & Social**
  - `[ ]` Tạo migration: bảng `collections`, `collection_items`, `follows`, `likes`
  - `[ ]` API CRUD Collections
  - `[ ]` API Like/Unlike cho Places & Itineraries
  - `[ ]` API Follow/Unfollow Users
  - `[ ]` API Feed: `GET /api/feed` — bảng tin hoạt động từ người đang follow

- `[ ]` **BE-4.2: Quản lý Nhóm & Cộng tác**
  - `[ ]` Tạo bảng `itinerary_collaborators` (user_id, itinerary_id, role: owner/editor/viewer)
  - `[ ]` API sinh Invite Link (token mã hóa + hạn sử dụng)
  - `[ ]` Middleware kiểm tra phân quyền trước mỗi thao tác trên lịch trình
  - `[ ]` Thiết lập WebSocket server cho đồng bộ realtime

- `[ ]` **BE-4.3: API Chi phí & Chia tiền nhóm**
  - `[ ]` Tạo bảng `expense_transactions`, `expense_splits`
  - `[ ]` API CRUD giao dịch tài chính (payer, split participants, tỷ lệ chia)
  - `[ ]` Thuật toán đơn giản hóa công nợ (Debt Simplification)

---

### 📱 Frontend Mobile (Flutter)

- `[ ]` **FE-4.1: Tương tác Xã hội**
  - `[ ]` Nút Like/Bookmark trên Place Detail & Itinerary
  - `[ ]` Màn hình Bộ sưu tập cá nhân
  - `[ ]` Màn hình Feed / Bảng tin hoạt động

- `[ ]` **FE-4.2: Quản lý Nhóm Chuyến đi**
  - `[ ]` Màn hình quản lý thành viên (avatars, vai trò)
  - `[ ]` Tạo & chia sẻ Invite Link
  - `[ ]` Đồng bộ realtime qua WebSocket khi thành viên khác thay đổi lịch trình

- `[ ]` **FE-4.3: Nhập Chi phí & OCR**
  - `[ ]` Nút (+) nổi nhập nhanh chi phí
  - `[ ]` Tích hợp Google ML Kit OCR quét hóa đơn
  - `[ ]` Màn hình Báo cáo "Ai nợ ai" + nút "Đã thanh toán"

- `[ ]` **FE-4.4: Packing List (Quản lý Đồ cần mang)**
  - `[ ]` Checklist phân loại (Giấy tờ, Y tế, Điện tử, Quần áo)
  - `[ ]` Tap-to-check / Swipe-to-delete
  - `[ ]` Lưu cục bộ (SQLite/Hive) để hoạt động offline → sync khi online

---

## 🎯 Ưu tiên thực hiện ngay (Next Actions)

> [!IMPORTANT]
> **Backend** cần ưu tiên hoàn thành **BE-2.1 (API Home Overview)** ngay lập tức để Frontend Mobile không phải chạy fallback.

> [!IMPORTANT]
> **Frontend Mobile** nên bắt tay vào **FE-2.2 (Place Detail Page)** vì đây là trang core nhất của ứng dụng du lịch, và Backend đã có sẵn `GET /api/places/:id`.

| Thứ tự | Task | Ai làm |
| :---: | :--- | :---: |
| 1 | BE-2.1: API Home Overview | BE |
| 2 | BE-2.2: Bật PostGIS + geom column | BE |
| 3 | FE-2.2: Trang Chi Tiết Địa Điểm | FE |
| 4 | BE-2.3: API Nearby | BE |
| 5 | BE-2.4: API Reviews | BE |
| 6 | FE-2.3: Bản đồ Khám phá | FE |
| 7 | FE-2.1: Kết nối Home Overview thực tế | FE |
