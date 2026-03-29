# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops_web/controllers/dashboard_controller.ex
# =============================================================
defmodule AeroSyncOpsWeb.DashboardController do
  use AeroSyncOpsWeb, :controller

  alias AeroSyncOps.Ops

  def overview(conn, params) do
    flights_limit = parse_positive_int(params["flights_limit"], 120)
    alerts_limit = parse_positive_int(params["alerts_limit"], 20)
    events_limit = parse_positive_int(params["events_limit"], 50)

    # Resposta consolidada para reduzir latência no primeiro carregamento do frontend.
    data = %{
      overview: Ops.dashboard_overview(),
      flights: Ops.list_flights(limit: flights_limit),
      alerts: Ops.list_alerts() |> Enum.take(alerts_limit),
      recent_events: Ops.list_recent_events(events_limit)
    }

    json(conn, data)
  end

  def events(conn, _params) do
    json(conn, %{events: Ops.list_recent_events(50)})
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
