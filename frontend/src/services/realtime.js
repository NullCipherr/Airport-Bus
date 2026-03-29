/* =============================================================
 * AeroSync Ops
 * Autor: Andrei Roberto da Costa
 * Data: 2026-03-27
 * Hora: 15:37:28 -03
 * Arquivo: frontend/src/services/realtime.js
 * ============================================================= */
import { Socket } from 'phoenix'
import { useOpsStore } from '../stores/ops'

let socket
let channel

export function connectRealtime() {
  const opsStore = useOpsStore()

  // Reaproveita conexão ativa para evitar múltiplos listeners duplicados.
  if (channel) {
    return channel
  }

  socket = new Socket(import.meta.env.VITE_WS_URL || 'ws://localhost:4000/socket', {
    params: {}
  })

  socket.connect()
  channel = socket.channel('ops:lobby', {})

  // Cada evento do backend atualiza a store local imediatamente.
  channel.on('flight_updated', (payload) => {
    opsStore.upsertFlight(payload)
  })

  channel.on('alert_created', ({ alert }) => {
    opsStore.prependAlert(alert)
  })

  channel.on('event_logged', ({ event }) => {
    opsStore.prependEvent(event)
  })

  channel.on('reallocation_completed', ({ reallocations }) => {
    opsStore.setLastReallocation(reallocations)
  })

  channel.join()

  return channel
}

export function disconnectRealtime() {
  if (channel) {
    channel.leave()
    channel = null
  }

  if (socket) {
    socket.disconnect()
    socket = null
  }
}
