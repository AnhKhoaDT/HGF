-- +goose Up
-- +goose StatementBegin

CREATE TABLE refresh_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES user_credentials(id) ON DELETE CASCADE,
    
    token TEXT UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL, -- Thời điểm token hết hạn
    is_revoked BOOLEAN DEFAULT FALSE, -- Trạng thái thu hồi (để block token khi user đăng xuất hoặc đổi pass)
    
    -- Các trường tùy chọn thêm để theo dõi bảo mật (thiết bị đăng nhập, IP)
    client_ip VARCHAR(45),
    user_agent TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tạo index để truy vấn nhanh khi kiểm tra token hoặc query theo user
CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_token ON refresh_tokens(token);

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS refresh_tokens;
-- +goose StatementEnd