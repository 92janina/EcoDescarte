import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import CategoriasView from '../views/CategoriasView.vue'
import AdminView from '../views/AdminView.vue'
import LoginView from '../views/LoginView.vue'
import MeusDescartesView from '../views/MeusDescartesView.vue'

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
      path: '/admin',
      name: 'admin',
      component: AdminView
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView
    },
    {
      path: '/meus-descartes',
      name: 'meus-descartes',
      component: MeusDescartesView
}
  ]
})

export default router