# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops_web/error_json.ex
# =============================================================
defmodule AeroSyncOpsWeb.ErrorJSON do
  def render("404.json", _assigns), do: %{error: "Recurso não encontrado"}
  def render("500.json", _assigns), do: %{error: "Erro interno"}
  def render("400.json", %{reason: reason}), do: %{error: reason}
end
