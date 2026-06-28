-- 1. Bật các Extension cần thiết
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS vector;

-- ==========================================
-- PHẦN 1: BẢO MẬT TÀI KHOẢN & THÔNG TIN NGƯỜI DÙNG
-- ==========================================

-- 1A. Bảng quản lý đăng nhập (Chỉ phục vụ Auth)
CREATE TABLE user_credentials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL, -- Sẽ trống nếu user chỉ đăng nhập qua Google/Apple
    provider VARCHAR(50) DEFAULT 'local', -- 'local', 'google', 'apple'
    provider_id VARCHAR(255), -- ID định danh từ Google/Apple gửi về
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 1B. Bảng thông tin cá nhân (Profile - Mở rộng thoải mái)
CREATE TABLE user_profiles (
    user_id UUID PRIMARY KEY REFERENCES user_credentials(id) ON DELETE CASCADE,
    full_name VARCHAR(255),
    avatar_url VARCHAR(500),
    phone_number VARCHAR(20),
    home_address TEXT,
    
    -- Vị trí Check-in hiện tại của User (Phục vụ gợi ý địa điểm real-time theo tọa độ)
    current_lat DOUBLE PRECISION,
    current_lng DOUBLE PRECISION,
    current_checkin_at TIMESTAMP,
    
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ==========================================
-- PHẦN 2: ĐƠN VỊ HÀNH CHÍNH & DANH MỤC (MASTER DATA)
-- ==========================================

-- Bảng Đơn vị hành chính toàn cầu (Quốc gia -> Tỉnh -> Thành phố)
CREATE TABLE administrative_divisions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    parent_id UUID REFERENCES administrative_divisions(id) ON DELETE SET NULL,
    level VARCHAR(50) NOT NULL, -- 'country', 'province', 'city', 'district'
    name_translations JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_admin_divisions_parent ON administrative_divisions(parent_id);

-- Bảng Danh mục địa điểm
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name_translations JSONB NOT NULL DEFAULT '{}'::jsonb, -- {"vi": "Khách sạn", "en": "Hotel"}
    icon_url VARCHAR(500)
);


-- ==========================================
-- PHẦN 3: TRUNG TÂM DỮ LIỆU ĐỊA ĐIỂM (PLACES - ĐẦY ĐỦ CỘT)
-- ==========================================

CREATE TABLE places (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    division_id UUID REFERENCES administrative_divisions(id) ON DELETE SET NULL,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    
    -- Thông tin cơ bản hiển thị trực tiếp
    name TEXT NOT NULL,                  -- Tên địa điểm mặc định
    title VARCHAR(500),                  -- Tiêu đề ngắn gọn / Slogan (nếu có)
    description TEXT,                    -- Mô tả chi tiết về địa điểm
    address_raw TEXT NOT NULL,           -- Địa chỉ chữ đầy đủ
    
    -- Định vị & Hình ảnh
    lat DOUBLE PRECISION NOT NULL,
    lng DOUBLE PRECISION NOT NULL,
    images TEXT[],                       -- Mảng lưu các link ảnh tĩnh của địa điểm
    

    -- metadata
    -- Thông tin vận hành cốt lõi
    -- open_time TIME,                      -- Giờ mở cửa (VD: 07:30:00)
    -- close_time TIME,                     -- Giờ đóng cửa (VD: 22:00:00)
    -- price_min NUMERIC(15, 2),            -- Giá thấp nhất (Dùng NUMERIC cho tiền tệ)
    -- price_max NUMERIC(15, 2),            -- Giá cao nhất
    -- currency VARCHAR(10) DEFAULT 'VND',  -- Đơn vị tiền tệ
    
    -- Hệ thống AI nhúng & Dữ liệu động mở rộng
    metadata_translations JSONB NOT NULL DEFAULT '{}'::jsonb, -- Bạn vẫn có thể dùng để lưu các trường đặc thù của riêng quán ăn/khách sạn
    embedding VECTOR(768),               -- Vector phục vụ Semantic Search
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_places_division ON places(division_id);
CREATE INDEX idx_places_category ON places(category_id);
CREATE INDEX idx_places_geo ON places(lat, lng); -- Index tăng tốc truy vấn bán kính khoảng cách



-- ==========================================
-- PHẦN 5: HỆ THỐNG LỊCH TRÌNH (ITINERARY)
-- ==========================================

CREATE TABLE itineraries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES user_credentials(id) ON DELETE CASCADE,
    division_id UUID REFERENCES administrative_divisions(id) ON DELETE SET NULL, 
    
    trip_name VARCHAR(255) NOT NULL,
    start_date DATE,
    end_date DATE,
    is_ai_generated BOOLEAN DEFAULT FALSE, 
    lang_code VARCHAR(10) DEFAULT 'vi', 
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE itinerary_days (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    itinerary_id UUID REFERENCES itineraries(id) ON DELETE CASCADE,
    day_index INT NOT NULL, 
    date DATE,
    UNIQUE(itinerary_id, day_index) 
);

CREATE TABLE itinerary_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    itinerary_day_id UUID REFERENCES itinerary_days(id) ON DELETE CASCADE,
    place_id UUID REFERENCES places(id) ON DELETE CASCADE,
    
    start_time TIME,
    end_time TIME,
    order_index INT NOT NULL, 
    ai_note_translations JSONB DEFAULT '{}'::jsonb 
);
CREATE INDEX idx_itinerary_items_order ON itinerary_items(itinerary_day_id, order_index);