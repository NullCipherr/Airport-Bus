# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops_web/controllers/alert_controller.ex
# =============================================================
defmodule AeroSyncOpsWeb.AlertController do
  use AeroSyncOpsWeb, :controller

  alias AeroSyncOps.Ops

  def index(conn, _params), do: json(conn, %{data: Ops.list_alerts()})
end
