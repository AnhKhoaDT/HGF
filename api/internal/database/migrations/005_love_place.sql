
-- +goose Up
-- +goose StatementBegin
CREATE TABLE user_saved_places (
    user_id UUID REFERENCES user_credentials(id) ON DELETE CASCADE,
    place_id UUID REFERENCES places(id) ON DELETE CASCADE,
    saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    note TEXT, -- Lý do lưu: "Thấy review bảo món cua ở đây rất ngon"
    PRIMARY KEY (user_id, place_id)
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS user_saved_places;
-- +goose StatementEnd