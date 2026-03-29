<!-- =============================================================
  AeroSync Ops
  Autor: Andrei Roberto da Costa
  Data: 2026-03-27
  Hora: 15:37:28 -03
  Arquivo: frontend/src/views/MonitoringView.vue
  ============================================================= -->

<script setup>
import { onMounted } from 'vue'
import AppShell from '../layouts/AppShell.vue'
import StatusPill from '../components/StatusPill.vue'
import { useOpsStore } from '../stores/ops'
import { connectRealtime } from '../services/realtime'

const ops = useOpsStore()

onMounted(async () => {
  await Promise.all([ops.loadDashboard(), ops.loadAlerts(), ops.loadEvents()])
  connectRealtime()
})
</script>

<template>
  <AppShell>
    <template #header>
      <div class="header-row">
        <div>
          <h2>Monitoramento em Tempo Real</h2>
          <p>Eventos operacionais propagados instantaneamente para toda a operação.</p>
        </div>
      </div>
    </template>

    <section class="two-columns">
      <article class="card">
        <h3>Alertas ativos</h3>
        <div class="stack">
          <div v-for="alert in ops.activeAlerts.slice(0, 12)" :key="alert.id" class="inline-item">
            <div>
              <strong>{{ alert.title }}</strong>
              <p>{{ alert.description }}</p>
            </div>
            <StatusPill :status="alert.level" />
          </div>
        </div>
      </article>

      <article class="card">
        <h3>Eventos recentes</h3>
        <ul class="timeline">
          <li v-for="event in ops.events.slice(0, 20)" :key="event.id">
            <span>{{ new Date(event.inserted_at).toLocaleTimeString('pt-BR') }}</span>
            <p>{{ event.message }}</p>
          </li>
        </ul>
      </article>
    </section>
  </AppShell>
</template>
