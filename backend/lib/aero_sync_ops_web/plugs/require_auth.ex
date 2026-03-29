# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops_web/plugs/require_auth.ex
# =============================================================
defmodule AeroSyncOpsWeb.Plugs.RequireAuth do
  import Plug.Conn

  alias AeroSyncOps.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    # Token assinado pelo Phoenix.Token no login; simples e suficiente para uso interno.
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user} <- Accounts.verify_token(token) do
      assign(conn, :current_user, user)
    else
      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, Jason.encode!(%{error: "Não autorizado"}))
        |> halt()
    end
  end
end
