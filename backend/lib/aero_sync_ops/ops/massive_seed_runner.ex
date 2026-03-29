# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/ops/massive_seed_runner.ex
# =============================================================
defmodule AeroSyncOps.Ops.MassiveSeedRunner do
  @moduledoc """
  Executor assíncrono para geração de massa de dados.
  Evita travar request HTTP e permite polling de status.
  """

  use GenServer

  alias AeroSyncOps.Ops

  def start_link(_opts), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def start_job(opts), do: GenServer.call(__MODULE__, {:start_job, opts})
  def status, do: GenServer.call(__MODULE__, :status)

  @impl true
  def init(_state) do
    {:ok, %{status: :idle, started_at: nil, finished_at: nil, last_result: nil, last_error: nil, task_ref: nil}}
  end

  @impl true
  def handle_call(:status, _from, state), do: {:reply, present(state), state}

  @impl true
  def handle_call({:start_job, _opts}, _from, %{status: :running} = state) do
    {:reply, {:error, :already_running}, state}
  end

  @impl true
  def handle_call({:start_job, opts}, _from, state) do
    parent = self()

    task =
      Task.async(fn ->
        try do
          result = Ops.generate_massive_dataset(opts)
          send(parent, {:job_finished, {:ok, result}})
        rescue
          error ->
            send(parent, {:job_finished, {:error, Exception.message(error)}})
        end
      end)

    next_state = %{
      state
      | status: :running,
        started_at: DateTime.utc_now(),
        finished_at: nil,
        last_error: nil,
        task_ref: task.ref
    }

    {:reply, {:ok, present(next_state)}, next_state}
  end

  @impl true
  def handle_info({:job_finished, {:ok, result}}, state) do
    next_state = %{
      state
      | status: :completed,
        finished_at: DateTime.utc_now(),
        last_result: result,
        task_ref: nil
    }

    {:noreply, next_state}
  end

  @impl true
  def handle_info({:job_finished, {:error, message}}, state) do
    next_state = %{
      state
      | status: :failed,
        finished_at: DateTime.utc_now(),
        last_error: message,
        task_ref: nil
    }

    {:noreply, next_state}
  end

  @impl true
  def handle_info({ref, _result}, %{task_ref: ref} = state) do
    Process.demonitor(ref, [:flush])
    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, reason}, %{task_ref: ref} = state) do
    next_state = %{
      state
      | status: :failed,
        finished_at: DateTime.utc_now(),
        last_error: inspect(reason),
        task_ref: nil
    }

    {:noreply, next_state}
  end

  @impl true
  def handle_info(_msg, state), do: {:noreply, state}

  defp present(state) do
    %{
      status: state.status,
      started_at: state.started_at,
      finished_at: state.finished_at,
      last_result: state.last_result,
      last_error: state.last_error
    }
  end
end
