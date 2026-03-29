<!-- =============================================================
  AeroSync Ops
  Autor: Andrei Roberto da Costa
  Data: 2026-03-27
  Hora: 15:37:28 -03
  Arquivo: frontend/src/components/DataTable.vue
  ============================================================= -->

<script setup>
// Componente de tabela genérico: a renderização de células específicas fica
// nos slots `cell-*` para evitar acoplamento com qualquer entidade de domínio.
defineProps({
  columns: {
    type: Array,
    required: true
  },
  rows: {
    type: Array,
    required: true
  },
  emptyText: {
    type: String,
    default: 'Nenhum registro encontrado.'
  }
})
</script>

<template>
  <div class="table-wrap">
    <table class="table">
      <thead>
        <tr>
          <th v-for="col in columns" :key="col.key">{{ col.label }}</th>
        </tr>
      </thead>
      <tbody>
        <tr v-if="!rows.length">
          <td :colspan="columns.length" class="empty">{{ emptyText }}</td>
        </tr>
        <tr v-for="(row, rowIndex) in rows" :key="row.id || rowIndex">
          <td v-for="col in columns" :key="`${row.id || rowIndex}-${col.key}`">
            <slot :name="`cell-${col.key}`" :row="row">
              {{ row[col.key] }}
            </slot>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
