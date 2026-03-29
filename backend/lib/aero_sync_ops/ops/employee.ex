# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/ops/employee.ex
# =============================================================
defmodule AeroSyncOps.Ops.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  @availability ~w(disponivel indisponivel em_operacao folga)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder,
           only: [
             :id,
             :name,
             :role,
             :sector,
             :shift,
             :availability,
             :current_location,
             :qualifications,
             :inserted_at,
             :updated_at
           ]}
  schema "employees" do
    field :name, :string
    field :role, :string
    field :sector, :string
    field :shift, :string
    field :availability, Ecto.Enum, values: @availability, default: :disponivel
    field :current_location, :string
    field :qualifications, {:array, :string}, default: []

    has_many :team_memberships, AeroSyncOps.Ops.TeamMember
    timestamps(type: :utc_datetime)
  end

  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:name, :role, :sector, :shift, :availability, :current_location, :qualifications])
    |> validate_required([:name, :role, :sector, :shift, :availability, :current_location])
  end
end
