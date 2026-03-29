# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/ops/belt.ex
# =============================================================
defmodule AeroSyncOps.Ops.Belt do
  use Ecto.Schema
  import Ecto.Changeset

  @states ~w(disponivel ocupada indisponivel manutencao)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: [:id, :code, :terminal, :state, :current_flight_number, :inserted_at, :updated_at]}
  schema "belts" do
    field :code, :string
    field :terminal, :string
    field :state, Ecto.Enum, values: @states, default: :disponivel
    field :current_flight_number, :string

    has_many :flights, AeroSyncOps.Ops.Flight

    timestamps(type: :utc_datetime)
  end

  def changeset(belt, attrs) do
    belt
    |> cast(attrs, [:code, :terminal, :state, :current_flight_number])
    |> validate_required([:code, :terminal, :state])
    |> unique_constraint(:code)
  end
end
