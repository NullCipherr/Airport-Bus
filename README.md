<div align="center">
  <img src="docs/assets/airport-bus-logo.svg" alt="Airport Bus Logo" width="240" />
  <h1>Airport Bus</h1>
  <p><i>Real-time airport operations platform with Phoenix API, Channels-based events, and a Vue 3 web console</i></p>

  <p>
    <img src="https://img.shields.io/badge/Elixir-1.16+-4B275F?style=flat-square&logo=elixir&logoColor=white" alt="Elixir" />
    <img src="https://img.shields.io/badge/Phoenix-1.7-FF6F00?style=flat-square&logo=phoenixframework&logoColor=white" alt="Phoenix" />
    <img src="https://img.shields.io/badge/PostgreSQL-14+-336791?style=flat-square&logo=postgresql&logoColor=white" alt="PostgreSQL" />
    <img src="https://img.shields.io/badge/Vue-3-42B883?style=flat-square&logo=vue.js&logoColor=white" alt="Vue 3" />
    <img src="https://img.shields.io/badge/Vite-7-646CFF?style=flat-square&logo=vite&logoColor=white" alt="Vite" />
  </p>
</div>

---

## Documentation

Technical documentation is organized into modules for easier onboarding, operations, and maintenance.
English is the primary language; Portuguese translations are available under `docs/pt-br/`.

- [Documentation index](docs/README.md)
- [Architecture](docs/en/ARCHITECTURE.md)
- [API](docs/en/API.md)
- [Operations](docs/en/OPERATIONS.md)
- [Observability](docs/en/OBSERVABILITY.md)
- [Testing](docs/en/TESTING.md)
- [Metrics Automation](docs/en/METRICS_AUTOMATION.md)
- [Roadmap](docs/en/ROADMAP.md)

---

## Preview

Web interface served by the frontend:

- Local frontend: `http://localhost:5173`
- Local API: `http://localhost:4000/api`

---

## Overview

**Airport Bus** centralizes critical airport operations with a real-time-first approach.

Project priorities:

- stateless API authentication using signed tokens;
- domain rules centralized in the `Ops` context;
- UI updates driven by real-time events via Phoenix Channels;
- a simple stack for local development, Docker execution, and safe incremental evolution.

---

## Features

- **Operator authentication** via `POST /api/auth/login`.
- **Consolidated dashboard** through `GET /api/dashboard/overview`.
- **Full CRUD** for flights, teams, employees, gates, belts, and schedules.
- **Real-time events** on the `ops:lobby` topic for no-refresh updates.
- **Operational simulations** for delays and reallocations.
- **Massive seed and event storm** endpoints for functional stress testing.
- **Validation automation** with report generation in `docs/reports/`.

---

## Architecture

Main request flow:

1. Frontend authenticates using `POST /api/auth/login`.
2. Backend validates credentials and issues a signed token (`Phoenix.Token`).
3. Private routes are protected by the `RequireAuth` plug.
4. Controllers delegate business rules to `AeroSyncOps.Ops`.
5. `AeroSyncOps.Ops.EventDispatcher` publishes events to `ops:lobby`.
6. Channel subscribers receive updates and sync the UI without refresh.

---

## Official Automated Test Results

Reference local run before publication:

- Date: `2026-03-29` (America/Sao_Paulo)
- Execution: `2026-03-29T00:58:30-03:00`
- Script: `scripts/run_tests.sh`
- Artifacts:
  - `docs/reports/latest_test_report.md`
  - `docs/reports/latest_test_report.raw.log`

| Stage | Status | Duration |
| --- | --- | ---: |
| Backend tests (`mix test`) | ok | 2731 ms |
| Backend production build (`MIX_ENV=prod mix compile`) | ok | 28125 ms |
| Frontend build (`npm run build`) | ok | 2545 ms |

---

## Technical Decisions

- **Single domain context (`Ops`)**: reduces business rule duplication in controllers.
- **Phoenix Channels for realtime**: low initial complexity with strong operational value.
- **Shell-based validation pipeline**: simple, reproducible, and report-driven.
- **Backend/frontend separation**: independent deployment and maintenance.

