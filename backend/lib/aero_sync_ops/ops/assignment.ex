# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/ops/assignment.ex
# =============================================================
defmodule AeroSyncOps.Ops.Assignment do
  use Ecto.Schema
  import Ecto.Changeset

  @statuses ~w(alocada em_execucao finalizada remanejada cancelada)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: [:id, :flight_id, :team_id, :assignment_type, :status, :inserted_at, :updated_at]}
  schema "assignments" do
    belongs_to :flight, AeroSyncOps.Ops.Flight
    belongs_to :team, AeroSyncOps.Ops.Team
    field :assignment_type, :string
    field :status, Ecto.Enum, values: @statuses, default: :alocada

    timestamps(type: :utc_datetime)
  end

  def changeset(assignment, attrs) do
    assignment
    |> cast(attrs, [:flight_id, :team_id, :assignment_type, :status])
    |> validate_required([:flight_id, :team_id, :assignment_type, :status])
  end
end
