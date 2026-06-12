-- Create rooms table
CREATE TABLE IF NOT EXISTS rooms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    room_key TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    type TEXT,
    price INTEGER,
    note TEXT,
    image TEXT,
    amenities TEXT,
    available INTEGER,
    total INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create bookings table
CREATE TABLE IF NOT EXISTS bookings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    room_key TEXT NOT NULL,
    name TEXT NOT NULL,
    phone TEXT,
    checkin DATE,
    checkout DATE,
    stay_type TEXT,
    note TEXT,
    total_price INTEGER,
    days INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_key) REFERENCES rooms(room_key)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_room_key ON rooms(room_key);
CREATE INDEX IF NOT EXISTS idx_room_booking_key ON bookings(room_key);
CREATE INDEX IF NOT EXISTS idx_checkin ON bookings(checkin);

-- Insert default rooms
INSERT INTO rooms (room_key, name, type, price, note, image, amenities, available, total) VALUES
('standard', 'Phòng Tiêu chuẩn', '1-2 khách', 280000, 'Phù hợp khách đi công tác hoặc lưu trú ngắn ngày cần chi phí hợp lý.', 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=1200', 'Wifi miễn phí,Máy lạnh,Nước nóng', 5, 5),
('family', 'Phòng Gia đình', '3-4 khách', 420000, 'Không gian rộng hơn, thích hợp cho gia đình nhỏ hoặc nhóm bạn đi cùng nhau.', 'https://images.unsplash.com/photo-1560184897-ae75f418493e?w=1200', 'Giường lớn,Bàn làm việc,Khu ngồi nghỉ', 5, 5),
('vip', 'Phòng Cao cấp', '2 khách', 560000, 'Tối ưu cho khách muốn trải nghiệm thoải mái hơn với nội thất hài hòa.', 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=1200', 'Không gian riêng tư,Trang bị tốt hơn,View thoáng', 5, 5);
