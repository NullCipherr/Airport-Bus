<!-- =============================================================
  AeroSync Ops
  Autor: Andrei Roberto da Costa
  Data: 2026-03-27
  Hora: 15:37:28 -03
  Arquivo: frontend/src/views/GatesBeltsView.vue
  ============================================================= -->

<script setup>
import { onMounted } from 'vue'
import AppShell from '../layouts/AppShell.vue'
import DataTable from '../components/DataTable.vue'
import StatusPill from '../components/StatusPill.vue'
import { useOpsStore } from '../stores/ops'

const ops = useOpsStore()

const gateColumns = [
  { key: 'code', label: 'Portão' },
  { key: 'terminal', label: 'Terminal' },
  { key: 'state', label: 'Estado' },
  { key: 'current_flight_number', label: 'Voo atual' }
]

const beltColumns = [
  { key: 'code', label: 'Esteira' },
  { key: 'terminal', label: 'Terminal' },
  { key: 'state', label: 'Estado' },
  { key: 'current_flight_number', label: 'Voo atual' }
]

onMounted(async () => {
  await Promise.all([ops.loadGates(), ops.loadBelts()])
})
</script>

<template>
  <AppShell>
    <template #header>
      <div class="header-row">
        <div>
          <h2>Portões e Esteiras</h2>
          <p>Gestão de ocupação, disponibilidade e conflitos operacionais.</p>
        </div>
      </div>
    </template>

    <section class="two-columns">
      <article class="card">
        <h3>Portões</h3>
        <DataTable :columns="gateColumns" :rows="ops.gates">
          <template #cell-state="{ row }">
            <StatusPill :status="row.state" />
          </template>
        </DataTable>
      </article>

      <article class="card">
        <h3>Esteiras</h3>
        <DataTable :columns="beltColumns" :rows="ops.belts">
          <template #cell-state="{ row }">
            <StatusPill :status="row.state" />
          </template>
        </DataTable>
      </article>
    </section>
  </AppShell>
</template>
