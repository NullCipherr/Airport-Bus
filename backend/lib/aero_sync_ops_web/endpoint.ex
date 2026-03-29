# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops_web/endpoint.ex
# =============================================================
defmodule AeroSyncOpsWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :aero_sync_ops

  socket "/socket", AeroSyncOpsWeb.UserSocket,
    websocket: true,
    longpoll: false

  plug CORSPlug, origin: ["http://localhost:5173", "http://127.0.0.1:5173"]
  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]
  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug AeroSyncOpsWeb.Router
end
