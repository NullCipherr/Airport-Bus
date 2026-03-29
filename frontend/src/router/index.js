/* =============================================================
 * AeroSync Ops
 * Autor: Andrei Roberto da Costa
 * Data: 2026-03-27
 * Hora: 15:37:28 -03
 * Arquivo: frontend/src/router/index.js
 * ============================================================= */
import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'

import LoginView from '../views/LoginView.vue'
import DashboardView from '../views/DashboardView.vue'
import FlightsView from '../views/FlightsView.vue'
import EmployeesView from '../views/EmployeesView.vue'
import TeamsView from '../views/TeamsView.vue'
import BaggageView from '../views/BaggageView.vue'
import GatesBeltsView from '../views/GatesBeltsView.vue'
import SchedulesView from '../views/SchedulesView.vue'
import MonitoringView from '../views/MonitoringView.vue'
import AdminView from '../views/AdminView.vue'

const routes = [
  { path: '/login', name: 'login', component: LoginView, meta: { public: true } },
  { path: '/', name: 'dashboard', component: DashboardView },
  { path: '/flights', name: 'flights', component: FlightsView },
  { path: '/employees', name: 'employees', component: EmployeesView },
  { path: '/teams', name: 'teams', component: TeamsView },
  { path: '/baggage', name: 'baggage', component: BaggageView },
  { path: '/gates-belts', name: 'gates-belts', component: GatesBeltsView },
  { path: '/schedules', name: 'schedules', component: SchedulesView },
  { path: '/monitoring', name: 'monitoring', component: MonitoringView },
  { path: '/admin', name: 'admin', component: AdminView }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to) => {
  const auth = useAuthStore()

  // Guarda de rota simples para proteger todo o workspace operacional.
  if (!to.meta.public && !auth.isAuthenticated) {
    return { name: 'login' }
  }

  if (to.name === 'login' && auth.isAuthenticated) {
    return { name: 'dashboard' }
  }

  return true
})

export default router
