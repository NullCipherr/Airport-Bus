# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops_web/controllers/team_controller.ex
# =============================================================
defmodule AeroSyncOpsWeb.TeamController do
  use AeroSyncOpsWeb, :controller

  alias AeroSyncOps.Ops
  alias AeroSyncOps.Ops.Team

  action_fallback AeroSyncOpsWeb.FallbackController

  def index(conn, _params), do: json(conn, %{data: Ops.list_teams()})
  def show(conn, %{"id" => id}), do: json(conn, %{data: Ops.get_team!(id)})

  def create(conn, params) do
    with {:ok, %Team{} = team} <- Ops.create_team(params) do
      conn |> put_status(:created) |> json(%{data: team})
    end
  end

  def update(conn, %{"id" => id} = params) do
    team = Ops.get_team!(id)

    with {:ok, %Team{} = team} <- Ops.update_team(team, Map.delete(params, "id")) do
      json(conn, %{data: team})
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Ops.get_team!(id)

    with {:ok, %Team{}} <- Ops.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end
end
