# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops_web/controllers/auth_controller.ex
# =============================================================
defmodule AeroSyncOpsWeb.AuthController do
  use AeroSyncOpsWeb, :controller

  alias AeroSyncOps.Accounts
  action_fallback AeroSyncOpsWeb.FallbackController

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, user, token} <- Accounts.authenticate(email, password) do
      json(conn, %{token: token, user: %{id: user.id, name: user.name, role: user.role, email: user.email}})
    end
  end

  def login(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "email e password são obrigatórios"})
  end
end
