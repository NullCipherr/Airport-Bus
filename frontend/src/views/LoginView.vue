<!-- =============================================================
  AeroSync Ops
  Autor: Andrei Roberto da Costa
  Data: 2026-03-27
  Hora: 15:37:28 -03
  Arquivo: frontend/src/views/LoginView.vue
  ============================================================= -->

<script setup>
import { reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const auth = useAuthStore()

const form = reactive({
  email: 'supervisor@aerosync.local',
  password: 'AeroSync123!'
})

async function submit() {
  const ok = await auth.login(form)

  if (ok) {
    router.push('/')
  }
}
</script>

<template>
  <div class="login-page">
    <div class="login-card">
      <p class="brand-kicker">AeroSync Ops</p>
      <h1>Gestão Operacional Aeroportuária</h1>
      <p class="subtitle">Plataforma em tempo real para supervisores e operadores.</p>

      <form class="form" @submit.prevent="submit">
        <label>
          E-mail
          <input v-model="form.email" type="email" required />
        </label>

        <label>
          Senha
          <input v-model="form.password" type="password" required />
        </label>

        <button class="btn primary" :disabled="auth.loading" type="submit">
          {{ auth.loading ? 'Entrando...' : 'Entrar' }}
        </button>
      </form>

      <p v-if="auth.error" class="error-msg">{{ auth.error }}</p>
      <p class="hint">Perfis seed: supervisor / operador com senha `AeroSync123!`.</p>
    </div>
  </div>
</template>
