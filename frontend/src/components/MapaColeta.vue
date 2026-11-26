<script setup>
import { onMounted, ref, watch } from 'vue'
import L from 'leaflet'

// Dados simulados (mocks) até o backend da Gisele estar pronto
const pontosMock = [
  {
    id: 1,
    nome: 'Ecoponto Centro Histórico',
    endereco: 'Av. Borges de Medeiros, 500 - Centro, Porto Alegre',
    horario: 'Seg a Sáb: 08h às 18h',
    materiais: ['Eletrônicos', 'Pilhas e Baterias', 'Vidro'],
    lat: -30.0318,
    lng: -51.2287
  },
  {
    id: 2,
    nome: 'Ponto Verde Moinhos',
    endereco: 'Rua Padre Chagas, 210 - Moinhos de Vento, Porto Alegre',
    horario: 'Seg a Sex: 09h às 19h',
    materiais: ['Plástico', 'Papel e Papelão', 'Óleo de Cozinha'],
    lat: -30.0256,
    lng: -51.2015
  },
  {
    id: 3,
    nome: 'Coleta Solidária Viamão',
    endereco: 'Av. Sen. Salgado Filho, 1200 - Centro, Viamão',
    horario: 'Seg a Sáb: 08h às 17h',
    materiais: ['Eletrônicos', 'Óleo de Cozinha', 'Plástico', 'Vidro'],
    lat: -30.0811,
    lng: -51.0233
  }
]

const categorias = [
  'Todos',
  'Eletrônicos',
  'Pilhas e Baterias',
  'Óleo de Cozinha',
  'Vidro',
  'Plástico',
  'Papel e Papelão'
]

const categoriaSelecionada = ref('Todos')
const mapaContainer = ref(null)
let mapa = null
let camadaMarcadores = null

function atualizarMarcadores() {
  if (!camadaMarcadores) return
  camadaMarcadores.clearLayers()

  const filtrados =
    categoriaSelecionada.value === 'Todos'
      ? pontosMock
      : pontosMock.filter((p) => p.materiais.includes(categoriaSelecionada.value))

  filtrados.forEach((ponto) => {
    const popupHtml = `
      <div style="min-width: 180px;">
        <strong style="color: #1b4332; font-size: 14px;">${ponto.nome}</strong><br/>
        <small>${ponto.endereco}</small><br/>
        <small>🕒 ${ponto.horario}</small><br/>
        <div style="margin-top: 6px; font-size: 12px;">
          <strong>Aceita:</strong> ${ponto.materiais.join(', ')}
        </div>
      </div>
    `
    L.marker([ponto.lat, ponto.lng]).addTo(camadaMarcadores).bindPopup(popupHtml)
  })
}

onMounted(() => {
  mapa = L.map(mapaContainer.value).setView([-30.045, -51.15], 11)

  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; OpenStreetMap contributors'
  }).addTo(mapa)

  camadaMarcadores = L.layerGroup().addTo(mapa)
  atualizarMarcadores()
})

watch(categoriaSelecionada, () => {
  atualizarMarcadores()
})
</script>

<template>
  <div id="mapa-secao" class="mapa-wrapper">
    <div class="mapa-header">
      <h2>Pontos de Coleta no Mapa</h2>
      <div class="filtro">
        <label for="filtro-categoria">Filtrar por resíduo:</label>
        <select id="filtro-categoria" v-model="categoriaSelecionada">
          <option v-for="cat in categorias" :key="cat" :value="cat">
            {{ cat }}
          </option>
        </select>
      </div>
    </div>

    <div ref="mapaContainer" class="mapa-box"></div>
  </div>
</template>

<style scoped>
.mapa-wrapper {
  margin-top: 2.5rem;
}

.mapa-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
  margin-bottom: 1rem;
}

.mapa-header h2 {
  color: #1b4332;
  font-size: 1.5rem;
}

.filtro {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.filtro select {
  padding: 0.45rem 0.75rem;
  border-radius: 6px;
  border: 1px solid #b7e4c7;
  background-color: #ffffff;
  color: #1b4332;
  font-weight: 500;
}

.mapa-box {
  width: 100%;
  height: 420px;
  border-radius: 12px;
  border: 2px solid #d8f3dc;
  z-index: 1;
}
</style>