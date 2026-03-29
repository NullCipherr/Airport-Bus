<!-- =============================================================
  AeroSync Ops
  Autor: Andrei Roberto da Costa
  Data: 2026-03-27
  Hora: 15:37:28 -03
  Arquivo: frontend/src/views/EmployeesView.vue
  ============================================================= -->

<script setup>
import { onMounted } from 'vue'
import AppShell from '../layouts/AppShell.vue'
import DataTable from '../components/DataTable.vue'
import StatusPill from '../components/StatusPill.vue'
import { useOpsStore } from '../stores/ops'

const ops = useOpsStore()

const columns = [
  { key: 'name', label: 'Nome' },
  { key: 'role', label: 'Função' },
  { key: 'sector', label: 'Setor' },
  { key: 'shift', label: 'Turno' },
  { key: 'availability', label: 'Disponibilidade' },
  { key: 'current_location', label: 'Local atual' }
]

onMounted(async () => {
  await ops.loadEmployees()
})
</script>

<template>
  <AppShell>
    <template #header>
      <div class="header-row">
        <div>
          <h2>Gestão de Funcionários</h2>
          <p>Visibilidade de disponibilidade, setor e alocação.</p>
        </div>
      </div>
    </template>

    <article class="card">
      <DataTable :columns="columns" :rows="ops.employees">
        <template #cell-availability="{ row }">
          <StatusPill :status="row.availability" />
        </template>
      </DataTable>
    </article>
  </AppShell>
</template>
