# Operação, Deploy e Manutenção

## Pré-requisitos

- Docker e Docker Compose; ou
- Elixir `>= 1.16`, Erlang/OTP `>= 26`, PostgreSQL `>= 14`, Node `>= 20`.

## Subida rápida com Docker

```bash
docker compose up --build
```

Serviços esperados:

- API: `http://localhost:4000`
- Frontend: `http://localhost:5173`
- Postgres: `localhost:5432`

## Execução manual

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

## Operação diária

- Login seed supervisor: `supervisor@aerosync.local` / `AeroSync123!`
- Login seed operador: `operador@aerosync.local` / `AeroSync123!`
- Canal realtime: `ops:lobby`.

## Manutenção recomendada

- revisar migrations e seeds a cada mudança de domínio;
- validar `scripts/run_tests.sh` antes de merge/deploy;
- manter documentação de API e operação sincronizada com as rotas reais.
