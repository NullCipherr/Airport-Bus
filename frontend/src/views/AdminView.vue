<!-- =============================================================
  AeroSync Ops
  Autor: Andrei Roberto da Costa
  Data: 2026-03-27
  Hora: 15:37:28 -03
  Arquivo: frontend/src/views/AdminView.vue
  ============================================================= -->

<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import AppShell from '../layouts/AppShell.vue'
import { useOpsStore } from '../stores/ops'

const ops = useOpsStore()
const selectedFlight = ref('')
const delayMinutes = ref(20)
const feedback = ref('')
const stormStatus = ref(null)
const massLoading = ref(false)
const stormLoading = ref(false)
const massStatus = ref(null)
let massPoll = null
const massive = ref({
  gates: 40,
  belts: 20,
  employees: 900,
  teams: 220,
  flights: 1600,
  alerts: 450,
  logs: 6000
})
const realtime = ref({
  interval_ms: 250,
  batch_size: 20
})

onMounted(async () => {
  await ops.loadFlights()
  const status = await ops.getRealtimeStormStatus()
  stormStatus.value = status.data
  const mStatus = await ops.getMassiveSeedStatus()
  massStatus.value = mStatus.data
})

onUnmounted(() => {
  if (massPoll) {
    clearInterval(massPoll)
    massPoll = null
  }
})

async function simulateDelay() {
  if (!selectedFlight.value) {
    feedback.value = 'Selecione um voo para simular atraso.'
    return
  }

  await ops.simulateDelay(selectedFlight.value, Number(delayMinutes.value))
  feedback.value = 'Atraso aplicado e eventos propagados.'
}

async function simulateReallocation() {
  await ops.simulateReallocation()
  feedback.value = 'Remanejamento automático executado.'
}

async function runMassiveSeed() {
  massLoading.value = true
  feedback.value = 'Iniciando geração massiva em background...'

  try {
    await ops.generateMassiveDataset(massive.value)
    startMassivePoll()
    feedback.value = 'Processamento massivo em execução. Aguarde o status.'
  } catch (error) {
    feedback.value = error.response?.data?.error || 'Falha ao gerar massa. Reduza os volumes e tente novamente.'
  }
}

async function startStorm() {
  stormLoading.value = true

  try {
    const result = await ops.startRealtimeStorm(realtime.value)
    stormStatus.value = result.data
    feedback.value = `Tempestade em tempo real iniciada (${result.data.batch_size} eventos por ciclo).`
  } catch (error) {
    feedback.value = error.response?.data?.error || 'Falha ao iniciar tempestade realtime.'
  } finally {
    stormLoading.value = false
  }
}

async function stopStorm() {
  stormLoading.value = true

  try {
    const result = await ops.stopRealtimeStorm()
    stormStatus.value = result.data
    feedback.value = 'Tempestade de eventos interrompida.'
  } catch (error) {
    feedback.value = error.response?.data?.error || 'Falha ao parar tempestade realtime.'
  } finally {
    stormLoading.value = false
  }
}

function startMassivePoll() {
  if (massPoll) {
    clearInterval(massPoll)
    massPoll = null
  }

  massPoll = setInterval(async () => {
    try {
      const result = await ops.getMassiveSeedStatus()
      massStatus.value = result.data

      if (result.data.status === 'completed') {
        clearInterval(massPoll)
        massPoll = null
        massLoading.value = false
        await Promise.all([ops.loadDashboard(), ops.loadFlights(), ops.loadAlerts(), ops.loadEvents()])
        feedback.value = 'Geração massiva concluída com sucesso.'
      }

      if (result.data.status === 'failed') {
        clearInterval(massPoll)
        massPoll = null
        massLoading.value = false
        feedback.value = `Falha na geração massiva: ${result.data.last_error || 'erro desconhecido'}`
      }
    } catch (_error) {
      clearInterval(massPoll)
      massPoll = null
      massLoading.value = false
      feedback.value = 'Falha ao consultar status da geração massiva.'
    }
  }, 2000)
}
</script>

<template>
  <AppShell>
    <template #header>
      <div class="header-row">
        <div>
          <h2>Painel Administrativo</h2>
          <p>Simulações de cenários operacionais e acionamento de regras dinâmicas.</p>
        </div>
      </div>
    </template>

    <section class="two-columns">
      <article class="card">
        <h3>Simular atraso de voo</h3>
        <div class="form inline-form">
          <label>
            Voo
            <select v-model="selectedFlight">
              <option disabled value="">Selecione</option>
              <option v-for="flight in ops.flights" :key="flight.id" :value="flight.id">
                {{ flight.flight_number }} - {{ flight.origin }} → {{ flight.destination }}
              </option>
            </select>
          </label>

          <label>
            Minutos
            <input v-model.number="delayMinutes" type="number" min="5" max="240" />
          </label>

          <button class="btn warning" @click="simulateDelay">Aplicar atraso</button>
        </div>
      </article>

      <article class="card">
        <h3>Remanejamento automático</h3>
        <p>Executa as regras de realocação com base em prioridade, disponibilidade e conflito operacional.</p>
        <button class="btn secondary" @click="simulateReallocation">Executar remanejamento</button>
      </article>
    </section>

    <section class="two-columns">
      <article class="card">
        <h3>Gerar Massa Operacional (perfil hub)</h3>
        <div class="form">
          <label>Voos <input v-model.number="massive.flights" type="number" min="500" step="100" /></label>
          <label>Funcionários <input v-model.number="massive.employees" type="number" min="300" step="50" /></label>
          <label>Equipes <input v-model.number="massive.teams" type="number" min="100" step="20" /></label>
          <label>Portões <input v-model.number="massive.gates" type="number" min="20" step="5" /></label>
          <label>Esteiras <input v-model.number="massive.belts" type="number" min="10" step="2" /></label>
          <label>Alertas <input v-model.number="massive.alerts" type="number" min="100" step="50" /></label>
          <label>Logs <input v-model.number="massive.logs" type="number" min="1000" step="500" /></label>
          <button class="btn warning" :disabled="massLoading" @click="runMassiveSeed">
            {{ massLoading ? 'Gerando massa...' : 'Gerar massa agora' }}
          </button>
          <p v-if="massStatus">
            Status massa: <strong>{{ massStatus.status }}</strong>
          </p>
        </div>
      </article>

      <article class="card">
        <h3>Tempestade Realtime</h3>
        <div class="form">
          <label>Intervalo (ms) <input v-model.number="realtime.interval_ms" type="number" min="30" step="10" /></label>
          <label>Eventos por ciclo <input v-model.number="realtime.batch_size" type="number" min="1" step="1" /></label>
          <div class="actions">
            <button class="btn secondary" :disabled="stormLoading" @click="startStorm">Iniciar storm</button>
            <button class="btn warning" :disabled="stormLoading" @click="stopStorm">Parar storm</button>
          </div>
          <p v-if="stormStatus">
            Status: <strong>{{ stormStatus.running ? 'ativo' : 'parado' }}</strong> |
            intervalo: {{ stormStatus.interval_ms || '-' }} ms |
            lote: {{ stormStatus.batch_size || '-' }}
          </p>
        </div>
      </article>
    </section>

    <article v-if="feedback" class="card feedback">
      <p>{{ feedback }}</p>
    </article>
  </AppShell>
</template>
