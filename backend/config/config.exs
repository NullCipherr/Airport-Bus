# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/config/config.exs
# =============================================================
import Config

config :aero_sync_ops,
  ecto_repos: [AeroSyncOps.Repo],
  generators: [binary_id: true]

config :aero_sync_ops, AeroSyncOpsWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: AeroSyncOpsWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: AeroSyncOps.PubSub,
  live_view: [signing_salt: "aerosyncsalt"]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
