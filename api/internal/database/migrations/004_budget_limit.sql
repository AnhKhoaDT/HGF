
-- +goose Up
-- +goose StatementBegin


CREATE TABLE itinerary_expenses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    itinerary_id UUID REFERENCES itineraries(id) ON DELETE CASCADE,
    itinerary_item_id UUID REFERENCES itinerary_items(id) ON DELETE SET NULL, -- Chi tiêu này thuộc hoạt động nào

    amount DECIMAL(15, 2) NOT NULL, -- Số tiền
    currency VARCHAR(10) DEFAULT 'VND',
    expense_category VARCHAR(50), -- 'food', 'transport', 'accommodation', 'entertainment', 'shopping'
    title VARCHAR(255) NOT NULL, -- Ví dụ: "Mua vé Vinpearl", "Ăn hải sản tối"
    note TEXT,
    spent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Thêm trường ngân sách vào bảng itineraries hiện tại của bạn:
ALTER TABLE itineraries ADD COLUMN budget_limit DECIMAL(15, 2) DEFAULT 0;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS itinerary_expenses;
ALTER TABLE itineraries DROP COLUMN budget_limit;
-- +goose StatementEnd