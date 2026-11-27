import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import CategoriasView from '../views/CategoriasView.vue'
import AdminView from '../views/AdminView.vue'
import LoginView from '../views/LoginView.vue'
import MeusDescartesView from '../views/MeusDescartesView.vue'

function estaAutenticado() {
  try {
    const salvo = localStorage.getItem('ecodescarte_user')
    return Boolean(salvo && JSON.parse(salvo)?.email)
  } catch {
    return false
  }
}

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/categorias',
      name: 'categorias',
      component: CategoriasView
    },
    {
      path: '/meus-descartes',
      name: 'meus-descartes',
      component: MeusDescartesView,
      meta: { requiresAuth: true }
    },
    {
      path: '/admin',
      name: 'admin',
      component: AdminView,
      meta: { requiresAuth: true }
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView,
      meta: { guestOnly: true }
    }
  ]
})

router.beforeEach((to) => {
  const autenticado = estaAutenticado()

  if (to.meta.requiresAuth && !autenticado) {
    return {
      name: 'login',
      query: { redirect: to.fullPath }
    }
  }

  if (to.meta.guestOnly && autenticado) {
    return { name: 'home' }
  }
})

export default router