# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/priv/repo/seeds.exs
# =============================================================
alias AeroSyncOps.{Accounts, Ops, Repo}
alias AeroSyncOps.Ops.{Team, TeamMember}

Repo.delete_all(AeroSyncOps.Ops.Assignment)
Repo.delete_all(AeroSyncOps.Ops.Schedule)
Repo.delete_all(TeamMember)
Repo.delete_all(Team)
Repo.delete_all(AeroSyncOps.Ops.Flight)
Repo.delete_all(AeroSyncOps.Ops.Gate)
Repo.delete_all(AeroSyncOps.Ops.Belt)
Repo.delete_all(AeroSyncOps.Ops.Employee)
Repo.delete_all(AeroSyncOps.Ops.Alert)
Repo.delete_all(AeroSyncOps.Ops.EventLog)
Repo.delete_all(AeroSyncOps.Accounts.User)

{:ok, supervisor, _token} =
  case Accounts.create_user(%{
         name: "Mariana Souza",
         email: "supervisor@aerosync.local",
         role: :supervisor,
         password: "AeroSync123!"
       }) do
    {:ok, user} -> {:ok, user, nil}
    {:error, _} ->
      user = Accounts.get_by_email("supervisor@aerosync.local")
      {:ok, user, nil}
  end

{:ok, _operador, _} =
  case Accounts.create_user(%{
         name: "Lucas Prado",
         email: "operador@aerosync.local",
         role: :operador,
         password: "AeroSync123!"
       }) do
    {:ok, user} -> {:ok, user, nil}
    {:error, _} ->
      user = Accounts.get_by_email("operador@aerosync.local")
      {:ok, user, nil}
  end

{:ok, gate_a1} = Ops.create_gate(%{code: "A1", terminal: "T1", state: :ocupado, current_flight_number: "AZU4512"})
{:ok, gate_a2} = Ops.create_gate(%{code: "A2", terminal: "T1", state: :disponivel})
{:ok, gate_b4} = Ops.create_gate(%{code: "B4", terminal: "T2", state: :ocupado, current_flight_number: "LAT3309"})
{:ok, gate_c7} = Ops.create_gate(%{code: "C7", terminal: "T3", state: :indisponivel})

{:ok, belt_1} = Ops.create_belt(%{code: "EST-01", terminal: "T1", state: :ocupada, current_flight_number: "AZU4512"})
{:ok, belt_2} = Ops.create_belt(%{code: "EST-02", terminal: "T2", state: :disponivel})
{:ok, belt_3} = Ops.create_belt(%{code: "EST-03", terminal: "T3", state: :manutencao})

employees =
  [
    %{name: "Amanda Costa", role: "Líder de embarque", sector: "embarque", shift: "06:00-14:00", availability: :disponivel, current_location: "Gate A1", qualifications: ["boarding", "safety"]},
    %{name: "Rafael Lima", role: "Despachante", sector: "pista", shift: "06:00-14:00", availability: :em_operacao, current_location: "Pátio Norte", qualifications: ["pushback", "ramp"]},
    %{name: "Bruna Nogueira", role: "Bagagem", sector: "bagagem", shift: "14:00-22:00", availability: :disponivel, current_location: "Esteira EST-01", qualifications: ["baggage_sort", "xray"]},
    %{name: "Thiago Martins", role: "Apoio solo", sector: "apoio", shift: "14:00-22:00", availability: :disponivel, current_location: "Área de apoio T2", qualifications: ["ground_support", "fuel_coordination"]},
    %{name: "Carla Menezes", role: "Supervisora de pista", sector: "pista", shift: "22:00-06:00", availability: :folga, current_location: "Base operacional", qualifications: ["incident_response", "coordination"]}
  ]
  |> Enum.map(fn attrs ->
    {:ok, employee} = Ops.create_employee(attrs)
    employee
  end)

{:ok, team_boarding} = Ops.create_team(%{name: "Equipe Embarque Alfa", team_type: :embarque, is_available: true})
{:ok, team_baggage} = Ops.create_team(%{name: "Equipe Bagagem Delta", team_type: :bagagem, is_available: true})
{:ok, team_ground} = Ops.create_team(%{name: "Equipe Solo Ômega", team_type: :apoio_solo, is_available: true})
{:ok, team_runway} = Ops.create_team(%{name: "Equipe Pista Bravo", team_type: :pista, is_available: false})

