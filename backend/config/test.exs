# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/config/test.exs
# =============================================================
import Config

config :aero_sync_ops, AeroSyncOps.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "aerosync_ops_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :aero_sync_ops, AeroSyncOpsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "test_secret_key_base_test_secret_key_base",
  server: false

config :logger, level: :warning
