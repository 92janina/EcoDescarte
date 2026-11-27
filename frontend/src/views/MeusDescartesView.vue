<script setup>
import { ref, computed, onMounted } from 'vue'

const categorias = [
  'Eletrônicos',
  'Pilhas e Baterias',
  'Óleo de Cozinha',
  'Vidro',
  'Plástico',
  'Papel e Papelão'
]

const pontosColeta = [
  'Ecoponto Centro Histórico - Porto Alegre/RS',
  'Coleta Solidária Viamão - Viamão/RS',
  'Ecoponto Zona Sul - Porto Alegre/RS',
  'Ponto Verde Bairro Santa Isabel - Viamão/RS'
]

const descartesIniciais = [
  {
    id: 1,
    categoria: 'Óleo de Cozinha',
    ponto: 'Coleta Solidária Viamão - Viamão/RS',
    quantidade: '2 litros (garrafa PET)',
    data: '2026-11-20',
    observacao: 'Óleo coado e bem fechado'
  },
  {
    id: 2,
    categoria: 'Pilhas e Baterias',
    ponto: 'Ecoponto Centro Histórico - Porto Alegre/RS',
    quantidade: '8 pilhas AA',
    data: '2026-11-24',
    observacao: 'Polos isolados com fita'
  }
]

const descartes = ref([])
const mensagemSucesso = ref('')

const form = ref({
  categoria: '',
  ponto: '',
  quantidade: '',
  data: new Date().toISOString().split('T')[0],
  observacao: ''
})

onMounted(() => {
  const salvos = localStorage.getItem('ecodescarte_historico')
  if (salvos) {
    descartes.value = JSON.parse(salvos)
  } else {
    descartes.value = descartesIniciais
    localStorage.setItem('ecodescarte_historico', JSON.stringify(descartesIniciais))
  }
})

function salvarNoStorage() {
  localStorage.setItem('ecodescarte_historico', JSON.stringify(descartes.value))
}

function registrarDescarte() {
  if (!form.value.categoria || !form.value.ponto || !form.value.quantidade.trim()) {
    alert('Preencha a categoria, o ponto de coleta e a quantidade.')
    return
  }

  const novoRegistro = {
    id: Date.now(),
    categoria: form.value.categoria,
    ponto: form.value.ponto,
    quantidade: form.value.quantidade.trim(),
    data: form.value.data,
    observacao: form.value.observacao.trim()
  }

  descartes.value.unshift(novoRegistro)
  salvarNoStorage()

  form.value = {
    categoria: '',
    ponto: '',
    quantidade: '',
    data: new Date().toISOString().split('T')[0],
    observacao: ''
  }

  mensagemSucesso.value = 'Descarte registrado com sucesso!'
  setTimeout(() => {
    mensagemSucesso.value = ''
  }, 3000)
}

function excluirDescarte(id) {
  descartes.value = descartes.value.filter((item) => item.id !== id)
  salvarNoStorage()
}

function formatarData(dataIso) {
  if (!dataIso) return ''
  const [ano, mes, dia] = dataIso.split('-')
  return `${dia}/${mes}/${ano}`
}

const totalDescartes = computed(() => descartes.value.length)

const categoriasDiferentes = computed(() => {
  return new Set(descartes.value.map((d) => d.categoria)).size
})

const pontosVisitados = computed(() => {
  return new Set(descartes.value.map((d) => d.ponto)).size
})
</script>

