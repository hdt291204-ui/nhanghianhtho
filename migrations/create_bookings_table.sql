CREATE TABLE IF NOT EXISTS bookings (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT,
  email TEXT,
  date TEXT NOT NULL,
  time TEXT,
  guests INTEGER DEFAULT 1,
  note TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT,
  status TEXT DEFAULT 'active'
);
