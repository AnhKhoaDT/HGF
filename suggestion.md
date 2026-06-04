# 🗺️ Hidden Gems Finder — Kế Hoạch Tính Năng Toàn Diện

---

## 1. Phân Loại Người Dùng (User Roles)

### 👤 Regular User (Người dùng thường)
- Đăng ký/Đăng nhập, xem & tương tác với bài đăng
- Check-in địa điểm, viết review, đăng ảnh/video
- Nhận EXP, lên cấp, mở huy hiệu
- Lưu địa điểm yêu thích, theo dõi user khác

### 🏪 Business Owner (Chủ quán / Chủ địa điểm)
- Tất cả quyền Regular User
- Claim & quản lý trang địa điểm của mình
- Đăng khuyến mãi, cập nhật menu/giờ mở cửa
- Xem thống kê lượt xem, check-in, đánh giá
- Phản hồi review của khách hàng

### 🛡️ Moderator (Quản lý nội dung)
- Duyệt bài đăng, địa điểm mới, báo cáo vi phạm
- Ẩn/xóa nội dung vi phạm
- Cảnh cáo hoặc tạm khóa user vi phạm

### 👑 Admin (Quản trị viên)
- Toàn quyền hệ thống
- Quản lý user, role, phân quyền
- Xem dashboard thống kê toàn hệ thống
- Quản lý danh mục, cấu hình app
- Quản lý Business Owner verification

---

## 2. Tính Năng Theo Module

### 🔐 Module: Authentication & User
| Tính năng | Mô tả |
|-----------|--------|
| Đăng ký / Đăng nhập Email | ✅ Đã có |
| Đăng nhập Google / Apple | OAuth2 social login |
| Quên mật khẩu | Gửi email reset |
| Xác thực email | Gửi mã OTP qua email |
| Quản lý profile | Sửa tên, avatar, bio |
| Đổi mật khẩu | Trong app |
| Xóa tài khoản | GDPR compliance |

### 📍 Module: Gems (Địa Điểm)
| Tính năng | Mô tả |
|-----------|--------|
| Tạo địa điểm mới | User submit, chờ duyệt |
| Chi tiết địa điểm | Tên, mô tả, ảnh, video, tọa độ, giờ mở cửa |
| Danh mục | Quán cafe, Ăn uống, Sống ảo, Thiên nhiên, Di tích, Nightlife... |
| Tags | #rooftop #view #instagrammable #hidden #budget... |
| Độ khó tìm | Easy / Medium / Hard / Extreme |
| Trạng thái | Pending → Approved → Featured / Rejected |
| Tìm kiếm | Theo tên, danh mục, tag, khoảng cách |
| Filter | Theo danh mục, khoảng cách, rating, độ khó |
| Sắp xếp | Gần nhất, mới nhất, nhiều like nhất, rating cao nhất |
| Bản đồ | Hiển thị gems trên Google Maps, cluster markers |
| Chỉ đường | Mở Google Maps / trong app navigation |

### 📝 Module: Bài Đăng & Review
| Tính năng | Mô tả |
|-----------|--------|
| Viết review | Text + ảnh + rating (1-5 sao) |
| Đăng video ngắn | TikTok-style review (15-60s) |
| Like / Unlike | Bài viết và video |
| Comment | Bình luận dưới bài, trả lời comment |
| Bookmark | Lưu bài viết yêu thích |
| Share | Chia sẻ ra mạng xã hội khác |
| Report | Báo cáo nội dung vi phạm |

### 📸 Module: Check-in & Gamification
| Tính năng | Mô tả |
|-----------|--------|
| Check-in | Xác nhận đã đến địa điểm (GPS verify) |
| EXP Points | Nhận điểm khi check-in, review, đăng video |
| Level System | ✅ Đã có (7 cấp từ Nhà Thám Hiểm → Huyền Thoại) |
| Huy hiệu | "Check-in 10 quán", "Reviewer chăm chỉ", "Video Star"... |
| Streak | Check-in liên tiếp N ngày → bonus EXP |
| Leaderboard | Bảng xếp hạng tuần/tháng/all-time |
| Thử thách | "Khám phá 5 quán cafe tuần này" → thưởng EXP |

### 👥 Module: Social
| Tính năng | Mô tả |
|-----------|--------|
| Follow / Unfollow | Theo dõi user khác |
| News Feed | Bài đăng từ người theo dõi |
| Discover Feed | Bài đăng trending / gợi ý |
| Thông báo | Like, comment, follow, check-in bạn bè |
| Chat / Nhắn tin | Nhắn tin riêng giữa 2 user |

### 🎬 Module: Video Feed
| Tính năng | Mô tả |
|-----------|--------|
| Video feed dọc | Vuốt lên/xuống kiểu TikTok |
| Upload video | Quay trực tiếp hoặc chọn từ thư viện |
| Hashtag | Gắn tag cho video |

