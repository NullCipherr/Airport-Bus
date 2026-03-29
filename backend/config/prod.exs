# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/config/prod.exs
# =============================================================
import Config

config :aero_sync_ops, AeroSyncOpsWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE") || raise("SECRET_KEY_BASE não configurado"),
  server: true

config :aero_sync_ops, AeroSyncOps.Repo,
  url: System.get_env("DATABASE_URL") || raise("DATABASE_URL não configurado"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "20"),
  ssl: false
