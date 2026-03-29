# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/ops/realtime_storm.ex
# =============================================================
defmodule AeroSyncOps.Ops.RealtimeStorm do
  @moduledoc """
  Gerador de eventos em tempo real para estresse do painel operacional.
  """

  use GenServer

  alias AeroSyncOps.Ops

  @default_interval_ms 250
  @default_batch_size 20

  def start_link(_opts), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def start_storm(opts \\ []), do: GenServer.call(__MODULE__, {:start_storm, opts})
  def stop_storm, do: GenServer.call(__MODULE__, :stop_storm)
  def status, do: GenServer.call(__MODULE__, :status)

  @impl true
  def init(_state) do
    {:ok,
     %{
       running: false,
       interval_ms: @default_interval_ms,
       batch_size: @default_batch_size,
       seq: 0,
       timer_ref: nil
     }}
  end

  @impl true
  def handle_call({:start_storm, opts}, _from, state) do
    interval_ms = Keyword.get(opts, :interval_ms, state.interval_ms)
    batch_size = Keyword.get(opts, :batch_size, state.batch_size)

    if state.running do
      {:reply, {:ok, %{running: true, interval_ms: state.interval_ms, batch_size: state.batch_size}}, state}
    else
      ref = Process.send_after(self(), :tick, 0)

      next_state = %{
        state
        | running: true,
          interval_ms: max(interval_ms, 30),
          batch_size: max(batch_size, 1),
          timer_ref: ref
      }

      {:reply, {:ok, %{running: true, interval_ms: next_state.interval_ms, batch_size: next_state.batch_size}}, next_state}
    end
  end

  @impl true
  def handle_call(:stop_storm, _from, state) do
    if state.timer_ref, do: Process.cancel_timer(state.timer_ref)
    {:reply, {:ok, %{running: false}}, %{state | running: false, timer_ref: nil}}
  end

  @impl true
  def handle_call(:status, _from, state) do
    {:reply, %{running: state.running, interval_ms: state.interval_ms, batch_size: state.batch_size, seq: state.seq}, state}
  end

  @impl true
  def handle_info(:tick, %{running: true} = state) do
    flights = Ops.list_flights()

    # Apenas broadcast de stress (sem escrita em banco) para focar throughput de realtime.
    Enum.each(1..state.batch_size, fn idx ->
      case Enum.at(flights, rem(state.seq + idx, max(length(flights), 1))) do
        nil ->
          :noop

        flight ->
          Ops.broadcast_event("flight_updated", %{
            id: flight.id,
            flight_number: flight.flight_number,
            status: Enum.at([:no_horario, :atrasado, :embarcando, :pousado], rem(state.seq + idx, 4)),
            priority: rem(state.seq + idx, 10),
            simulated: true,
            simulated_seq: state.seq + idx,
            simulated_at: DateTime.utc_now()
          })
      end
    end)

    Ops.broadcast_event("event_logged", %{
      event: %{
        id: "stress-#{state.seq}",
        event_type: "realtime_storm",
        message: "Pacote #{state.seq} enviado com #{state.batch_size} eventos de voo.",
        payload: %{batch_size: state.batch_size, interval_ms: state.interval_ms},
        inserted_at: DateTime.utc_now()
      }
    })

    ref = Process.send_after(self(), :tick, state.interval_ms)
    {:noreply, %{state | seq: state.seq + 1, timer_ref: ref}}
  end

  @impl true
  def handle_info(:tick, state), do: {:noreply, state}
end
