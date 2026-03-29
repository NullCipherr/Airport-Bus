# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops_web/controllers/operations_controller.ex
# =============================================================
defmodule AeroSyncOpsWeb.OperationsController do
  use AeroSyncOpsWeb, :controller

  alias AeroSyncOps.Ops

  action_fallback AeroSyncOpsWeb.FallbackController

  def simulate_reallocation(conn, _params) do
    {:ok, reallocations} = Ops.simulate_reallocation()
    json(conn, %{data: reallocations, message: "Simulação de remanejamento executada"})
  end

  def massive_seed(conn, params) do
    opts = [
      gates: parse_positive_int(params["gates"], 60),
      belts: parse_positive_int(params["belts"], 28),
      employees: parse_positive_int(params["employees"], 1800),
      teams: parse_positive_int(params["teams"], 420),
      flights: parse_positive_int(params["flights"], 3200),
      alerts: parse_positive_int(params["alerts"], 900),
      logs: parse_positive_int(params["logs"], 12_000)
    ]

    case Ops.start_massive_seed_job(opts) do
      {:ok, status} ->
        conn
        |> put_status(:accepted)
        |> json(%{data: status, message: "Geração massiva iniciada em background"})

      {:error, :already_running} ->
        conn
        |> put_status(:conflict)
        |> json(%{error: "Já existe uma geração massiva em execução"})
    end
  end

  def massive_seed_status(conn, _params) do
    json(conn, %{data: Ops.massive_seed_status()})
  end

  def start_realtime_storm(conn, params) do
    opts = [
      interval_ms: parse_positive_int(params["interval_ms"], 250),
      batch_size: parse_positive_int(params["batch_size"], 20)
    ]

    {:ok, status} = Ops.start_realtime_storm(opts)
    json(conn, %{data: status, message: "Gerador de eventos em tempo real iniciado"})
  end

  def stop_realtime_storm(conn, _params) do
    {:ok, status} = Ops.stop_realtime_storm()
    json(conn, %{data: status, message: "Gerador de eventos em tempo real interrompido"})
  end

  def realtime_storm_status(conn, _params) do
    json(conn, %{data: Ops.realtime_storm_status()})
  end

  defp parse_positive_int(nil, fallback), do: fallback
  defp parse_positive_int(value, fallback) when is_integer(value), do: if(value > 0, do: value, else: fallback)

  defp parse_positive_int(value, fallback) when is_binary(value) do
    case Integer.parse(value) do
      {int, _} when int > 0 -> int
      _ -> fallback
    end
  end

  defp parse_positive_int(_, fallback), do: fallback
end