---

## Roadmap

Recommended next steps for project maturity:

- increase test coverage for CRUD endpoints and critical domain rules;
- add Telemetry instrumentation with metrics exporters;
- evolve observability with historical throughput and latency tracking;
- harden scaling strategy for simultaneous high-event scenarios;
- formalize CI pipeline with automated test artifact publication.

---

## Tech Stack

- **Backend**: Elixir `1.16+` + Phoenix `1.7+` + Ecto
- **Database**: PostgreSQL `14+`
- **Realtime**: Phoenix Channels
- **Frontend**: Vue 3 + Pinia + Vue Router + Vite
- **Automation**: Shell script (`scripts/run_tests.sh`)
- **Containerization**: Docker + Docker Compose

---

## Project Structure

```text
.
├── backend/
│   ├── config/
│   ├── lib/
│   ├── priv/repo/
│   └── test/
├── frontend/
│   ├── src/
│   ├── index.html
│   └── package.json
├── scripts/
│   └── run_tests.sh
├── docs/
│   ├── assets/
│   │   └── airport-bus-logo.svg
│   ├── en/
│   │   ├── API.md
│   │   ├── ARCHITECTURE.md
│   │   ├── METRICS_AUTOMATION.md
│   │   ├── OBSERVABILITY.md
│   │   ├── OPERATIONS.md
│   │   ├── ROADMAP.md
│   │   └── TESTING.md
│   ├── pt-br/
│   │   ├── API.md
│   │   ├── ARQUITETURA.md
│   │   ├── METRICAS_AUTOMACAO_SHELL.md
│   │   ├── OBSERVABILIDADE_E_BENCHMARK.md
│   │   ├── OPERACAO_DEPLOY_MANUTENCAO.md
│   │   ├── ROADMAP_TECNICO.md
│   │   └── TESTES_AUTOMATIZADOS.md
│   ├── reports/
│   │   ├── latest_test_report.md
│   │   └── latest_test_report.raw.log
│   └── README.md
├── docker-compose.yml
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE
├── SECURITY.md
└── README.md
```

---

## Getting Started

### Prerequisites

- Elixir `>= 1.16`
- Erlang/OTP `>= 26`
- PostgreSQL `>= 14`
- Node `>= 20`
- Docker 24+ and Docker Compose v2 (optional)

### Run manually

Backend:

```bash
cd backend
mix deps.get
mix ecto.setup
mix phx.server
```

Frontend:

```bash
cd frontend
npm install
npm run dev
```

### Main endpoints

- `POST /api/auth/login`
- `GET /api/health` (authenticated)
- `GET /api/dashboard/overview`
- `GET /api/dashboard/events`
- `POST /api/flights/:id/simulate-delay`
- `POST /api/operations/simulate-reallocation`

---

## Docker Deployment

### Build and start

```bash
docker compose up --build
```

### Operations

```bash
docker compose logs -f
docker compose down
```

### Access

- Frontend: `http://localhost:5173`
- API: `http://localhost:4000/api`
- Postgres: `localhost:5432`

---

## Main Scripts

- `./scripts/run_tests.sh`: runs validations and updates technical reports in `docs/reports/`.
- `SKIP_FRONTEND=1 ./scripts/run_tests.sh`: backend-only validation.
- `cd backend && mix test`: backend test suite.
- `cd backend && MIX_ENV=prod mix compile`: backend production build validation.
- `cd frontend && npm run build`: frontend build validation.
- `docker compose up --build`: starts the containerized stack.

---

## License

Copyright (c) 2026 **Andrei Costa**.
All rights reserved.

This project is **proprietary and confidential**.
Copying, distribution, modification, or use is not allowed without prior written authorization.

See [LICENSE](LICENSE) for full terms.

---

## Contributing

Internal contributions are welcome following the process defined in [CONTRIBUTING.md](CONTRIBUTING.md).

Before contributing, please read:

- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Security Policy](SECURITY.md)

<div align="center">
  Built for real-time operations with a focus on technical clarity, reliability, and incremental evolution.
</div>
