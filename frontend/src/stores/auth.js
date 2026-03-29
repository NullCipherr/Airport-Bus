/* =============================================================
 * AeroSync Ops
 * Autor: Andrei Roberto da Costa
 * Data: 2026-03-27
 * Hora: 15:37:28 -03
 * Arquivo: frontend/src/stores/auth.js
 * ============================================================= */
import { defineStore } from 'pinia'
import api from '../services/api'

const TOKEN_KEY = 'aerosync_token'
const USER_KEY = 'aerosync_user'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: localStorage.getItem(TOKEN_KEY),
    user: JSON.parse(localStorage.getItem(USER_KEY) || 'null'),
    loading: false,
    error: ''
  }),
  getters: {
    isAuthenticated: (state) => Boolean(state.token)
  },
  actions: {
    async login(credentials) {
      this.loading = true
      this.error = ''

      try {
        const { data } = await api.post('/auth/login', credentials)
        this.token = data.token
        this.user = data.user

        localStorage.setItem(TOKEN_KEY, this.token)
        localStorage.setItem(USER_KEY, JSON.stringify(this.user))
        return true
      } catch (error) {
        this.error = error.response?.data?.error || 'Falha ao autenticar'
        return false
      } finally {
        this.loading = false
      }
    },
    logout() {
      this.token = null
      this.user = null
      localStorage.removeItem(TOKEN_KEY)
      localStorage.removeItem(USER_KEY)
    }
  }
})
