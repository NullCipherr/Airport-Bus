# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/ops/alert.ex
# =============================================================
defmodule AeroSyncOps.Ops.Alert do
  use Ecto.Schema
  import Ecto.Changeset

  @levels ~w(info warning critical)a
  @statuses ~w(open acknowledged resolved)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder,
           only: [
             :id,
             :title,
             :description,
             :level,
             :status,
             :category,
             :metadata,
             :inserted_at,
             :updated_at
           ]}
  schema "alerts" do
    field :title, :string
    field :description, :string
    field :level, Ecto.Enum, values: @levels
    field :status, Ecto.Enum, values: @statuses, default: :open
    field :category, :string
    field :metadata, :map, default: %{}

    timestamps(type: :utc_datetime)
  end

  def changeset(alert, attrs) do
    alert
    |> cast(attrs, [:title, :description, :level, :status, :category, :metadata])
    |> validate_required([:title, :description, :level, :status, :category])
  end
end
