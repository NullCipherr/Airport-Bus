# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops_web/controllers/flight_controller.ex
# =============================================================
defmodule AeroSyncOpsWeb.FlightController do
  use AeroSyncOpsWeb, :controller

  alias AeroSyncOps.Ops
  alias AeroSyncOps.Ops.Flight

  action_fallback AeroSyncOpsWeb.FallbackController

  def index(conn, params) do
    limit = parse_int(params["limit"])
    safe_limit = if(limit > 0, do: min(limit, 2_000), else: 300)
    json(conn, %{data: Ops.list_flights(limit: safe_limit)})
  end

  def show(conn, %{"id" => id}), do: json(conn, %{data: Ops.get_flight!(id)})

  def create(conn, params) do
    with {:ok, %Flight{} = flight} <- Ops.create_flight(params) do
      conn
      |> put_status(:created)
      |> json(%{data: flight})
    end
  end

  def update(conn, %{"id" => id} = params) do
    flight = Ops.get_flight!(id)

    with {:ok, %Flight{} = updated_flight} <- Ops.update_flight(flight, Map.delete(params, "id")) do
      json(conn, %{data: updated_flight})
    end
  end

  def delete(conn, %{"id" => id}) do
    flight = Ops.get_flight!(id)

    with {:ok, %Flight{}} <- Ops.delete_flight(flight) do
      send_resp(conn, :no_content, "")
    end
  end

  def simulate_delay(conn, %{"id" => id, "delay_minutes" => delay_minutes}) do
    minutes = parse_int(delay_minutes)

    with true <- minutes > 0,
         {:ok, flight} <- Ops.simulate_delay(id, minutes) do
      json(conn, %{data: flight, message: "Atraso simulado com sucesso"})
    else
      false ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "delay_minutes deve ser maior que zero"})
    end
  end

  def simulate_delay(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "delay_minutes é obrigatório"})
  end

  defp parse_int(value) when is_integer(value), do: value

  defp parse_int(value) when is_binary(value) do
    case Integer.parse(value) do
      {int, _} -> int
      _ -> 0
    end
  end

  defp parse_int(_), do: 0
end
