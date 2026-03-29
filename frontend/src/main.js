/* =============================================================
 * AeroSync Ops
 * Autor: Andrei Roberto da Costa
 * Data: 2026-03-27
 * Hora: 15:37:28 -03
 * Arquivo: frontend/src/main.js
 * ============================================================= */
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import './styles.css'

const app = createApp(App)

app.use(createPinia())
app.use(router)
app.mount('#app')
