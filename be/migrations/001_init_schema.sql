-- Enable PostGIS extension for geospatial features
CREATE EXTENSION IF NOT EXISTS postgis;

-- 1. Users table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    avatar_url TEXT,
    exp_points INT DEFAULT 0,
    level INT DEFAULT 1,
    level_title VARCHAR(100) DEFAULT 'Nhà Thám Hiểm',
    is_active BOOLEAN DEFAULT TRUE,
    last_login_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for users table
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_is_active ON users(is_active);

-- 2. Refresh tokens table
CREATE TABLE IF NOT EXISTS refresh_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(500) UNIQUE NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    is_revoked BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for refresh_tokens table
CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_token ON refresh_tokens(token);
CREATE INDEX idx_refresh_tokens_expires_at ON refresh_tokens(expires_at);
CREATE INDEX idx_refresh_tokens_is_revoked ON refresh_tokens(is_revoked);

-- 3. Gems (Hidden locations) table
CREATE TABLE IF NOT EXISTS gems (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(150) NOT NULL,
    description TEXT,
    difficulty_level VARCHAR(20) DEFAULT 'medium', -- easy, medium, hard, extreme
    
    -- PostGIS geometry column for coordinates (SRID 4326 = WGS84 GPS standard)
    coordinates GEOMETRY(Point, 4326) NOT NULL,
    
    address TEXT,
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    is_approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create spatial index for geospatial queries (CRITICAL for performance)
CREATE INDEX idx_gems_coordinates ON gems USING GIST(coordinates);
CREATE INDEX idx_gems_is_approved ON gems(is_approved);
CREATE INDEX idx_gems_created_by ON gems(created_by);
CREATE INDEX idx_gems_difficulty_level ON gems(difficulty_level);

-- 4. Gem videos table (TikTok-style reviews)
CREATE TABLE IF NOT EXISTS gem_videos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gem_id UUID NOT NULL REFERENCES gems(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    video_url TEXT NOT NULL,           -- HLS stream URL (.m3u8)
    thumbnail_url TEXT,
    likes_count INT DEFAULT 0,
    views_count INT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for gem_videos table
CREATE INDEX idx_gem_videos_gem_id ON gem_videos(gem_id);
CREATE INDEX idx_gem_videos_user_id ON gem_videos(user_id);
CREATE INDEX idx_gem_videos_created_at ON gem_videos(created_at DESC);

-- 5. Video likes table (many-to-many relationship)
CREATE TABLE IF NOT EXISTS video_likes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    video_id UUID NOT NULL REFERENCES gem_videos(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(video_id, user_id)
);

-- Create indexes for video_likes table
CREATE INDEX idx_video_likes_video_id ON video_likes(video_id);
CREATE INDEX idx_video_likes_user_id ON video_likes(user_id);

-- 6. User check-ins table (gamification)
CREATE TABLE IF NOT EXISTS user_check_ins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    gem_id UUID NOT NULL REFERENCES gems(id) ON DELETE CASCADE,
    exp_earned INT DEFAULT 10,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, gem_id)
);

-- Create indexes for user_check_ins table
CREATE INDEX idx_user_check_ins_user_id ON user_check_ins(user_id);
CREATE INDEX idx_user_check_ins_gem_id ON user_check_ins(gem_id);

-- Trigger to update updated_at timestamp automatically
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply trigger to tables
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_refresh_tokens_updated_at BEFORE UPDATE ON refresh_tokens
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_gems_updated_at BEFORE UPDATE ON gems
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_gem_videos_updated_at BEFORE UPDATE ON gem_videos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
