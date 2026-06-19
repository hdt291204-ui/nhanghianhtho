This branch adds a simple bookings API implemented as a Cloudflare Worker backed by a D1 database.

Files added:
- migrations/create_bookings_table.sql  — SQL migration to create the bookings table.
- worker.js                             — Cloudflare Worker handling REST endpoints at /api/bookings.
- wrangler.toml                         — example Wrangler config with D1 binding (BOOKING_DB).
- public/booking-client.js              — small frontend helper to POST bookings.

Quick setup and deploy (local machine with Wrangler installed):

1) Create a D1 database in Cloudflare (name used in wrangler.toml: booking-db):
   wrangler d1 create booking-db

2) Create and apply a migration (this repository includes migrations/create_bookings_table.sql):
   # create migration from existing SQL file
   # or run directly:
   wrangler d1 migrations create init --sql "$(cat migrations/create_bookings_table.sql)"
   wrangler d1 migrations apply

3) Set D1 binding and publish the worker:
   # Ensure wrangler.toml is configured and your account is logged in
   wrangler publish

4) (Optional) Test locally:
   wrangler dev --local

Notes:
- The API endpoints:
  GET  /api/bookings         -> list bookings
  GET  /api/bookings/:id     -> get booking
  POST /api/bookings         -> create booking (body: name, date, phone, email, time, guests, note)
  PUT  /api/bookings/:id     -> update booking (partial updates allowed)
  DELETE /api/bookings/:id  -> delete booking (hard delete by default)

- Default D1 binding name: BOOKING_DB. If you use a different binding name, update wrangler.toml accordingly.
- Admin authentication and soft-delete are NOT enabled in this initial commit. If you want either, tell me and I will add them.

What's next:
- Create a PR from add-booking-api -> default branch (already committed to branch). If you want, I can open the PR for you.
- Create the D1 database and run migrations in your Cloudflare account.
- After publishing, ensure the frontend form posts to /api/bookings (public/booking-client.js helper included).
