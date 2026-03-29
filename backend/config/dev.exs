# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/config/dev.exs
# =============================================================
import Config

config :aero_sync_ops, AeroSyncOps.Repo,
  username: System.get_env("DB_USER") || "postgres",
  password: System.get_env("DB_PASSWORD") || "postgres",
  hostname: System.get_env("DB_HOST") || "localhost",
  database: System.get_env("DB_NAME") || "aerosync_ops_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :aero_sync_ops, AeroSyncOpsWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: String.to_integer(System.get_env("PORT") || "4000")],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "ZrF2eEHvE0v8Zuk6KqkQ5yQ+e95n1i6KJ1kUvGf0QYvB9jXbQpkZCCY7xg2E7DE7",
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
