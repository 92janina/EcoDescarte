<script setup>
import { ref } from 'vue'
import axios from 'axios'

const materiaisDisponiveis = [
  'Eletrônicos',
  'Pilhas e Baterias',
  'Óleo de Cozinha',
  'Vidro',
  'Plástico',
  'Papel e Papelão'
]

const pontos = ref([
  {
    id: 1,
    nome: 'Ecoponto Centro Histórico',
    cep: '90020-020',
    endereco: 'Av. Borges de Medeiros, 500 - Centro, Porto Alegre/RS',
    horario: 'Seg a Sáb: 08h às 18h',
    materiais: ['Eletrônicos', 'Pilhas e Baterias', 'Vidro']
  },
  {
    id: 2,
    nome: 'Coleta Solidária Viamão',
    cep: '94410-000',
    endereco: 'Av. Sen. Salgado Filho, 1200 - Centro, Viamão/RS',
    horario: 'Seg a Sáb: 08h às 17h',
    materiais: ['Eletrônicos', 'Óleo de Cozinha', 'Plástico', 'Vidro']
  }
])

const form = ref({
  nome: '',
  cep: '',
  logradouro: '',
  numero: '',
  bairro: '',
  cidade: '',
  uf: '',
  horario: '',
  materiais: []
})

const buscandoCep = ref(false)
const erroCep = ref('')
const mensagemSucesso = ref('')

async function buscarCep() {
  erroCep.value = ''
  const cepLimpo = form.value.cep.replace(/\D/g, '')

  if (cepLimpo.length !== 8) {
    erroCep.value = 'Digite um CEP válido com 8 números.'
    return
  }

  buscandoCep.value = true
  try {
    const { data } = await axios.get(`https://viacep.com.br/ws/${cepLimpo}/json/`)
    if (data.erro) {
      erroCep.value = 'CEP não encontrado.'
      return
    }
    form.value.logradouro = data.logradouro || ''
    form.value.bairro = data.bairro || ''
    form.value.cidade = data.localidade || ''
    form.value.uf = data.uf || ''
  } catch (err) {
    erroCep.value = 'Erro ao consultar o ViaCEP. Tente novamente.'
  } finally {
    buscandoCep.value = false
  }
}

function cadastrarPonto() {
  if (!form.value.nome || !form.value.logradouro || form.value.materiais.length === 0) {
    alert('Preencha o nome, o endereço e selecione pelo menos um material aceito.')
    return
  }

  const novoPonto = {
    id: Date.now(),
    nome: form.value.nome,
    cep: form.value.cep,
    endereco: `${form.value.logradouro}, ${form.value.numero || 'S/N'} - ${form.value.bairro}, ${form.value.cidade}/${form.value.uf}`,
    horario: form.value.horario || 'Horário não informado',
    materiais: [...form.value.materiais]
  }

  pontos.value.unshift(novoPonto)

  // Limpa o formulário
  form.value = {
    nome: '',
    cep: '',
    logradouro: '',
    numero: '',
    bairro: '',
    cidade: '',
    uf: '',
    horario: '',
    materiais: []
  }

  mensagemSucesso.value = 'Ponto de coleta cadastrado com sucesso!'
  setTimeout(() => {
    mensagemSucesso.value = ''
  }, 3000)
}

function removerPonto(id) {
  pontos.value = pontos.value.filter((p) => p.id !== id)
}
</script>

