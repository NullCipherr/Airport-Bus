# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/ops/team_member.ex
# =============================================================
defmodule AeroSyncOps.Ops.TeamMember do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: [:id, :team_id, :employee_id, :inserted_at, :updated_at]}
  schema "team_members" do
    belongs_to :team, AeroSyncOps.Ops.Team
    belongs_to :employee, AeroSyncOps.Ops.Employee

    timestamps(type: :utc_datetime)
  end

  def changeset(team_member, attrs) do
    team_member
    |> cast(attrs, [:team_id, :employee_id])
    |> validate_required([:team_id, :employee_id])
    |> unique_constraint([:team_id, :employee_id])
  end
end
