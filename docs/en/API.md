# API

## Base URL

- Local development: `http://localhost:4000/api`
- Docker Compose: `http://localhost:4000/api`

## Authentication

### `POST /auth/login`

Authenticates an operator and returns a signed token.

Request:

```json
{
  "email": "supervisor@aerosync.local",
  "password": "AeroSync123!"
}
```

Response `200`:

```json
{
  "token": "<token>",
  "user": {
    "id": "uuid",
    "name": "Mariana Souza",
    "role": "supervisor",
    "email": "supervisor@aerosync.local"
  }
}
```

## Authenticated endpoints

Header required:

```text
Authorization: Bearer <token>
```

### Health and dashboard

- `GET /health`
- `GET /dashboard/overview`
- `GET /dashboard/events`

### Flight operations

- `GET /flights`
- `GET /flights/:id`
- `POST /flights`
- `PUT /flights/:id`
- `DELETE /flights/:id`
- `POST /flights/:id/simulate-delay`

### Operational resources

- `GET/POST/PUT/DELETE /employees`
- `GET/POST/PUT/DELETE /teams`
- `GET/POST/PUT/DELETE /gates`
- `GET/POST/PUT/DELETE /belts`
- `GET/POST/PUT/DELETE /schedules`
- `GET /alerts`

### Stress and realtime operations

- `POST /operations/simulate-reallocation`
- `POST /operations/massive-seed`
- `GET /operations/massive-seed/status`
- `POST /operations/realtime-storm/start`
- `POST /operations/realtime-storm/stop`
- `GET /operations/realtime-storm/status`

## Common status codes

- `200`: success.
- `201`: resource created.
- `204`: resource removed.
- `400`: invalid payload.
- `401`: unauthorized.
- `422`: validation error.