<template>
  <section class="descartes-page">
    <div class="header">
      <h1>Meus Descartes</h1>
      <p>Registre seus descartes conscientes e acompanhe seu histórico de impacto ambiental.</p>
    </div>

    <!-- Indicadores rápidos -->
    <div class="stats-grid">
      <div class="stat-card">
        <span class="stat-number">{{ totalDescartes }}</span>
        <span class="stat-label">Descartes Realizados</span>
      </div>
      <div class="stat-card">
        <span class="stat-number">{{ categoriasDiferentes }}</span>
        <span class="stat-label">Tipos de Materiais</span>
      </div>
      <div class="stat-card">
        <span class="stat-number">{{ pontosVisitados }}</span>
        <span class="stat-label">Pontos Utilizados</span>
      </div>
    </div>

    <div class="content-grid">
      <!-- Formulário de Novo Registro -->
      <form class="card form-card" @submit.prevent="registrarDescarte">
        <h2>Registrar Novo Descarte</h2>

        <div class="field">
          <label>Tipo de Material *</label>
          <select v-model="form.categoria" required>
            <option value="" disabled>Selecione uma categoria</option>
            <option v-for="cat in categorias" :key="cat" :value="cat">
              {{ cat }}
            </option>
          </select>
        </div>

        <div class="field">
          <label>Ponto de Coleta *</label>
          <select v-model="form.ponto" required>
            <option value="" disabled>Selecione o local do descarte</option>
            <option v-for="p in pontosColeta" :key="p" :value="p">
              {{ p }}
            </option>
          </select>
        </div>

        <div class="field-row">
          <div class="field">
            <label>Quantidade / Descrição *</label>
            <input
              v-model="form.quantidade"
              type="text"
              placeholder="Ex: 2 litros, 3 kg, 1 celular"
              required
            />
          </div>

          <div class="field date-field">
            <label>Data *</label>
            <input v-model="form.data" type="date" required />
          </div>
        </div>

        <div class="field">
          <label>Observação (opcional)</label>
          <input
            v-model="form.observacao"
            type="text"
            placeholder="Ex: Material limpo e separado"
          />
        </div>

        <p v-if="mensagemSucesso" class="sucesso">{{ mensagemSucesso }}</p>

        <button type="submit" class="btn-submit">Salvar Registro</button>
      </form>

      <!-- Histórico -->
      <div class="card history-card">
        <h2>Histórico de Descartes</h2>

        <p v-if="descartes.length === 0" class="vazio">
          Você ainda não registrou nenhum descarte. Comece usando o formulário ao lado!
        </p>

        <div v-else class="lista">
          <article v-for="item in descartes" :key="item.id" class="registro-item">
            <div class="registro-info">
              <div class="registro-topo">
                <span class="tag">{{ item.categoria }}</span>
                <span class="data">📅 {{ formatarData(item.data) }}</span>
              </div>
              <h3>{{ item.quantidade }}</h3>
              <p class="ponto">📍 {{ item.ponto }}</p>
              <small v-if="item.observacao" class="obs">{{ item.observacao }}</small>
            </div>

            <button
              class="btn-delete"
              @click="excluirDescarte(item.id)"
              title="Remover registro"
            >
              Excluir
            </button>
          </article>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.descartes-page {
  max-width: 1100px;
  margin: 0 auto;
  padding: 2.5rem 1.5rem;
}

.header {
  margin-bottom: 1.75rem;
}

.header h1 {
  color: #1b4332;
  font-size: 2rem;
}

.header p {
  color: #4b5563;
  margin-top: 0.35rem;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.25rem;
  margin-bottom: 2rem;
}

@media (max-width: 700px) {
  .stats-grid {
    grid-template-columns: 1fr;
  }
}

.stat-card {
  background: #ffffff;
  border-radius: 12px;
  padding: 1.25rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  border-left: 5px solid #2d6a4f;
  display: flex;
  flex-direction: column;
}

.stat-number {
  font-size: 2rem;
  font-weight: 700;
  color: #1b4332;
}

.stat-label {
  font-size: 0.9rem;
  color: #4b5563;
  margin-top: 0.2rem;
}

.content-grid {
  display: grid;
  grid-template-columns: 1fr 1.15fr;
  gap: 2rem;
  align-items: start;
}

@media (max-width: 850px) {
  .content-grid {
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

.field input,
.field select {
  padding: 0.65rem 0.8rem;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  font-size: 0.95rem;
  background-color: #ffffff;
}

.field input:focus,
.field select:focus {
  outline: none;
  border-color: #2d6a4f;
}

.field-row {
  display: flex;
  gap: 0.75rem;
}

.date-field {
  max-width: 165px;
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
  margin-top: 0.4rem;
}

.btn-submit:hover {
  background-color: #2d6a4f;
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

.vazio {
  color: #6b7280;
  font-size: 0.95rem;
  padding: 1rem 0;
}

.lista {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.registro-item {
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  padding: 1rem;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 1rem;
}

.registro-topo {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.45rem;
}

.tag {
  background-color: #d8f3dc;
  color: #1b4332;
  font-size: 0.78rem;
  font-weight: 600;
  padding: 0.2rem 0.6rem;
  border-radius: 999px;
}

.data {
  font-size: 0.82rem;
  color: #6b7280;
}

.registro-info h3 {
  color: #1f2937;
  font-size: 1.05rem;
  margin-bottom: 0.25rem;
}

.ponto {
  font-size: 0.9rem;
  color: #4b5563;
}

.obs {
  display: block;
  margin-top: 0.3rem;
  color: #6b7280;
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