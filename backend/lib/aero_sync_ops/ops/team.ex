# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/ops/team.ex
# =============================================================
defmodule AeroSyncOps.Ops.Team do
  use Ecto.Schema
  import Ecto.Changeset

  @types ~w(embarque desembarque bagagem pista apoio_solo)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: [:id, :name, :team_type, :is_available, :inserted_at, :updated_at]}
  schema "teams" do
    field :name, :string
    field :team_type, Ecto.Enum, values: @types
    field :is_available, :boolean, default: true

    has_many :memberships, AeroSyncOps.Ops.TeamMember
    has_many :assignments, AeroSyncOps.Ops.Assignment

    timestamps(type: :utc_datetime)
  end

  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :team_type, :is_available])
    |> validate_required([:name, :team_type])
    |> unique_constraint(:name)
  end
end
