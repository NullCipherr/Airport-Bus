# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops_web/controllers/employee_controller.ex
# =============================================================
defmodule AeroSyncOpsWeb.EmployeeController do
  use AeroSyncOpsWeb, :controller

  alias AeroSyncOps.Ops
  alias AeroSyncOps.Ops.Employee

  action_fallback AeroSyncOpsWeb.FallbackController

  def index(conn, _params), do: json(conn, %{data: Ops.list_employees()})
  def show(conn, %{"id" => id}), do: json(conn, %{data: Ops.get_employee!(id)})

  def create(conn, params) do
    with {:ok, %Employee{} = employee} <- Ops.create_employee(params) do
      conn |> put_status(:created) |> json(%{data: employee})
    end
  end

  def update(conn, %{"id" => id} = params) do
    employee = Ops.get_employee!(id)

    with {:ok, %Employee{} = employee} <- Ops.update_employee(employee, Map.delete(params, "id")) do
      json(conn, %{data: employee})
    end
  end

  def delete(conn, %{"id" => id}) do
    employee = Ops.get_employee!(id)

    with {:ok, %Employee{}} <- Ops.delete_employee(employee) do
      send_resp(conn, :no_content, "")
    end
  end
end
