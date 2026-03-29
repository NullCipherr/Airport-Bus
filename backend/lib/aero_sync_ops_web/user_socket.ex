# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops_web/user_socket.ex
# =============================================================
defmodule AeroSyncOpsWeb.UserSocket do
  use Phoenix.Socket

  channel "ops:*", AeroSyncOpsWeb.OpsChannel

  @impl true
  def connect(_params, socket, _connect_info), do: {:ok, socket}

  @impl true
  def id(_socket), do: nil
end
