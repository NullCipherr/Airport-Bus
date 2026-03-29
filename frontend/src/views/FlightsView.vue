<!-- =============================================================
  AeroSync Ops
  Autor: Andrei Roberto da Costa
  Data: 2026-03-27
  Hora: 15:37:28 -03
  Arquivo: frontend/src/views/FlightsView.vue
  ============================================================= -->

<script setup>
import { onMounted } from 'vue'
import AppShell from '../layouts/AppShell.vue'
import DataTable from '../components/DataTable.vue'
import StatusPill from '../components/StatusPill.vue'
import { useOpsStore } from '../stores/ops'

const ops = useOpsStore()

const columns = [
  { key: 'flight_number', label: 'Voo' },
  { key: 'airline', label: 'Companhia' },
  { key: 'route', label: 'Origem / Destino' },
  { key: 'status', label: 'Status' },
  { key: 'gate_id', label: 'Portão' },
  { key: 'belt_id', label: 'Esteira' },
  { key: 'actions', label: 'Ações' }
]

onMounted(async () => {
  await ops.loadFlights()
})

function routeLabel(row) {
  return `${row.origin} → ${row.destination}`
}
</script>

<template>
  <AppShell>
    <template #header>
      <div class="header-row">
        <div>
          <h2>Gestão de Voos</h2>
          <p>Controle de status, prioridade e operação de solo.</p>
        </div>
      </div>
    </template>

    <article class="card">
      <DataTable :columns="columns" :rows="ops.flights">
        <template #cell-route="{ row }">{{ routeLabel(row) }}</template>
        <template #cell-status="{ row }">
          <StatusPill :status="row.status" />
        </template>
        <template #cell-actions="{ row }">
          <button class="btn small warning" @click="ops.simulateDelay(row.id, 25)">Simular atraso</button>
        </template>
      </DataTable>
    </article>
  </AppShell>
</template>
