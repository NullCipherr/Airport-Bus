# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/priv/repo/migrations/20260327152000_create_core_tables.exs
# =============================================================
defmodule AeroSyncOps.Repo.Migrations.CreateCoreTables do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\"", "")

    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :email, :string, null: false
      add :role, :string, null: false
      add :password_hash, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])

    create table(:gates, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :code, :string, null: false
      add :terminal, :string, null: false
      add :state, :string, null: false
      add :current_flight_number, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:gates, [:code])

    create table(:belts, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :code, :string, null: false
      add :terminal, :string, null: false
      add :state, :string, null: false
      add :current_flight_number, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:belts, [:code])

    create table(:flights, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :flight_number, :string, null: false
      add :airline, :string, null: false
      add :origin, :string, null: false
      add :destination, :string, null: false
      add :scheduled_time, :utc_datetime, null: false
      add :actual_time, :utc_datetime
      add :status, :string, null: false
      add :airport_position, :string, null: false
      add :requires_baggage_unload, :boolean, null: false, default: false
      add :estimated_ground_time_minutes, :integer, null: false
      add :priority, :integer, null: false, default: 0
      add :gate_id, references(:gates, type: :uuid, on_delete: :nilify_all)
      add :belt_id, references(:belts, type: :uuid, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:flights, [:flight_number])
    create index(:flights, [:status])
    create index(:flights, [:scheduled_time])

    create table(:employees, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :role, :string, null: false
      add :sector, :string, null: false
      add :shift, :string, null: false
      add :availability, :string, null: false
      add :current_location, :string, null: false
      add :qualifications, {:array, :string}, null: false, default: []

      timestamps(type: :utc_datetime)
    end

    create table(:teams, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :team_type, :string, null: false
      add :is_available, :boolean, null: false, default: true

      timestamps(type: :utc_datetime)
    end

    create unique_index(:teams, [:name])

    create table(:team_members, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :team_id, references(:teams, type: :uuid, on_delete: :delete_all), null: false
      add :employee_id, references(:employees, type: :uuid, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:team_members, [:team_id, :employee_id])

    create table(:assignments, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :flight_id, references(:flights, type: :uuid, on_delete: :delete_all), null: false
      add :team_id, references(:teams, type: :uuid, on_delete: :nilify_all), null: false
      add :assignment_type, :string, null: false
      add :status, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:assignments, [:flight_id])
    create index(:assignments, [:team_id])

    create table(:schedules, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :employee_id, references(:employees, type: :uuid, on_delete: :delete_all), null: false
      add :sector, :string, null: false
      add :start_time, :utc_datetime, null: false
      add :end_time, :utc_datetime, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:schedules, [:employee_id])

    create table(:alerts, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :title, :string, null: false
      add :description, :text, null: false
      add :level, :string, null: false
      add :status, :string, null: false
      add :category, :string, null: false
      add :metadata, :map, null: false, default: %{}

      timestamps(type: :utc_datetime)
    end

    create index(:alerts, [:status])
    create index(:alerts, [:level])

    create table(:event_logs, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :event_type, :string, null: false
      add :message, :text, null: false
      add :payload, :map, null: false, default: %{}

      timestamps(type: :utc_datetime)
    end

    create index(:event_logs, [:event_type])
  end
end
