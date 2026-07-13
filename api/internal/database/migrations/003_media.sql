-- +goose Up
-- +goose StatementBegin

CREATE TABLE trip_media (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES user_credentials(id) NOT NULL  ,
    itinerary_id UUID REFERENCES itineraries(id) ,
    itinerary_item_id UUID REFERENCES itinerary_items(id) , -- Gắn với điểm đến cụ thể (Vinpearl)
    place_id UUID REFERENCES places(id) , -- Đề phòng sau này muốn lấy "Tất cả ảnh public về Vinpearl"
    
    media_url VARCHAR(1000) NOT NULL,
    media_type VARCHAR(20) DEFAULT 'image', -- 'image', 'video'
    caption TEXT, -- Dòng trạng thái cho bức ảnh
    
    -- Trích xuất từ EXIF của ảnh (rất quan trọng cho app du lịch)
    shot_at TIMESTAMP, 
    
    status VARCHAR(50) DEFAULT 'active',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_trip_media_itinerary ON trip_media(itinerary_id);
CREATE INDEX idx_trip_media_item ON trip_media(itinerary_item_id);
CREATE INDEX idx_trip_media_place ON trip_media(place_id);


-- Thêm cờ public/private cho itineraries để làm Mạng Xã Hội
ALTER TABLE itineraries ADD COLUMN visibility VARCHAR(20) DEFAULT 'private'; -- 'private', 'public', 'friends_only'

-- +goose StatementEnd
-- +goose StatementBegin
DROP TABLE IF EXISTS trip_media;
alter table itineraries drop column visibility;
-- +goose StatementEnd