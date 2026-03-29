# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/repo.ex
# =============================================================
defmodule AeroSyncOps.Repo do
  use Ecto.Repo,
    otp_app: :aero_sync_ops,
    adapter: Ecto.Adapters.Postgres
end