### 🧭 Module: AR Navigation
| Tính năng | Mô tả |
|-----------|--------|
| AR Wayfinder | Mũi tên chỉ đường 3D trên camera |
| AR Info Overlay | Hiện thông tin gem khi hướng camera đến |

### 🏪 Module: Business Owner
| Tính năng | Mô tả |
|-----------|--------|
| Claim địa điểm | Xác nhận mình là chủ |
| Business Dashboard | Thống kê views, check-ins, ratings |
| Quản lý thông tin | Menu, giờ mở cửa, ảnh, liên hệ |
| Đăng khuyến mãi | Giảm giá, voucher cho user check-in |
| Phản hồi review | Reply trực tiếp dưới review |

### 🛡️ Module: Admin Panel (Web Dashboard)
| Tính năng | Mô tả |
|-----------|--------|
| Dashboard | Thống kê user, gems, bài đăng |
| Quản lý User | Xem, khóa, xóa, đổi role |
| Quản lý Gems | Duyệt/từ chối địa điểm mới |
| Quản lý Report | Xử lý báo cáo vi phạm |
| Quản lý Danh mục | CRUD categories & tags |
| Quản lý Business | Duyệt yêu cầu claim, xác minh |
| Cấu hình hệ thống | EXP rules, level config, featured gems |

### 🔔 Module: Notification
| Tính năng | Mô tả |
|-----------|--------|
| Push notification | FCM cho Android/iOS |
| In-app notification | Danh sách thông báo trong app |

---

## 3. Danh Mục Địa Điểm Đề Xuất

| Icon | Danh mục | Ví dụ |
|------|----------|-------|
| ☕ | Cafe & Trà | Cafe rooftop, trà đạo, specialty coffee |
| 🍜 | Ăn uống | Quán ăn ẩn, street food, fine dining |
| 📸 | Sống ảo | Góc check-in, tường graffiti, view đẹp |
| 🌿 | Thiên nhiên | Thác nước, suối, đồi, hang động |
| 🏛️ | Di tích | Chùa, đình, bảo tàng, phố cổ |
| 🌙 | Nightlife | Bar, pub, rooftop lounge |
| 🛍️ | Mua sắm | Chợ đêm, vintage shop, handmade |
| ⛰️ | Trekking | Đường trail, camping, leo núi |
| 🎨 | Nghệ thuật | Gallery, street art, workshop |

---

## 4. Database Schema Mở Rộng (Cần thêm)

```
categories, gem_tags, gem_photos, reviews, review_photos,
comments, likes, bookmarks, follows, notifications, reports,
badges, user_badges, challenges, user_challenges,
business_claims, promotions, messages, conversations
```

---

## 5. EXP Rules Đề Xuất

| Hành động | EXP |
|-----------|-----|
| Check-in địa điểm | +10 |
| Check-in lần đầu | +25 |
| Viết review (có ảnh) | +15 |
| Đăng video | +20 |
| Review được like | +2/like |
| Đề xuất địa điểm được duyệt | +50 |
| Streak 7 ngày | +30 bonus |
| Hoàn thành thử thách | +50-200 |

---

## 6. Lộ Trình Phát Triển (6 Phases)

### Phase 1: Foundation ✅ (Đã xong)
- Auth, JWT, Profile, Gamification base

### Phase 2: Core Gems (4-6 tuần)
- CRUD Gems + Categories + Tags + Photos
- Google Maps, Tìm kiếm & Filter
- Admin duyệt địa điểm

### Phase 3: Social & Review (4-6 tuần)
- Review + Rating + Comment
- Like / Bookmark / Follow
- Check-in GPS, News Feed, Push Notification

### Phase 4: Video & Media (3-4 tuần)
- Upload & stream video (HLS)
- Video feed dọc, likes & comments

### Phase 5: Business & Admin (3-4 tuần)
- Business Owner role & dashboard
- Admin web panel (Next.js)
- Report & moderation

### Phase 6: Advanced (4-6 tuần)
- AR Navigation, Badges & Challenges
- Leaderboard, Chat, Offline mode, Deep linking

---

## 7. Tech Stack

| Layer | Tech |
|-------|------|
| Mobile | Flutter (Dart) |
| Backend | Go + Gin |
| Database | PostgreSQL + PostGIS |
| Cache | Redis |
| Storage | AWS S3 / Firebase Storage |
| Video | FFmpeg + HLS |
| Push | Firebase Cloud Messaging |
| Maps | Google Maps SDK |
| AR | ARCore / ARKit |
| Admin Panel | Next.js |

---

> **Ghi chú:** Nên bắt đầu Phase 2 (Core Gems) ngay vì đây là tính năng cốt lõi.
