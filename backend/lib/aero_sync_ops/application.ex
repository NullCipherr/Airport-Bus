# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/application.ex
# =============================================================
defmodule AeroSyncOps.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AeroSyncOps.Repo,
      {Phoenix.PubSub, name: AeroSyncOps.PubSub},
      AeroSyncOpsWeb.Endpoint,
      AeroSyncOps.Ops.EventDispatcher,
      AeroSyncOps.Ops.MassiveSeedRunner,
      AeroSyncOps.Ops.RealtimeStorm
    ]

    opts = [strategy: :one_for_one, name: AeroSyncOps.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    AeroSyncOpsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
