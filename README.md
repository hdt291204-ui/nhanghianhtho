# Nhà Nghỉ Anh Thơ - Real-time Room Booking System

Hệ thống đặt phòng với đồng bộ hóa real-time sử dụng Cloudflare Workers và D1 Database.

## ✨ Tính năng

- 🏠 Hiển thị danh sách phòng với tính năng tìm kiếm
- 📊 Đồng bộ hóa số lượng phòng real-time trên tất cả user
- 💰 Tính toán giá phòng tự động
- 🌐 WebSocket để cập nhật tức thời
- 📱 Responsive design - hoạt động tốt trên mọi thiết bị
- 💾 Local storage backup khi mất kết nối

## 🚀 Deployment

### 1. Chuẩn bị

```bash
npm install -g wrangler
git clone https://github.com/hdt291204-ui/nhanghianhtho
cd nhanghianhtho
npm install
```

### 2. Tạo D1 Database

```bash
# Tạo database mới
wrangler d1 create nhanghianhtho

# Sao chép database_id từ output vào wrangler.toml
```

### 3. Khởi tạo Schema

```bash
wrangler d1 execute nhanghianhtho --file=./schema.sql
```

### 4. Deploy

```bash
wrangler deploy
```

## 📋 API Endpoints

### GET `/api/rooms`
Lấy danh sách phòng và đặt phòng hiện tại.

**Response:**
```json
{
  "rooms": [...],
  "bookings": [...]
}
```

### POST `/api/bookings`
Tạo đặt phòng mới và trừ số lượng phòng available.

**Payload:**
```json
{
  "roomKey": "standard",
  "name": "Nguyễn Văn A",
  "phone": "0123456789",
  "checkin": "2026-06-15",
  "checkout": "2026-06-17",
  "stayType": "standard",
  "note": "Ghi chú thêm"
}
```

### WebSocket `/api/ws`
Kết nối WebSocket để nhận cập nhật real-time về tình trạng phòng.

## 🔧 Cấu trúc Database

### Table: rooms
- `id` - Mã phòng (Primary Key)
- `room_key` - Khóa phòng (standard/family/vip)
- `name` - Tên phòng
- `type` - Loại phòng (1-2 khách, etc)
- `price` - Giá phòng/đêm
- `available` - Số phòng còn trống
- `total` - Tổng số phòng
- `created_at`, `updated_at` - Timestamps

### Table: bookings
- `id` - Mã đặt phòng
- `room_key` - Khóa phòng (Foreign Key)
- `name` - Tên khách
- `phone` - SĐT khách
- `checkin` - Ngày nhận phòng
- `checkout` - Ngày trả phòng
- `stay_type` - Loại lưu trú
- `total_price` - Tổng tiền
- `days` - Số đêm
- `created_at` - Thời gian tạo

## 🌐 Website

https://nhanghianhtho.hoangthinh291204.workers.dev/#rooms

## 👤 Tác giả

- **Hoàng Thị Thịnh** - hdt291204-ui
- **Email:** hoangthinh291204@gmail.com
