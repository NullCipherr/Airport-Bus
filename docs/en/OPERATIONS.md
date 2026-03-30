# Operations

## Prerequisites

- Docker and Docker Compose; or
- Elixir `>= 1.16`, Erlang/OTP `>= 26`, PostgreSQL `>= 14`, Node `>= 20`.

## Quick start with Docker

```bash
docker compose up --build
```

Expected services:

- API: `http://localhost:4000`
- Frontend: `http://localhost:5173`
- Postgres: `localhost:5432`

## Manual execution

### Backend

```bash
cd backend
mix deps.get
mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs
mix phx.server
```

### Frontend

```bash
cd frontend
npm install
npm run dev
```

## Day-to-day operations

- Seed supervisor: `supervisor@aerosync.local` / `AeroSync123!`
- Seed operator: `operador@aerosync.local` / `AeroSync123!`
- Realtime channel: `ops:lobby`.

## Maintenance guidelines

- review migrations and seeds for every domain change;
- run `scripts/run_tests.sh` before merge/deploy;
- keep API and operations docs in sync with route/controller changes.
