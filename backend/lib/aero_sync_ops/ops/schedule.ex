# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/ops/schedule.ex
# =============================================================
defmodule AeroSyncOps.Ops.Schedule do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: [:id, :employee_id, :sector, :start_time, :end_time, :inserted_at, :updated_at]}
  schema "schedules" do
    belongs_to :employee, AeroSyncOps.Ops.Employee
    field :sector, :string
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  def changeset(schedule, attrs) do
    schedule
    |> cast(attrs, [:employee_id, :sector, :start_time, :end_time])
    |> validate_required([:employee_id, :sector, :start_time, :end_time])
    |> validate_end_after_start()
  end

  defp validate_end_after_start(changeset) do
    start_time = get_field(changeset, :start_time)
    end_time = get_field(changeset, :end_time)

    if start_time && end_time && DateTime.compare(end_time, start_time) == :lt do
      add_error(changeset, :end_time, "deve ser posterior ao início")
    else
      changeset
    end
  end
end
