<!-- =============================================================
  AeroSync Ops
  Autor: Andrei Roberto da Costa
  Data: 2026-03-27
  Hora: 15:37:28 -03
  Arquivo: frontend/src/views/SchedulesView.vue
  ============================================================= -->

<script setup>
import { onMounted } from 'vue'
import AppShell from '../layouts/AppShell.vue'
import DataTable from '../components/DataTable.vue'
import { useOpsStore } from '../stores/ops'

const ops = useOpsStore()

const columns = [
  { key: 'employee_id', label: 'Funcionário' },
  { key: 'sector', label: 'Setor' },
  { key: 'start_time', label: 'Início' },
  { key: 'end_time', label: 'Fim' }
]

onMounted(async () => {
  await Promise.all([ops.loadSchedules(), ops.loadEmployees()])
})

function employeeName(employeeId) {
  const employee = ops.employees.find((item) => item.id === employeeId)
  return employee?.name || employeeId
}
</script>

<template>
  <AppShell>
    <template #header>
      <div class="header-row">
        <div>
          <h2>Escala de Funcionários</h2>
          <p>Controle de horários por setor e conflitos de disponibilidade.</p>
        </div>
      </div>
    </template>

    <article class="card">
      <DataTable :columns="columns" :rows="ops.schedules">
        <template #cell-employee_id="{ row }">{{ employeeName(row.employee_id) }}</template>
        <template #cell-start_time="{ row }">{{ new Date(row.start_time).toLocaleString('pt-BR') }}</template>
        <template #cell-end_time="{ row }">{{ new Date(row.end_time).toLocaleString('pt-BR') }}</template>
      </DataTable>
    </article>
  </AppShell>
</template>