Ops.add_member_to_team(team_boarding.id, Enum.at(employees, 0).id)
Ops.add_member_to_team(team_runway.id, Enum.at(employees, 1).id)
Ops.add_member_to_team(team_baggage.id, Enum.at(employees, 2).id)
Ops.add_member_to_team(team_ground.id, Enum.at(employees, 3).id)
Ops.add_member_to_team(team_ground.id, Enum.at(employees, 4).id)

now = DateTime.utc_now() |> DateTime.truncate(:second)

{:ok, flight_1} =
  Ops.create_flight(%{
    flight_number: "AZU4512",
    airline: "Azul",
    origin: "GRU",
    destination: "SSA",
    scheduled_time: DateTime.add(now, 35 * 60, :second),
    actual_time: DateTime.add(now, 55 * 60, :second),
    status: :atrasado,
    gate_id: gate_a1.id,
    airport_position: "Posição P12",
    requires_baggage_unload: true,
    belt_id: belt_1.id,
    estimated_ground_time_minutes: 50,
    priority: 3
  })

{:ok, flight_2} =
  Ops.create_flight(%{
    flight_number: "LAT3309",
    airline: "LATAM",
    origin: "MIA",
    destination: "GRU",
    scheduled_time: DateTime.add(now, 20 * 60, :second),
    status: :embarcando,
    gate_id: gate_b4.id,
    airport_position: "Posição C8",
    requires_baggage_unload: true,
    belt_id: belt_2.id,
    estimated_ground_time_minutes: 70,
    priority: 5
  })

{:ok, flight_3} =
  Ops.create_flight(%{
    flight_number: "GLO1987",
    airline: "GOL",
    origin: "POA",
    destination: "GRU",
    scheduled_time: DateTime.add(now, 90 * 60, :second),
    status: :no_horario,
    gate_id: gate_a2.id,
    airport_position: "Posição B3",
    requires_baggage_unload: false,
    estimated_ground_time_minutes: 40,
    priority: 2
  })

{:ok, flight_4} =
  Ops.create_flight(%{
    flight_number: "TAP0092",
    airline: "TAP",
    origin: "LIS",
    destination: "GRU",
    scheduled_time: DateTime.add(now, -25 * 60, :second),
    actual_time: DateTime.add(now, -5 * 60, :second),
    status: :pousado,
    gate_id: gate_a2.id,
    airport_position: "Posição Internacional I5",
    requires_baggage_unload: true,
    belt_id: belt_2.id,
    estimated_ground_time_minutes: 85,
    priority: 4
  })

{:ok, _a1} = Ops.create_assignment(%{flight_id: flight_1.id, team_id: team_baggage.id, assignment_type: "bagagem", status: :em_execucao})
{:ok, _a2} = Ops.create_assignment(%{flight_id: flight_1.id, team_id: team_ground.id, assignment_type: "apoio_solo", status: :alocada})
{:ok, _a3} = Ops.create_assignment(%{flight_id: flight_2.id, team_id: team_boarding.id, assignment_type: "embarque", status: :em_execucao})
{:ok, _a4} = Ops.create_assignment(%{flight_id: flight_2.id, team_id: team_runway.id, assignment_type: "pista", status: :alocada})

Enum.each(employees, fn employee ->
  Ops.create_schedule(%{
    employee_id: employee.id,
    sector: employee.sector,
    start_time: DateTime.add(now, -4 * 3600, :second),
    end_time: DateTime.add(now, 4 * 3600, :second)
  })
end)

Ops.create_alert(%{
  title: "Conflito de portão detectado",
  description: "Gate C7 indisponível, voos previstos precisam de remanejamento.",
  level: :critical,
  status: :open,
  category: "gate_conflict",
  metadata: %{gate_code: "C7", affected_flights: ["GLO1987"]}
})

Ops.create_alert(%{
  title: "Troca de esteira realizada",
  description: "Voo LAT3309 movido da EST-01 para EST-02.",
  level: :warning,
  status: :acknowledged,
  category: "belt_change",
  metadata: %{flight_number: "LAT3309", from: "EST-01", to: "EST-02"}
})

Ops.log_event!(%{event_type: "seed_bootstrap", message: "Base inicial populada para demonstração operacional", payload: %{by: supervisor.email}})
Ops.log_event!(%{event_type: "incident", message: "Atraso por meteorologia no corredor sul", payload: %{severity: "high"}})
Ops.log_event!(%{event_type: "reallocation", message: "Equipe Solo Ômega pré-selecionada para voo prioritário LAT3309", payload: %{team: "Equipe Solo Ômega"}})

IO.puts("Seeds executadas com sucesso para AeroSync Ops")
