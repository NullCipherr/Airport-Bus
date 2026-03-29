<!-- =============================================================
  AeroSync Ops
  Autor: Andrei Roberto da Costa
  Data: 2026-03-27
  Hora: 15:37:28 -03
  Arquivo: frontend/src/views/DashboardView.vue
  ============================================================= -->

<script setup>
import { onMounted } from 'vue'
import AppShell from '../layouts/AppShell.vue'
import StatusPill from '../components/StatusPill.vue'
import { useOpsStore } from '../stores/ops'
import { connectRealtime } from '../services/realtime'

const ops = useOpsStore()

onMounted(async () => {
  await ops.loadDashboard()
  connectRealtime()
})

const metrics = [
  { key: 'total_flights', label: 'Voos monitorados' },
  { key: 'delayed_flights', label: 'Voos atrasados' },
  { key: 'gates_occupied', label: 'Portões ocupados' },
  { key: 'belts_in_use', label: 'Esteiras em uso' },
  { key: 'available_teams', label: 'Equipes disponíveis' },
  { key: 'open_alerts', label: 'Alertas abertos' }
]
</script>

<template>
  <AppShell>
    <template #header>
      <div class="header-row">
        <div>
          <h2>Dashboard Operacional</h2>
          <p>Visão unificada em tempo real do aeroporto.</p>
        </div>
        <div class="actions">
          <button class="btn secondary" @click="ops.simulateReallocation">Simular Remanejamento</button>
        </div>
      </div>
    </template>

    <section class="metric-grid">
      <article v-for="metric in metrics" :key="metric.key" class="card metric-card">
        <p>{{ metric.label }}</p>
        <strong>{{ ops.overview?.[metric.key] ?? '--' }}</strong>
      </article>
    </section>

    <section class="two-columns">
      <article class="card">
        <h3>Voos críticos</h3>
        <div class="stack">
          <div v-for="flight in ops.delayedFlights.slice(0, 6)" :key="flight.id" class="inline-item">
            <div>
              <strong>{{ flight.flight_number }}</strong>
              <p>{{ flight.origin }} → {{ flight.destination }}</p>
            </div>
            <StatusPill :status="flight.status" />
          </div>
        </div>
      </article>

      <article class="card">
        <h3>Alertas operacionais</h3>
        <div class="stack">
          <div v-for="alert in ops.alerts.slice(0, 6)" :key="alert.id" class="inline-item">
            <div>
              <strong>{{ alert.title }}</strong>
              <p>{{ alert.description }}</p>
            </div>
            <StatusPill :status="alert.level" />
          </div>
        </div>
      </article>
    </section>

    <section class="card">
      <h3>Logs operacionais recentes</h3>
      <ul class="timeline">
        <li v-for="event in ops.events.slice(0, 10)" :key="event.id">
          <span>{{ new Date(event.inserted_at).toLocaleTimeString('pt-BR') }}</span>
          <p>{{ event.message }}</p>
        </li>
      </ul>
    </section>
  </AppShell>
</template>
