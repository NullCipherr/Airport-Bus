# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/ops/massive_seed.ex
# =============================================================
defmodule AeroSyncOps.Ops.MassiveSeed do
  @moduledoc """
  Gerador de massa sintética para testes de carga, inspirado no perfil
  operacional de um grande hub aeroportuário (ex.: GRU).
  """

  alias AeroSyncOps.Repo
  alias AeroSyncOps.Ops.{
    Alert,
    Assignment,
    Belt,
    Employee,
    EventLog,
    Flight,
    Gate,
    Schedule,
    Team,
    TeamMember
  }

  @airlines [
    "LATAM",
    "GOL",
    "Azul",
    "TAP",
    "American Airlines",
    "Air France",
    "Lufthansa",
    "Qatar Airways",
    "Emirates",
    "KLM",
    "Iberia",
    "United"
  ]

  @origins [
    "GRU",
    "CGH",
    "VCP",
    "SDU",
    "GIG",
    "SSA",
    "BSB",
    "POA",
    "REC",
    "MIA",
    "JFK",
    "MAD",
    "LIS",
    "CDG",
    "FRA",
    "DXB"
  ]

  @roles [
    "Agente de Embarque",
    "Despachante",
    "Bagagem",
    "Pátio",
    "Apoio Solo",
    "Supervisor de Operações"
  ]

  @sectors ["embarque", "desembarque", "bagagem", "pista", "apoio"]
  @shifts ["00:00-08:00", "08:00-16:00", "16:00-00:00"]

  @doc """
  Executa carga massiva de dados.

  Opções:
  - `:gates` (default: 60)
  - `:belts` (default: 28)
  - `:employees` (default: 1800)
  - `:teams` (default: 420)
  - `:flights` (default: 3200)
  - `:alerts` (default: 900)
  - `:logs` (default: 12000)
  """
  def run(opts \\ []) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    counts = %{
      gates: Keyword.get(opts, :gates, 60),
      belts: Keyword.get(opts, :belts, 28),
      employees: Keyword.get(opts, :employees, 1800),
      teams: Keyword.get(opts, :teams, 420),
      flights: Keyword.get(opts, :flights, 3200),
      alerts: Keyword.get(opts, :alerts, 900),
      logs: Keyword.get(opts, :logs, 12_000)
    }

    truncate_everything()

    gate_ids = insert_gates(counts.gates, now)
    belt_ids = insert_belts(counts.belts, now)
    employee_ids = insert_employees(counts.employees, now)
    team_ids = insert_teams(counts.teams, now)

    insert_team_members(team_ids, employee_ids, now)
    flight_ids = insert_flights(counts.flights, gate_ids, belt_ids, now)
    insert_assignments(flight_ids, team_ids, now)
    insert_schedules(employee_ids, now)
    insert_alerts(counts.alerts, now)
    insert_logs(counts.logs, now)

    %{
      mode: :massive,
      counts: counts,
      created_at: now
    }
  end

  defp truncate_everything do
    Repo.delete_all(Assignment)
    Repo.delete_all(Schedule)
    Repo.delete_all(TeamMember)
    Repo.delete_all(Team)
    Repo.delete_all(Flight)
    Repo.delete_all(Gate)
    Repo.delete_all(Belt)
    Repo.delete_all(Employee)
    Repo.delete_all(Alert)
    Repo.delete_all(EventLog)
  end

  defp insert_gates(total, now) do
    rows =
      for i <- 1..total do
        id = Ecto.UUID.generate()

        %{
          id: id,
          code: "G#{i}",
          terminal: "T#{rem(i, 3) + 1}",
          state: Enum.at([:disponivel, :ocupado, :manutencao], rem(i, 3)),
          current_flight_number: if(rem(i, 4) == 0, do: nil, else: "OPS#{10_000 + i}"),
          inserted_at: now,
          updated_at: now
        }
      end

    Repo.insert_all(Gate, rows)
    Enum.map(rows, & &1.id)
  end

  defp insert_belts(total, now) do
    rows =
      for i <- 1..total do
        id = Ecto.UUID.generate()

        %{
          id: id,
          code: "EST-#{String.pad_leading(Integer.to_string(i), 3, "0")}",
          terminal: "T#{rem(i, 3) + 1}",
          state: Enum.at([:disponivel, :ocupada, :manutencao], rem(i, 3)),
          current_flight_number: if(rem(i, 5) == 0, do: nil, else: "OPS#{20_000 + i}"),
          inserted_at: now,
          updated_at: now
        }
      end

    Repo.insert_all(Belt, rows)
    Enum.map(rows, & &1.id)
  end

  defp insert_employees(total, now) do
    rows =
      for i <- 1..total do
        id = Ecto.UUID.generate()
        sector = Enum.at(@sectors, rem(i, length(@sectors)))

        %{
          id: id,
          name: "Colaborador #{i}",
          role: Enum.at(@roles, rem(i, length(@roles))),
          sector: sector,
          shift: Enum.at(@shifts, rem(i, length(@shifts))),
          availability: Enum.at([:disponivel, :em_operacao, :indisponivel, :folga], rem(i, 4)),
          current_location: "Setor #{String.upcase(String.slice(sector, 0, 3))}-#{rem(i, 80) + 1}",
          qualifications: ["safety", "ops_#{sector}", "coord_#{rem(i, 7) + 1}"],
          inserted_at: now,
          updated_at: now
        }
      end

    Repo.insert_all(Employee, rows)
    Enum.map(rows, & &1.id)
  end

  defp insert_teams(total, now) do
    types = [:embarque, :desembarque, :bagagem, :pista, :apoio_solo]

    rows =
      for i <- 1..total do
        id = Ecto.UUID.generate()

        %{
          id: id,
          name: "Equipe #{Enum.at(types, rem(i, length(types)))} #{i}",
          team_type: Enum.at(types, rem(i, length(types))),
          is_available: rem(i, 5) != 0,
          inserted_at: now,
          updated_at: now
        }
      end

    Repo.insert_all(Team, rows)
    Enum.map(rows, & &1.id)
  end

  defp insert_team_members(team_ids, employee_ids, now) do
    # Define 5 membros por equipe para simular squads operacionais robustos.
    rows =
      team_ids
      |> Enum.with_index()
      |> Enum.flat_map(fn {team_id, idx} ->
        base = rem(idx * 5, length(employee_ids))

        for offset <- 0..4 do
          employee_id = Enum.at(employee_ids, rem(base + offset, length(employee_ids)))

          %{
            id: Ecto.UUID.generate(),
            team_id: team_id,
            employee_id: employee_id,
            inserted_at: now,
            updated_at: now
          }
        end
      end)

    Repo.insert_all(TeamMember, rows)
  end

  defp insert_flights(total, gate_ids, belt_ids, now) do
    statuses = [:no_horario, :atrasado, :embarcando, :pousado, :cancelado, :finalizado]

    rows =
      for i <- 1..total do
        id = Ecto.UUID.generate()
        origin = Enum.at(@origins, rem(i, length(@origins)))
        destination = Enum.at(@origins, rem(i + 5, length(@origins)))
        sched = DateTime.add(now, (i - div(total, 2)) * 180, :second)
        delayed? = rem(i, 7) == 0

        %{
          id: id,
          flight_number: "OPS#{50_000 + i}",
          airline: Enum.at(@airlines, rem(i, length(@airlines))),
          origin: origin,
          destination: destination,
          scheduled_time: sched,
          actual_time: if(delayed?, do: DateTime.add(sched, 20 * 60, :second), else: nil),
          status: Enum.at(statuses, rem(i, length(statuses))),
          airport_position: "P#{rem(i, 200) + 1}",
          requires_baggage_unload: rem(i, 2) == 0,
          estimated_ground_time_minutes: rem(i, 95) + 25,
          priority: rem(i, 10),
          gate_id: Enum.at(gate_ids, rem(i, length(gate_ids))),
          belt_id: if(rem(i, 3) == 0, do: nil, else: Enum.at(belt_ids, rem(i, length(belt_ids)))),
          inserted_at: now,
          updated_at: now
        }
      end

    Repo.insert_all(Flight, rows)
    Enum.map(rows, & &1.id)
  end

  defp insert_assignments(flight_ids, team_ids, now) do
    rows =
      flight_ids
      |> Enum.with_index()
      |> Enum.flat_map(fn {flight_id, idx} ->
        for offset <- 0..2 do
          team_id = Enum.at(team_ids, rem(idx * 3 + offset, length(team_ids)))

          %{
            id: Ecto.UUID.generate(),
            flight_id: flight_id,
            team_id: team_id,
            assignment_type: Enum.at(["embarque", "bagagem", "apoio_solo"], offset),
            status: Enum.at([:alocada, :em_execucao, :remanejada], rem(idx + offset, 3)),
            inserted_at: now,
            updated_at: now
          }
        end
      end)

    Repo.insert_all(Assignment, rows)
  end

  defp insert_schedules(employee_ids, now) do
    rows =
      employee_ids
      |> Enum.with_index()
      |> Enum.map(fn {employee_id, idx} ->
        start_time = DateTime.add(now, -rem(idx, 6) * 3600, :second)
        end_time = DateTime.add(start_time, 8 * 3600, :second)

        %{
          id: Ecto.UUID.generate(),
          employee_id: employee_id,
          sector: Enum.at(@sectors, rem(idx, length(@sectors))),
          start_time: start_time,
          end_time: end_time,
          inserted_at: now,
          updated_at: now
        }
      end)

    Repo.insert_all(Schedule, rows)
  end

  defp insert_alerts(total, now) do
    rows =
      for i <- 1..total do
        %{
          id: Ecto.UUID.generate(),
          title: "Alerta Operacional ##{i}",
          description: "Evento operacional em cadeia #{i} no terminal T#{rem(i, 3) + 1}.",
          level: Enum.at([:info, :warning, :critical], rem(i, 3)),
          status: Enum.at([:open, :acknowledged, :resolved], rem(i, 3)),
          category: Enum.at(["delay", "gate_conflict", "belt_change", "team_shortage"], rem(i, 4)),
          metadata: %{incident_ref: "INC-#{100_000 + i}", terminal: "T#{rem(i, 3) + 1}"},
          inserted_at: now,
          updated_at: now
        }
      end

    Repo.insert_all(Alert, rows)
  end

  defp insert_logs(total, now) do
    rows =
      for i <- 1..total do
        %{
          id: Ecto.UUID.generate(),
          event_type: Enum.at(["flight_update", "allocation", "incident", "alert"], rem(i, 4)),
          message: "Registro massivo #{i}: atualização operacional contínua.",
          payload: %{seq: i, source: "massive_seed", zone: "Z#{rem(i, 9) + 1}"},
          inserted_at: DateTime.add(now, -i, :second),
          updated_at: DateTime.add(now, -i, :second)
        }
      end

    Repo.insert_all(EventLog, rows)
  end
end
