<!-- =============================================================
  AeroSync Ops
  Autor: Andrei Roberto da Costa
  Data: 2026-03-27
  Hora: 15:37:28 -03
  Arquivo: frontend/src/components/StatusPill.vue
  ============================================================= -->

<script setup>
import { computed } from 'vue'

const props = defineProps({
  status: {
    type: String,
    default: 'info'
  }
})

const classes = computed(() => {
  // Mapa centralizado para manter consistência visual entre todas as telas.
  const map = {
    atrasado: 'danger',
    cancelado: 'danger',
    warning: 'warning',
    embarcando: 'warning',
    critical: 'danger',
    open: 'danger',
    no_horario: 'ok',
    pousado: 'ok',
    finalizado: 'ok',
    disponivel: 'ok',
    indisponivel: 'danger',
    ocupado: 'warning',
    ocupada: 'warning',
    manutencao: 'neutral',
    acknowledged: 'neutral',
    resolved: 'ok'
  }

  return map[props.status] || 'neutral'
})
</script>

<template>
  <span class="status-pill" :class="classes">{{ status.replaceAll('_', ' ') }}</span>
</template>
