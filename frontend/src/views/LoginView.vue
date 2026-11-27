<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const modo = ref('login') // 'login' ou 'cadastro'
const erro = ref('')
const sucesso = ref('')

const form = ref({
  nome: '',
  email: '',
  senha: '',
  confirmarSenha: ''
})

function trocarModo(novoModo) {
  modo.value = novoModo
  erro.value = ''
  sucesso.value = ''
}

function handleSubmit() {
  erro.value = ''
  sucesso.value = ''

  if (!form.value.email || !form.value.senha) {
    erro.value = 'Preencha o e-mail e a senha.'
    return
  }

  if (modo.value === 'cadastro') {
    if (!form.value.nome.trim()) {
      erro.value = 'Informe o seu nome completo.'
      return
    }
    if (form.value.senha.length < 6) {
      erro.value = 'A senha deve ter pelo menos 6 caracteres.'
      return
    }
    if (form.value.senha !== form.value.confirmarSenha) {
      erro.value = 'As senhas não conferem.'
      return
    }

    const usuario = {
      nome: form.value.nome.trim(),
      email: form.value.email.trim(),
      perfil: 'cidadao'
    }

    localStorage.setItem('ecodescarte_user', JSON.stringify(usuario))
    sucesso.value = 'Conta criada com sucesso! Redirecionando...'
  } else {
    const usuarioSalvo = JSON.parse(localStorage.getItem('ecodescarte_user') || 'null')
    const usuario = usuarioSalvo && usuarioSalvo.email === form.value.email.trim()
      ? usuarioSalvo
      : {
          nome: form.value.email.split('@')[0],
          email: form.value.email.trim(),
          perfil: 'cidadao'
        }

    localStorage.setItem('ecodescarte_user', JSON.stringify(usuario))
    sucesso.value = 'Login realizado com sucesso! Redirecionando...'
  }

  setTimeout(() => {
    router.push('/')
  }, 1000)
}
</script>

<template>
  <section class="auth-page">
    <div class="auth-card">
      <div class="auth-header">
        <h1>♻️ EcoDescarte</h1>
        <p>
          {{
            modo === 'login'
              ? 'Entre para registrar e acompanhar seus descartes.'
              : 'Crie sua conta gratuita e comece a registrar seus descartes.'
          }}
        </p>
      </div>

      <div class="tabs">
        <button
          type="button"
          :class="['tab-btn', { active: modo === 'login' }]"
          @click="trocarModo('login')"
        >
          Entrar
        </button>
        <button
          type="button"
          :class="['tab-btn', { active: modo === 'cadastro' }]"
          @click="trocarModo('cadastro')"
        >
          Criar Conta
        </button>
      </div>

      <form class="auth-form" @submit.prevent="handleSubmit">
        <div v-if="modo === 'cadastro'" class="field">
          <label>Nome completo</label>
          <input
            v-model="form.nome"
            type="text"
            placeholder="Ex: Maria Silva"
            required
          />
        </div>

        <div class="field">
          <label>E-mail</label>
          <input
            v-model="form.email"
            type="email"
            placeholder="seu@email.com"
            required
          />
        </div>

        <div class="field">
          <label>Senha</label>
          <input
            v-model="form.senha"
            type="password"
            placeholder="••••••••"
            required
          />
        </div>

        <div v-if="modo === 'cadastro'" class="field">
          <label>Confirmar senha</label>
          <input
            v-model="form.confirmarSenha"
            type="password"
            placeholder="Repita sua senha"
            required
          />
        </div>

        <p v-if="erro" class="msg-erro">{{ erro }}</p>
        <p v-if="sucesso" class="msg-sucesso">{{ sucesso }}</p>

        <button type="submit" class="btn-submit">
          {{ modo === 'login' ? 'Entrar' : 'Cadastrar' }}
        </button>
      </form>
    </div>
  </section>
</template>

<style scoped>
.auth-page {
  min-height: calc(100vh - 70px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem 1rem;
}

.auth-card {
  width: 100%;
  max-width: 420px;
  background: #ffffff;
  border-radius: 12px;
  padding: 2rem;
  box-shadow: 0 4px 14px rgba(0, 0, 0, 0.08);
}

.auth-header {
  text-align: center;
  margin-bottom: 1.5rem;
}

.auth-header h1 {
  color: #1b4332;
  font-size: 1.6rem;
  margin-bottom: 0.4rem;
}

.auth-header p {
  color: #4b5563;
  font-size: 0.92rem;
}

.tabs {
  display: grid;
  grid-template-columns: 1fr 1fr;
  background-color: #f3f4f6;
  border-radius: 8px;
  padding: 0.25rem;
  margin-bottom: 1.5rem;
}

.tab-btn {
  border: none;
  background: transparent;
  padding: 0.6rem;
  border-radius: 6px;
  font-weight: 600;
  color: #4b5563;
  cursor: pointer;
  transition: all 0.2s;
}

.tab-btn.active {
  background-color: #ffffff;
  color: #1b4332;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08);
}

.auth-form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
}

.field label {
  font-size: 0.9rem;
  font-weight: 600;
  color: #374151;
}

.field input {
  padding: 0.65rem 0.85rem;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  font-size: 0.95rem;
}

.field input:focus {
  outline: none;
  border-color: #2d6a4f;
}

.btn-submit {
  background-color: #1b4332;
  color: #ffffff;
  border: none;
  padding: 0.8rem;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  margin-top: 0.4rem;
}

.btn-submit:hover {
  background-color: #2d6a4f;
}

.msg-erro {
  color: #b91c1c;
  background-color: #fee2e2;
  padding: 0.6rem;
  border-radius: 6px;
  font-size: 0.88rem;
  text-align: center;
}

.msg-sucesso {
  color: #15803d;
  background-color: #dcfce7;
  padding: 0.6rem;
  border-radius: 6px;
  font-size: 0.88rem;
  text-align: center;
}
</style>