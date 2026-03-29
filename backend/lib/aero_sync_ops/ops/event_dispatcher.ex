# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/ops/event_dispatcher.ex
# =============================================================
defmodule AeroSyncOps.Ops.EventDispatcher do
  @moduledoc """
  Processo dedicado para propagação de eventos operacionais em tempo real.
  """
  use GenServer

  alias AeroSyncOpsWeb.Endpoint

  def start_link(_opts), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def broadcast(event, payload) do
    GenServer.cast(__MODULE__, {:broadcast, event, payload})
  end

  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_cast({:broadcast, event, payload}, state) do
    # Broadcast centralizado para desacoplar domínio da camada websocket.
    Endpoint.broadcast("ops:lobby", event, payload)
    {:noreply, state}
  end
end
