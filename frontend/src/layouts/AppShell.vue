<!-- =============================================================
  AeroSync Ops
  Autor: Andrei Roberto da Costa
  Data: 2026-03-27
  Hora: 15:37:28 -03
  Arquivo: frontend/src/layouts/AppShell.vue
  ============================================================= -->

<script setup>
import { computed } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { disconnectRealtime } from '../services/realtime'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()

const menuItems = [
  { name: 'Dashboard', path: '/' },
  { name: 'Voos', path: '/flights' },
  { name: 'Funcionários', path: '/employees' },
  { name: 'Equipes', path: '/teams' },
  { name: 'Bagagens', path: '/baggage' },
  { name: 'Portões e Esteiras', path: '/gates-belts' },
  { name: 'Escalas', path: '/schedules' },
  { name: 'Tempo Real', path: '/monitoring' },
  { name: 'Admin', path: '/admin' }
]

const userLabel = computed(() => `${auth.user?.name || 'Sem usuário'} (${auth.user?.role || '-'})`)

function isActive(path) {
  return route.path === path
}

function logout() {
  disconnectRealtime()
  auth.logout()
  router.push('/login')
}
</script>

<template>
  <div class="shell">
    <aside class="sidebar">
      <div class="brand">
        <p class="brand-kicker">AeroSync Ops</p>
        <h1>Controle Operacional</h1>
      </div>

      <nav class="menu">
        <RouterLink
          v-for="item in menuItems"
          :key="item.path"
          :to="item.path"
          class="menu-link"
          :class="{ active: isActive(item.path) }"
        >
          {{ item.name }}
        </RouterLink>
      </nav>

      <div class="sidebar-footer">
        <p class="user-label">{{ userLabel }}</p>
        <button class="btn secondary" @click="logout">Sair</button>
      </div>
    </aside>

    <main class="content">
      <header class="topbar">
        <slot name="header" />
      </header>
      <section class="view-content">
        <slot />
      </section>
    </main>
  </div>
</template>
