# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/ops/flight.ex
# =============================================================
defmodule AeroSyncOps.Ops.Flight do
  use Ecto.Schema
  import Ecto.Changeset

  @statuses ~w(no_horario atrasado embarcando pousado cancelado finalizado)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder,
           only: [
             :id,
             :flight_number,
             :airline,
             :origin,
             :destination,
             :scheduled_time,
             :actual_time,
             :status,
             :airport_position,
             :requires_baggage_unload,
             :estimated_ground_time_minutes,
             :priority,
             :gate_id,
             :belt_id,
             :inserted_at,
             :updated_at
           ]}
  schema "flights" do
    field :flight_number, :string
    field :airline, :string
    field :origin, :string
    field :destination, :string
    field :scheduled_time, :utc_datetime
    field :actual_time, :utc_datetime
    field :status, Ecto.Enum, values: @statuses, default: :no_horario
    field :airport_position, :string
    field :requires_baggage_unload, :boolean, default: false
    field :estimated_ground_time_minutes, :integer
    field :priority, :integer, default: 0

    belongs_to :gate, AeroSyncOps.Ops.Gate
    belongs_to :belt, AeroSyncOps.Ops.Belt
    has_many :assignments, AeroSyncOps.Ops.Assignment

    timestamps(type: :utc_datetime)
  end

  def changeset(flight, attrs) do
    flight
    |> cast(attrs, [
      :flight_number,
      :airline,
      :origin,
      :destination,
      :scheduled_time,
      :actual_time,
      :status,
      :airport_position,
      :requires_baggage_unload,
      :estimated_ground_time_minutes,
      :priority,
      :gate_id,
      :belt_id
    ])
    |> validate_required([
      :flight_number,
      :airline,
      :origin,
      :destination,
      :scheduled_time,
      :status,
      :airport_position,
      :estimated_ground_time_minutes
    ])
    |> validate_number(:estimated_ground_time_minutes, greater_than_or_equal_to: 5)
    |> unique_constraint(:flight_number)
    |> foreign_key_constraint(:gate_id)
    |> foreign_key_constraint(:belt_id)
  end
end
