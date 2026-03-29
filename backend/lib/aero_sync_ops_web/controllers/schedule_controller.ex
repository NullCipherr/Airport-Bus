# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops_web/controllers/schedule_controller.ex
# =============================================================
defmodule AeroSyncOpsWeb.ScheduleController do
  use AeroSyncOpsWeb, :controller

  alias AeroSyncOps.Ops
  alias AeroSyncOps.Ops.Schedule

  action_fallback AeroSyncOpsWeb.FallbackController

  def index(conn, _params), do: json(conn, %{data: Ops.list_schedules()})
  def show(conn, %{"id" => id}), do: json(conn, %{data: Ops.get_schedule!(id)})

  def create(conn, params) do
    with {:ok, %Schedule{} = schedule} <- Ops.create_schedule(params) do
      conn |> put_status(:created) |> json(%{data: schedule})
    end
  end

  def update(conn, %{"id" => id} = params) do
    schedule = Ops.get_schedule!(id)

    with {:ok, %Schedule{} = schedule} <- Ops.update_schedule(schedule, Map.delete(params, "id")) do
      json(conn, %{data: schedule})
    end
  end

  def delete(conn, %{"id" => id}) do
    schedule = Ops.get_schedule!(id)

    with {:ok, %Schedule{}} <- Ops.delete_schedule(schedule) do
      send_resp(conn, :no_content, "")
    end
  end
end
