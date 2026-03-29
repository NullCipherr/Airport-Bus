# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/priv/repo/seeds_massive.exs
# =============================================================
alias AeroSyncOps.Ops

opts = [
  gates: String.to_integer(System.get_env("SEED_GATES") || "60"),
  belts: String.to_integer(System.get_env("SEED_BELTS") || "28"),
  employees: String.to_integer(System.get_env("SEED_EMPLOYEES") || "1800"),
  teams: String.to_integer(System.get_env("SEED_TEAMS") || "420"),
  flights: String.to_integer(System.get_env("SEED_FLIGHTS") || "3200"),
  alerts: String.to_integer(System.get_env("SEED_ALERTS") || "900"),
  logs: String.to_integer(System.get_env("SEED_LOGS") || "12000")
]

result = Ops.generate_massive_dataset(opts)

IO.puts("Massa operacional criada com sucesso:")
IO.inspect(result, pretty: true, limit: :infinity)
