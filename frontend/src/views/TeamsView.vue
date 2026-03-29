<!-- =============================================================
  AeroSync Ops
  Autor: Andrei Roberto da Costa
  Data: 2026-03-27
  Hora: 15:37:28 -03
  Arquivo: frontend/src/views/TeamsView.vue
  ============================================================= -->

<script setup>
import { onMounted } from 'vue'
import AppShell from '../layouts/AppShell.vue'
import DataTable from '../components/DataTable.vue'
import StatusPill from '../components/StatusPill.vue'
import { useOpsStore } from '../stores/ops'

const ops = useOpsStore()

const columns = [
  { key: 'name', label: 'Equipe' },
  { key: 'team_type', label: 'Tipo' },
  { key: 'is_available', label: 'Disponibilidade' }
]

onMounted(async () => {
  await ops.loadTeams()
})

</script>

<template>
  <AppShell>
    <template #header>
      <div class="header-row">
        <div>
          <h2>Equipes Operacionais</h2>
          <p>Composição e disponibilidade das equipes por tipo de operação.</p>
        </div>
        <div class="actions">
          <button class="btn secondary" @click="ops.simulateReallocation">Remanejamento automático</button>
        </div>
      </div>
    </template>

    <article class="card">
      <DataTable :columns="columns" :rows="ops.teams">
        <template #cell-team_type="{ row }">{{ row.team_type.replace('_', ' ') }}</template>
        <template #cell-is_available="{ row }">
          <StatusPill :status="row.is_available ? 'disponivel' : 'indisponivel'" />
        </template>
      </DataTable>
    </article>

    <article class="card" v-if="ops.lastReallocation.length">
      <h3>Último remanejamento</h3>
      <ul class="timeline">
        <li v-for="item in ops.lastReallocation" :key="`${item.flight_id}-${item.team_id || 'none'}`">
          <span>{{ item.status }}</span>
          <p>Voo {{ item.flight_id }} {{ item.team_id ? `recebeu equipe ${item.team_id}` : 'sem equipe disponível' }}</p>
        </li>
      </ul>
    </article>
  </AppShell>
</template>