<template>
  <section class="admin-page">
    <div class="header">
      <h1>Painel Administrativo</h1>
      <p>Cadastre e gerencie os pontos de coleta do EcoDescarte.</p>
    </div>

    <div class="admin-grid">
      <!-- Formulário de Cadastro -->
      <form class="card form-card" @submit.prevent="cadastrarPonto">
        <h2>Novo Ponto de Coleta</h2>

        <div class="field">
          <label>Nome do Ponto *</label>
          <input v-model="form.nome" type="text" placeholder="Ex: Ecoponto Bairro Centro" required />
        </div>

        <div class="field-row">
          <div class="field">
            <label>CEP *</label>
            <div class="cep-group">
              <input
                v-model="form.cep"
                type="text"
                placeholder="Ex: 94410-000"
                maxlength="9"
                @blur="buscarCep"
              />
              <button type="button" class="btn-cep" @click="buscarCep" :disabled="buscandoCep">
                {{ buscandoCep ? 'Buscando...' : 'Buscar' }}
              </button>
            </div>
            <small v-if="erroCep" class="erro">{{ erroCep }}</small>
          </div>

          <div class="field">
            <label>Número</label>
            <input v-model="form.numero" type="text" placeholder="Ex: 120" />
          </div>
        </div>

        <div class="field">
          <label>Rua / Avenida *</label>
          <input v-model="form.logradouro" type="text" placeholder="Preenchido pelo CEP" required />
        </div>

        <div class="field-row">
          <div class="field">
            <label>Bairro</label>
            <input v-model="form.bairro" type="text" placeholder="Bairro" />
          </div>
          <div class="field">
            <label>Cidade</label>
            <input v-model="form.cidade" type="text" placeholder="Cidade" />
          </div>
          <div class="field uf-field">
            <label>UF</label>
            <input v-model="form.uf" type="text" maxlength="2" placeholder="RS" />
          </div>
        </div>

        <div class="field">
          <label>Horário de Funcionamento</label>
          <input v-model="form.horario" type="text" placeholder="Ex: Seg a Sex: 08h às 18h" />
        </div>

        <div class="field">
          <label>Materiais Aceitos *</label>
          <div class="checkbox-grid">
            <label v-for="mat in materiaisDisponiveis" :key="mat" class="checkbox-item">
              <input type="checkbox" :value="mat" v-model="form.materiais" />
              <span>{{ mat }}</span>
            </label>
          </div>
        </div>

        <p v-if="mensagemSucesso" class="sucesso">{{ mensagemSucesso }}</p>

        <button type="submit" class="btn-submit">Cadastrar Ponto</button>
      </form>

      <!-- Lista de Pontos Cadastrados -->
      <div class="card list-card">
        <h2>Pontos Cadastrados ({{ pontos.length }})</h2>

        <div class="lista">
          <article v-for="ponto in pontos" :key="ponto.id" class="ponto-item">
            <div class="ponto-info">
              <h3>{{ ponto.nome }}</h3>
              <p>{{ ponto.endereco }}</p>
              <small>🕒 {{ ponto.horario }}</small>
              <div class="tags">
                <span v-for="mat in ponto.materiais" :key="mat" class="tag">{{ mat }}</span>
              </div>
            </div>
            <button class="btn-delete" @click="removerPonto(ponto.id)" title="Remover ponto">
              Excluir
            </button>
          </article>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.admin-page {
  max-width: 1100px;
  margin: 0 auto;
  padding: 2.5rem 1.5rem;
}

.header {
  margin-bottom: 2rem;
}

.header h1 {
  color: #1b4332;
  font-size: 2rem;
}

.header p {
  color: #4b5563;
  margin-top: 0.35rem;
}

.admin-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
  align-items: start;
}

@media (max-width: 850px) {
  .admin-grid {
    grid-template-columns: 1fr;
  }
}

.card {
  background: #ffffff;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.card h2 {
  color: #1b4332;
  font-size: 1.3rem;
  margin-bottom: 1.25rem;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
  margin-bottom: 1rem;
  flex: 1;
}

.field label {
  font-size: 0.9rem;
  font-weight: 600;
  color: #374151;
}

.field input[type='text'] {
  padding: 0.6rem 0.8rem;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  font-size: 0.95rem;
}

.field input:focus {
  outline: none;
  border-color: #2d6a4f;
}

.field-row {
  display: flex;
  gap: 0.75rem;
}

.uf-field {
  max-width: 75px;
}

.cep-group {
  display: flex;
  gap: 0.5rem;
}

.cep-group input {
  flex: 1;
}

.btn-cep {
  background-color: #40916c;
  color: #ffffff;
  border: none;
  border-radius: 6px;
  padding: 0 0.9rem;
  font-weight: 600;
  cursor: pointer;
}

.btn-cep:hover {
  background-color: #2d6a4f;
}

.checkbox-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0.5rem;
  margin-top: 0.25rem;
}

.checkbox-item {
  display: flex;
  align-items: center;
  gap: 0.45rem;
  font-weight: 400 !important;
  cursor: pointer;
}

.btn-submit {
  width: 100%;
  background-color: #1b4332;
  color: #ffffff;
  border: none;
  padding: 0.8rem;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  margin-top: 0.5rem;
}

.btn-submit:hover {
  background-color: #2d6a4f;
}

.erro {
  color: #dc2626;
  font-size: 0.85rem;
}

.sucesso {
  color: #15803d;
  background-color: #dcfce7;
  padding: 0.6rem;
  border-radius: 6px;
  font-size: 0.9rem;
  margin-bottom: 0.75rem;
  text-align: center;
}

.lista {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.ponto-item {
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  padding: 1rem;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 1rem;
}

.ponto-info h3 {
  color: #1b4332;
  font-size: 1.05rem;
  margin-bottom: 0.25rem;
}

.ponto-info p {
  font-size: 0.9rem;
  color: #4b5563;
  margin-bottom: 0.25rem;
}

.ponto-info small {
  color: #6b7280;
}

.tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.35rem;
  margin-top: 0.6rem;
}

.tag {
  background-color: #d8f3dc;
  color: #1b4332;
  font-size: 0.75rem;
  font-weight: 600;
  padding: 0.2rem 0.55rem;
  border-radius: 999px;
}

.btn-delete {
  background-color: #fee2e2;
  color: #b91c1c;
  border: none;
  padding: 0.4rem 0.7rem;
  border-radius: 6px;
  font-size: 0.85rem;
  font-weight: 600;
  cursor: pointer;
}

.btn-delete:hover {
  background-color: #fecaca;
}
</style>