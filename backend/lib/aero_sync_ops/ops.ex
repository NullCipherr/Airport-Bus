# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/ops.ex
# =============================================================
defmodule AeroSyncOps.Ops do
  import Ecto.Query, warn: false

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

  alias AeroSyncOps.Ops.Orchestrator
  alias AeroSyncOps.Ops.EventDispatcher
  alias AeroSyncOps.Ops.MassiveSeed
  alias AeroSyncOps.Ops.RealtimeStorm
  alias AeroSyncOps.Ops.MassiveSeedRunner

  def list_flights(opts \\ []) do
    limit_size = Keyword.get(opts, :limit, 200)

    # Pré-carrega relacionamentos usados no dashboard para evitar N+1 queries.
    Flight
    |> preload([:gate, :belt, assignments: [:team]])
    |> order_by([f], asc: f.scheduled_time)
    |> limit(^limit_size)
    |> Repo.all()
  end

  def get_flight!(id), do: Flight |> preload([:gate, :belt, assignments: [:team]]) |> Repo.get!(id)

  def create_flight(attrs), do: %Flight{} |> Flight.changeset(attrs) |> Repo.insert()

  def update_flight(%Flight{} = flight, attrs) do
    result = flight |> Flight.changeset(attrs) |> Repo.update()

    with {:ok, updated} <- result do
      broadcast_event("flight_updated", serialize_flight(updated))
    end

    result
  end

  def delete_flight(%Flight{} = flight), do: Repo.delete(flight)

  def simulate_delay(flight_id, delay_minutes) do
    flight = get_flight!(flight_id)
    Orchestrator.handle_flight_delay(flight, delay_minutes)
  end

  def list_employees, do: Repo.all(Employee)
  def get_employee!(id), do: Repo.get!(Employee, id)
  def create_employee(attrs), do: %Employee{} |> Employee.changeset(attrs) |> Repo.insert()
  def update_employee(%Employee{} = employee, attrs), do: employee |> Employee.changeset(attrs) |> Repo.update()
  def delete_employee(%Employee{} = employee), do: Repo.delete(employee)

  def list_teams, do: Team |> preload(:memberships) |> Repo.all()
  def get_team!(id), do: Team |> preload(memberships: [:employee]) |> Repo.get!(id)
  def create_team(attrs), do: %Team{} |> Team.changeset(attrs) |> Repo.insert()
  def update_team(%Team{} = team, attrs), do: team |> Team.changeset(attrs) |> Repo.update()
  def delete_team(%Team{} = team), do: Repo.delete(team)

  def add_member_to_team(team_id, employee_id) do
    %TeamMember{}
    |> TeamMember.changeset(%{team_id: team_id, employee_id: employee_id})
    |> Repo.insert()
  end

  def list_gates, do: Repo.all(Gate)
  def get_gate!(id), do: Repo.get!(Gate, id)
  def create_gate(attrs), do: %Gate{} |> Gate.changeset(attrs) |> Repo.insert()
  def update_gate(%Gate{} = gate, attrs), do: gate |> Gate.changeset(attrs) |> Repo.update()
  def delete_gate(%Gate{} = gate), do: Repo.delete(gate)

  def list_belts, do: Repo.all(Belt)
  def get_belt!(id), do: Repo.get!(Belt, id)
  def create_belt(attrs), do: %Belt{} |> Belt.changeset(attrs) |> Repo.insert()
  def update_belt(%Belt{} = belt, attrs), do: belt |> Belt.changeset(attrs) |> Repo.update()
  def delete_belt(%Belt{} = belt), do: Repo.delete(belt)

  def list_schedules do
    Schedule
    |> preload(:employee)
    |> order_by([s], asc: s.start_time)
    |> Repo.all()
  end

  def get_schedule!(id), do: Schedule |> preload(:employee) |> Repo.get!(id)
  def create_schedule(attrs), do: %Schedule{} |> Schedule.changeset(attrs) |> Repo.insert()
  def update_schedule(%Schedule{} = schedule, attrs), do: schedule |> Schedule.changeset(attrs) |> Repo.update()
  def delete_schedule(%Schedule{} = schedule), do: Repo.delete(schedule)

  def list_alerts do
    Alert
    |> order_by([a], [desc: a.inserted_at])
    |> Repo.all()
  end

  def create_alert(attrs) do
    result = %Alert{} |> Alert.changeset(attrs) |> Repo.insert()

    with {:ok, alert} <- result do
      broadcast_event("alert_created", %{alert: alert})
    end

    result
  end

  def list_recent_events(limit \\ 20) do
    EventLog
    |> order_by([e], desc: e.inserted_at)
    |> limit(^limit)
    |> Repo.all()
  end

  def log_event!(attrs) do
    event =
      %EventLog{}
      |> EventLog.changeset(attrs)
      |> Repo.insert!()

    broadcast_event("event_logged", %{event: event})
    event
  end

  def create_assignment(attrs), do: %Assignment{} |> Assignment.changeset(attrs) |> Repo.insert()

  def simulate_reallocation, do: Orchestrator.simulate_reallocation()

  def generate_massive_dataset(opts \\ []), do: MassiveSeed.run(opts)
  def start_massive_seed_job(opts \\ []), do: MassiveSeedRunner.start_job(opts)
  def massive_seed_status, do: MassiveSeedRunner.status()

  def start_realtime_storm(opts \\ []), do: RealtimeStorm.start_storm(opts)
  def stop_realtime_storm, do: RealtimeStorm.stop_storm()
  def realtime_storm_status, do: RealtimeStorm.status()

  def dashboard_overview do
    # Snapshot agregado por COUNT no banco para manter desempenho com massa alta.
    %{
      total_flights: Repo.aggregate(Flight, :count),
      delayed_flights: Flight |> where([f], f.status == :atrasado) |> Repo.aggregate(:count),
      gates_occupied: Gate |> where([g], g.state == :ocupado) |> Repo.aggregate(:count),
      belts_in_use: Belt |> where([b], b.state == :ocupada) |> Repo.aggregate(:count),
      available_teams: Team |> where([t], t.is_available == true) |> Repo.aggregate(:count),
      open_alerts: Alert |> where([a], a.status == :open) |> Repo.aggregate(:count)
    }
  end

  def broadcast_event(event, payload), do: EventDispatcher.broadcast(event, payload)

  def serialize_flight(flight) do
    %{ 
      id: flight.id,
      flight_number: flight.flight_number,
      airline: flight.airline,
      origin: flight.origin,
      destination: flight.destination,
      scheduled_time: flight.scheduled_time,
      actual_time: flight.actual_time,
      status: flight.status,
      airport_position: flight.airport_position,
      requires_baggage_unload: flight.requires_baggage_unload,
      estimated_ground_time_minutes: flight.estimated_ground_time_minutes,
      priority: flight.priority,
      gate_id: flight.gate_id,
      belt_id: flight.belt_id
    }
  end
end
