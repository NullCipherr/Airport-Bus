# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops_web/controllers/belt_controller.ex
# =============================================================
defmodule AeroSyncOpsWeb.BeltController do
  use AeroSyncOpsWeb, :controller

  alias AeroSyncOps.Ops
  alias AeroSyncOps.Ops.Belt

  action_fallback AeroSyncOpsWeb.FallbackController

  def index(conn, _params), do: json(conn, %{data: Ops.list_belts()})
  def show(conn, %{"id" => id}), do: json(conn, %{data: Ops.get_belt!(id)})

  def create(conn, params) do
    with {:ok, %Belt{} = belt} <- Ops.create_belt(params) do
      conn |> put_status(:created) |> json(%{data: belt})
    end
  end

  def update(conn, %{"id" => id} = params) do
    belt = Ops.get_belt!(id)

    with {:ok, %Belt{} = belt} <- Ops.update_belt(belt, Map.delete(params, "id")) do
      json(conn, %{data: belt})
    end
  end

  def delete(conn, %{"id" => id}) do
    belt = Ops.get_belt!(id)

    with {:ok, %Belt{}} <- Ops.delete_belt(belt) do
      send_resp(conn, :no_content, "")
    end
  end
end
