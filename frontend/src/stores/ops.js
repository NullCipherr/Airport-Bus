/* =============================================================
 * AeroSync Ops
 * Autor: Andrei Roberto da Costa
 * Data: 2026-03-27
 * Hora: 15:37:28 -03
 * Arquivo: frontend/src/stores/ops.js
 * ============================================================= */
import { defineStore } from 'pinia'
import api from '../services/api'

export const useOpsStore = defineStore('ops', {
  state: () => ({
    overview: null,
    flights: [],
    employees: [],
    teams: [],
    gates: [],
    belts: [],
    schedules: [],
    alerts: [],
    events: [],
    lastReallocation: [],
    loading: false
  }),
  getters: {
    delayedFlights: (state) => state.flights.filter((f) => f.status === 'atrasado'),
    activeAlerts: (state) => state.alerts.filter((a) => a.status === 'open')
  },
  actions: {
    async loadDashboard() {
      this.loading = true

      try {
        // Endpoint agregador reduz round-trips para montar a visão operacional inicial.
        const { data } = await api.get('/dashboard/overview?flights_limit=120&alerts_limit=20&events_limit=50')
        this.overview = data.overview
        this.flights = data.flights
        this.alerts = data.alerts
        this.events = data.recent_events
      } finally {
        this.loading = false
      }
    },
    async loadFlights() {
      const { data } = await api.get('/flights?limit=500')
      this.flights = data.data
    },
    async loadEmployees() {
      const { data } = await api.get('/employees')
      this.employees = data.data
    },
    async loadTeams() {
      const { data } = await api.get('/teams')
      this.teams = data.data
    },
    async loadGates() {
      const { data } = await api.get('/gates')
      this.gates = data.data
    },
    async loadBelts() {
      const { data } = await api.get('/belts')
      this.belts = data.data
    },
    async loadSchedules() {
      const { data } = await api.get('/schedules')
      this.schedules = data.data
    },
    async loadAlerts() {
      const { data } = await api.get('/alerts')
      this.alerts = data.data
    },
    async loadEvents() {
      const { data } = await api.get('/dashboard/events')
      this.events = data.events
    },
    async simulateDelay(flightId, delayMinutes = 20) {
      await api.post(`/flights/${flightId}/simulate-delay`, { delay_minutes: delayMinutes })
      await this.loadDashboard()
    },
    async simulateReallocation() {
      const { data } = await api.post('/operations/simulate-reallocation')
      this.lastReallocation = data.data
      await this.loadDashboard()
    },
    async generateMassiveDataset(payload = {}) {
      // A geração de massa pode levar mais tempo que as chamadas operacionais padrão.
      const { data } = await api.post('/operations/massive-seed', payload, { timeout: 30000 })
      return data
    },
    async getMassiveSeedStatus() {
      const { data } = await api.get('/operations/massive-seed/status')
      return data
    },
    async startRealtimeStorm(payload = {}) {
      const { data } = await api.post('/operations/realtime-storm/start', payload)
      return data
    },
    async stopRealtimeStorm() {
      const { data } = await api.post('/operations/realtime-storm/stop')
      return data
    },
    async getRealtimeStormStatus() {
      const { data } = await api.get('/operations/realtime-storm/status')
      return data
    },
    upsertFlight(payload) {
      const flight = payload.flight_number ? payload : payload.flight
      const index = this.flights.findIndex((item) => item.id === flight.id)

      // Upsert evita perda de ordenação global e mantém reatividade local.
      if (index >= 0) {
        this.flights[index] = { ...this.flights[index], ...flight }
      } else {
        this.flights.unshift(flight)
      }
    },
    prependAlert(alert) {
      this.alerts.unshift(alert)
    },
    prependEvent(event) {
      this.events.unshift(event)
    },
    setLastReallocation(reallocations) {
      this.lastReallocation = reallocations
    }
  }
})
