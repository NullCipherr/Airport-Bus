# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/ops/event_log.ex
# =============================================================
defmodule AeroSyncOps.Ops.EventLog do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: [:id, :event_type, :message, :payload, :inserted_at, :updated_at]}
  schema "event_logs" do
    field :event_type, :string
    field :message, :string
    field :payload, :map, default: %{}

    timestamps(type: :utc_datetime)
  end

  def changeset(event_log, attrs) do
    event_log
    |> cast(attrs, [:event_type, :message, :payload])
    |> validate_required([:event_type, :message])
  end
end
