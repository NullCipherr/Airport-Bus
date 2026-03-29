# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/ops/orchestrator.ex
# =============================================================
defmodule AeroSyncOps.Ops.Orchestrator do
  @moduledoc """
  Motor de regras operacionais dinâmicas para atraso, remanejamento e conflitos.
  """

  import Ecto.Query, warn: false

  alias AeroSyncOps.Repo
  alias AeroSyncOps.Ops
  alias AeroSyncOps.Ops.{Assignment, Flight, Team}

  def handle_flight_delay(%Flight{} = flight, delay_minutes) when delay_minutes > 0 do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    # Transação garante consistência entre voo, atribuições, alerta e log.
    Repo.transaction(fn ->
      {:ok, updated_flight} =
        flight
        |> Flight.changeset(%{
          status: :atrasado,
          actual_time: DateTime.add(flight.scheduled_time, delay_minutes * 60, :second)
        })
        |> Repo.update()

      assignment_ids =
        Assignment
        |> where([a], a.flight_id == ^flight.id and a.status in [:alocada, :em_execucao])
        |> select([a], a.id)
        |> Repo.all()

      from(a in Assignment, where: a.id in ^assignment_ids)
      |> Repo.update_all(set: [status: :remanejada, updated_at: now])

      maybe_raise_team_capacity_alert(updated_flight)

      Ops.log_event!(%{
        event_type: "flight_delay",
        message: "Voo #{updated_flight.flight_number} atrasado em #{delay_minutes} minutos",
        payload: %{flight_id: updated_flight.id, delay_minutes: delay_minutes}
      })

      Ops.broadcast_event("flight_updated", Ops.serialize_flight(updated_flight))
      updated_flight
    end)
  end

  def simulate_reallocation do
    # Regras de realocação executadas de forma atômica para evitar estado parcial.
    Repo.transaction(fn ->
      delayed_flights =
        Flight
        |> where([f], f.status == :atrasado)
        |> order_by([f], desc: f.priority)
        |> preload([:assignments])
        |> Repo.all()

      available_teams =
        Team
        |> where([t], t.is_available == true)
        |> Repo.all()

      reallocations =
        Enum.map(delayed_flights, fn flight ->
          case Enum.find(available_teams, &(&1.team_type in [:apoio_solo, :desembarque, :bagagem])) do
            nil ->
              Ops.create_alert(%{
                title: "Equipe insuficiente para remanejamento",
                description: "Não há equipe disponível para o voo #{flight.flight_number}",
                level: :critical,
                category: "team_shortage",
                metadata: %{flight_id: flight.id}
              })

              %{flight_id: flight.id, status: :sem_equipe}

            team ->
              Ops.create_assignment(%{
                flight_id: flight.id,
                team_id: team.id,
                assignment_type: to_string(team.team_type),
                status: :alocada
              })

              Ops.log_event!(%{
                event_type: "team_reallocation",
                message: "Equipe #{team.name} remanejada para voo #{flight.flight_number}",
                payload: %{team_id: team.id, flight_id: flight.id}
              })

              %{flight_id: flight.id, status: :realocado, team_id: team.id}
          end
        end)

      Ops.broadcast_event("reallocation_completed", %{reallocations: reallocations})
      reallocations
    end)
  end

  defp maybe_raise_team_capacity_alert(flight) do
    open_assignments =
      Assignment
      |> where([a], a.flight_id == ^flight.id and a.status in [:alocada, :em_execucao])
      |> Repo.aggregate(:count)

    if open_assignments < 2 do
      Ops.create_alert(%{
        title: "Equipe abaixo do mínimo operacional",
        description: "Voo #{flight.flight_number} está com equipe insuficiente para operação segura.",
        level: :warning,
        category: "team_conflict",
        metadata: %{flight_id: flight.id}
      })
    else
      {:ok, :no_alert}
    end
  end
end
