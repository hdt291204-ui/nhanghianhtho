// Cloudflare Worker + D1 example: handles /api/bookings
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (url.pathname.startsWith('/api/bookings')) {
      const parts = url.pathname.split('/').filter(Boolean); // ["api","bookings",":id"?]
      const id = parts[2];

      try {
        if (request.method === 'GET' && !id) {
          const res = await env.BOOKING_DB.prepare('SELECT * FROM bookings ORDER BY created_at DESC').all();
          return json(200, { ok: true, data: res.results });
        }

        if (request.method === 'GET' && id) {
          const row = await env.BOOKING_DB.prepare('SELECT * FROM bookings WHERE id = ?').bind(id).first();
          if (!row) return json(404, { ok: false, error: 'Not found' });
          return json(200, { ok: true, data: row });
        }

        if (request.method === 'POST') {
          const body = await request.json();
          const { name, phone, email, date, time, guests, note } = body || {};
          if (!name || !date) return json(400, { ok: false, error: 'name and date required' });

          const stmt = env.BOOKING_DB.prepare(
            'INSERT INTO bookings (name, phone, email, date, time, guests, note) VALUES (?,?,?,?,?,?,?)'
          );
          const result = await stmt.run(name, phone || '', email || '', date, time || '', guests || 1, note || '');
          const created = await env.BOOKING_DB.prepare('SELECT * FROM bookings WHERE id = ?').bind(result.lastInsertRowId).first();
          return json(201, { ok: true, data: created });
        }

        if (request.method === 'PUT' && id) {
          const body = await request.json();
          const existing = await env.BOOKING_DB.prepare('SELECT * FROM bookings WHERE id = ?').bind(id).first();
          if (!existing) return json(404, { ok: false, error: 'Not found' });

          const fields = ['name','phone','email','date','time','guests','note'];
          const updates = [];
          const values = [];
          for (const f of fields) {
            if (body[f] !== undefined) { updates.push(`${f} = ?`); values.push(body[f]); }
          }
          values.push(id);
          if (updates.length === 0) return json(400, { ok: false, error: 'no fields to update' });

          await env.BOOKING_DB.prepare(`UPDATE bookings SET ${updates.join(',')}, updated_at = CURRENT_TIMESTAMP WHERE id = ?`).run(...values);
          const updated = await env.BOOKING_DB.prepare('SELECT * FROM bookings WHERE id = ?').bind(id).first();
          return json(200, { ok: true, data: updated });
        }

        if (request.method === 'DELETE' && id) {
          // optional admin protection will be added if requested
          await env.BOOKING_DB.prepare('DELETE FROM bookings WHERE id = ?').bind(id).run();
          return new Response(null, { status: 204 });
        }

        return json(405, { ok: false, error: 'Method not allowed' });
      } catch (err) {
        return json(500, { ok: false, error: err.message });
      }
    }

    // fallback: serve site
    return fetch(request);
  }
};

function json(status, body) {
  return new Response(JSON.stringify(body), { status, headers: { 'Content-Type': 'application/json' } });
}
