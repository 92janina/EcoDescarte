<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

const usuario = ref(null)

function carregarUsuario() {
  try {
    const salvo = localStorage.getItem('ecodescarte_user')
    usuario.value = salvo ? JSON.parse(salvo) : null
  } catch {
    usuario.value = null
  }
}

const primeiroNome = computed(() => {
  if (!usuario.value?.nome) return ''
  return usuario.value.nome.split(' ')[0]
})

function sair() {
  localStorage.removeItem('ecodescarte_user')
  usuario.value = null
  router.push('/login')
}

onMounted(carregarUsuario)

// Revalida o usuário sempre que a rota mudar (ex: redirecionamento pós-login)
watch(() => route.fullPath, carregarUsuario)
</script>

<template>
  <header class="navbar">
    <div class="navbar-container">
      <RouterLink to="/" class="logo">
        ♻️ EcoDescarte
      </RouterLink>

      <nav class="nav-links">
        <RouterLink to="/">Início</RouterLink>
        <RouterLink to="/categorias">Categorias</RouterLink>
        <RouterLink to="/meus-descartes">Meus Descartes</RouterLink>
        <RouterLink to="/admin">Admin</RouterLink>

        <div v-if="usuario" class="user-menu">
          <span class="user-greeting">Olá, {{ primeiroNome }}</span>
          <button type="button" class="btn-sair" @click="sair">Sair</button>
        </div>

        <RouterLink v-else to="/login" class="btn-entrar">
          Entrar
        </RouterLink>
      </nav>
    </div>
  </header>
</template>

<style scoped>
.navbar {
  background-color: #1b4332;
  color: #ffffff;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.12);
}

.navbar-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0.9rem 1.5rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  flex-wrap: wrap;
}

.logo {
  font-size: 1.35rem;
  font-weight: 700;
  color: #ffffff;
  text-decoration: none;
  display: flex;
  align-items: center;
  gap: 0.4rem;
}

.nav-links {
  display: flex;
  align-items: center;
  gap: 1.4rem;
  flex-wrap: wrap;
}

.nav-links a {
  color: #e5e7eb;
  text-decoration: none;
  font-weight: 500;
  font-size: 0.95rem;
  transition: color 0.2s;
}

.nav-links a:hover,
.nav-links a.router-link-exact-active {
  color: #95d5b2;
}

.btn-entrar {
  background-color: #40916c;
  color: #ffffff !important;
  padding: 0.5rem 1.1rem;
  border-radius: 6px;
  font-weight: 600 !important;
  transition: background-color 0.2s;
}

.btn-entrar:hover {
  background-color: #52b788;
}

.user-menu {
  display: flex;
  align-items: center;
  gap: 0.85rem;
  padding-left: 0.6rem;
  border-left: 1px solid rgba(255, 255, 255, 0.25);
}

.user-greeting {
  color: #d8f3dc;
  font-size: 0.92rem;
  font-weight: 600;
}

.btn-sair {
  background-color: transparent;
  color: #fecaca;
  border: 1px solid #f87171;
  padding: 0.4rem 0.85rem;
  border-radius: 6px;
  font-size: 0.88rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-sair:hover {
  background-color: #dc2626;
  border-color: #dc2626;
  color: #ffffff;
}
</style>