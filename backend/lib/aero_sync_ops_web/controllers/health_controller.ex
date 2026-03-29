# =============================================================
# Airport Bus
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops_web/controllers/health_controller.ex
# =============================================================
defmodule AeroSyncOpsWeb.HealthController do
  use AeroSyncOpsWeb, :controller

  def index(conn, _params), do: json(conn, %{status: "ok", service: "Airport Bus API"})
end
