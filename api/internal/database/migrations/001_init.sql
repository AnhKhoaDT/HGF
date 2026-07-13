-- +goose Up
-- +goose StatementBegin

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE user_credentials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    provider VARCHAR(50) DEFAULT 'local', -- 'local', 'google', 'apple'
    provider_id VARCHAR(255), 
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_profiles (
    user_id UUID PRIMARY KEY REFERENCES user_credentials(id) ON DELETE CASCADE,
    full_name VARCHAR(255),
    avatar_url VARCHAR(500),
    phone_number VARCHAR(20),
    home_address TEXT,
    
    current_lat DOUBLE PRECISION,
    current_lng DOUBLE PRECISION,
    current_checkin_at TIMESTAMP,
    
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE administrative_divisions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    parent_id UUID REFERENCES administrative_divisions(id) ON DELETE SET NULL,
    level VARCHAR(50) NOT NULL, -- 'country', 'province', 'city', 'district'
    name VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL, -- 'active', 'inactive','deleted'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_admin_divisions_parent ON administrative_divisions(parent_id);

CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50),
    status VARCHAR(50) NOT NULL, -- 'active', 'inactive','deleted'
    icon_url VARCHAR(500)
);



CREATE TABLE places (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    division_id UUID REFERENCES administrative_divisions(id) ON DELETE SET NULL,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    
    name TEXT NOT NULL,              
    title VARCHAR(500),                
    description JSONB NOT NULL DEFAULT '{}'::jsonb, --html 
    address_raw TEXT NOT NULL,        
    
    lat DOUBLE PRECISION NOT NULL,
    lng DOUBLE PRECISION NOT NULL,
    images JSONB NOT NULL DEFAULT '[]'::jsonb, 
    status VARCHAR(50) NOT NULL, -- 'active', 'inactive','deleted'
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb, --{infos : [{field:"price",value:"1000"},{field:"opening_hours",value:"9:00-17:00"}]}, 
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_places_division ON places(division_id);
CREATE INDEX idx_places_category ON places(category_id);


CREATE TABLE itineraries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES user_credentials(id) ON DELETE CASCADE,
    division_id UUID REFERENCES administrative_divisions(id) ON DELETE SET NULL, 
    
    trip_name VARCHAR(255) NOT NULL,
    start_date DATE,
    end_date DATE,
    is_ai_generated BOOLEAN DEFAULT FALSE, 
    lang_code VARCHAR(10) DEFAULT 'vi', 
    status VARCHAR(50) NOT NULL, -- 'active', 'inactive','deleted'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE itinerary_days (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    itinerary_id UUID REFERENCES itineraries(id) ON DELETE CASCADE,
    day_index INT NOT NULL, 
    date DATE,
    note TEXT,
    UNIQUE(itinerary_id, day_index) 
);

CREATE TABLE itinerary_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    itinerary_day_id UUID REFERENCES itinerary_days(id) ON DELETE CASCADE,
    place_id UUID REFERENCES places(id) ON DELETE CASCADE,
    
    start_time TIME,
    end_time TIME,
    order_index INT NOT NULL, 
    note TEXT,
    ai_note_translations JSONB DEFAULT '{}'::jsonb 
);
CREATE INDEX idx_itinerary_items_order ON itinerary_items(itinerary_day_id, order_index);


-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS itinerary_items ;
DROP TABLE IF EXISTS itinerary_days ;
DROP TABLE IF EXISTS itineraries ;
DROP TABLE IF EXISTS places ;
DROP TABLE IF EXISTS categories ;
DROP TABLE IF EXISTS administrative_divisions ;
DROP TABLE IF EXISTS user_profiles ;
DROP TABLE IF EXISTS user_credentials ;
-- +goose StatementEnd