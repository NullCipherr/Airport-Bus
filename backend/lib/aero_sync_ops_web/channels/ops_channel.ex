# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops_web/channels/ops_channel.ex
# =============================================================
defmodule AeroSyncOpsWeb.OpsChannel do
  use AeroSyncOpsWeb, :channel

  @impl true
  def join("ops:lobby", _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end
end
