# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/Dockerfile
# =============================================================

FROM elixir:1.17

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential git curl postgresql-client && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs ./
COPY config ./config

RUN mix deps.get

COPY . .

EXPOSE 4000

CMD ["sh", "-c", "mix ecto.create && mix ecto.migrate && mix run priv/repo/seeds.exs && mix phx.server"]
