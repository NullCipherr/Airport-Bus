# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops_web/router.ex
# =============================================================
defmodule AeroSyncOpsWeb.Router do
  use AeroSyncOpsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug AeroSyncOpsWeb.Plugs.RequireAuth
  end

  scope "/api", AeroSyncOpsWeb do
    pipe_through :api

    post "/auth/login", AuthController, :login
  end

  scope "/api", AeroSyncOpsWeb do
    pipe_through [:api, :authenticated]

    get "/health", HealthController, :index
    get "/dashboard/overview", DashboardController, :overview
    get "/dashboard/events", DashboardController, :events

    resources "/flights", FlightController, except: [:new, :edit]
    post "/flights/:id/simulate-delay", FlightController, :simulate_delay

    resources "/employees", EmployeeController, except: [:new, :edit]
    resources "/teams", TeamController, except: [:new, :edit]
    resources "/gates", GateController, except: [:new, :edit]
    resources "/belts", BeltController, except: [:new, :edit]
    resources "/schedules", ScheduleController, except: [:new, :edit]
    resources "/alerts", AlertController, only: [:index]

    post "/operations/simulate-reallocation", OperationsController, :simulate_reallocation
    post "/operations/massive-seed", OperationsController, :massive_seed
    get "/operations/massive-seed/status", OperationsController, :massive_seed_status
    post "/operations/realtime-storm/start", OperationsController, :start_realtime_storm
    post "/operations/realtime-storm/stop", OperationsController, :stop_realtime_storm
    get "/operations/realtime-storm/status", OperationsController, :realtime_storm_status
  end
end
