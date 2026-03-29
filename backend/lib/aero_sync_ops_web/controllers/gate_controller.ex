# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops_web/controllers/gate_controller.ex
# =============================================================
defmodule AeroSyncOpsWeb.GateController do
  use AeroSyncOpsWeb, :controller

  alias AeroSyncOps.Ops
  alias AeroSyncOps.Ops.Gate

  action_fallback AeroSyncOpsWeb.FallbackController

  def index(conn, _params), do: json(conn, %{data: Ops.list_gates()})
  def show(conn, %{"id" => id}), do: json(conn, %{data: Ops.get_gate!(id)})

  def create(conn, params) do
    with {:ok, %Gate{} = gate} <- Ops.create_gate(params) do
      conn |> put_status(:created) |> json(%{data: gate})
    end
  end

  def update(conn, %{"id" => id} = params) do
    gate = Ops.get_gate!(id)

    with {:ok, %Gate{} = gate} <- Ops.update_gate(gate, Map.delete(params, "id")) do
      json(conn, %{data: gate})
    end
  end

  def delete(conn, %{"id" => id}) do
    gate = Ops.get_gate!(id)

    with {:ok, %Gate{}} <- Ops.delete_gate(gate) do
      send_resp(conn, :no_content, "")
    end
  end
end
