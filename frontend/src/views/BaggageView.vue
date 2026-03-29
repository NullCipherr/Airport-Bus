<!-- =============================================================
  AeroSync Ops
  Autor: Andrei Roberto da Costa
  Data: 2026-03-27
  Hora: 15:37:28 -03
  Arquivo: frontend/src/views/BaggageView.vue
  ============================================================= -->

<script setup>
import { computed, onMounted } from 'vue'
import AppShell from '../layouts/AppShell.vue'
import DataTable from '../components/DataTable.vue'
import StatusPill from '../components/StatusPill.vue'
import { useOpsStore } from '../stores/ops'

const ops = useOpsStore()

const columns = [
  { key: 'flight_number', label: 'Voo' },
  { key: 'airline', label: 'Companhia' },
  { key: 'requires_baggage_unload', label: 'Descarregamento' },
  { key: 'belt_id', label: 'Esteira' },
  { key: 'status', label: 'Status' }
]

const baggageFlights = computed(() => ops.flights.filter((flight) => flight.requires_baggage_unload))

onMounted(async () => {
  await ops.loadFlights()
  await ops.loadBelts()
})

function beltCode(beltId) {
  const belt = ops.belts.find((item) => item.id === beltId)
  return belt?.code || '--'
}
</script>

<template>
  <AppShell>
    <template #header>
      <div class="header-row">
        <div>
          <h2>Gestão de Bagagens</h2>
          <p>Monitoramento de voos com operação de esteira e alertas de troca.</p>
        </div>
      </div>
    </template>

    <article class="card">
      <DataTable :columns="columns" :rows="baggageFlights">
        <template #cell-requires_baggage_unload="{ row }">{{ row.requires_baggage_unload ? 'Sim' : 'Não' }}</template>
        <template #cell-belt_id="{ row }">{{ beltCode(row.belt_id) }}</template>
        <template #cell-status="{ row }">
          <StatusPill :status="row.status" />
        </template>
      </DataTable>
    </article>
  </AppShell>
</template>
