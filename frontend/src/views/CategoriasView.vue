<script setup>
import { ref, computed } from 'vue'

const busca = ref('')

const categorias = [
  {
    id: 1,
    nome: 'Eletrônicos',
    icone: '💻',
    cor: '#e0f2fe',
    borda: '#0284c7',
    descricao: 'Celulares, carregadores, computadores, cabos e pequenos eletrodomésticos.',
    dica: 'Apague seus dados pessoais antes de descartar e nunca jogue no lixo comum.'
  },
  {
    id: 2,
    nome: 'Pilhas e Baterias',
    icone: '🔋',
    cor: '#fef3c7',
    borda: '#d97706',
    descricao: 'Pilhas alcalinas, baterias de celular, notebook e baterias recarregáveis.',
    dica: 'Isole os polos com fita adesiva para evitar curto-circuito e vazamento de metais pesados.'
  },
  {
    id: 3,
    nome: 'Óleo de Cozinha',
    icone: '🛢️',
    cor: '#ffedd5',
    borda: '#ea580c',
    descricao: 'Óleo vegetal usado em frituras (soja, girassol, canola, azeite).',
    dica: 'Espere esfriar, coe e armazene em garrafa PET bem fechada antes de levar ao ponto de coleta.'
  },
  {
    id: 4,
    nome: 'Vidro',
    icone: '🍾',
    cor: '#dcfce7',
    borda: '#16a34a',
    descricao: 'Garrafas, potes de conserva e frascos de vidro limpos.',
    dica: 'Lave os potes para retirar restos de alimento. Se estiver quebrado, embrulhe em papelão ou jornal.'
  },
  {
    id: 5,
    nome: 'Plástico',
    icone: '♻️',
    cor: '#fee2e2',
    borda: '#dc2626',
    descricao: 'Garrafas PET, embalagens de produtos de limpeza, potes e sacolas.',
    dica: 'Faça uma limpeza rápida para tirar excessos de comida e amasse as garrafas para reduzir volume.'
  },
  {
    id: 6,
    nome: 'Papel e Papelão',
    icone: '📦',
    cor: '#dbeafe',
    borda: '#2563eb',
    descricao: 'Caixas de papelão, jornais, revistas, cadernos e folhas de escritório.',
    dica: 'Mantenha o papel seco e sem gordura (caixas de pizza engorduradas não vão para a reciclagem).'
  }
]

const categoriasFiltradas = computed(() => {
  if (!busca.value.trim()) return categorias
  const termo = busca.value.toLowerCase()
  return categorias.filter(
    (c) =>
      c.nome.toLowerCase().includes(termo) ||
      c.descricao.toLowerCase().includes(termo)
  )
})
</script>

<template>
  <section class="categorias-page">
    <div class="header">
      <h1>Guia de Resíduos</h1>
      <p>Saiba como separar e preparar cada material antes de levar a um ponto de coleta.</p>

      <input
        v-model="busca"
        type="text"
        class="input-busca"
        placeholder="Buscar resíduo (ex: óleo, pilha, vidro)..."
      />
    </div>

    <div class="grid">
      <article
        v-for="cat in categoriasFiltradas"
        :key="cat.id"
        class="card"
        :style="{ borderTop: `5px solid ${cat.borda}` }"
      >
        <div class="card-top">
          <span class="icone" :style="{ backgroundColor: cat.cor }">{{ cat.icone }}</span>
          <h2>{{ cat.nome }}</h2>
        </div>

        <p class="descricao">{{ cat.descricao }}</p>

        <div class="dica">
          <strong>Como descartar:</strong> {{ cat.dica }}
        </div>
      </article>
    </div>

    <p v-if="categoriasFiltradas.length === 0" class="vazio">
      Nenhuma categoria encontrada para "{{ busca }}".
    </p>
  </section>
</template>

<style scoped>
.categorias-page {
  max-width: 1100px;
  margin: 0 auto;
  padding: 2.5rem 1.5rem;
}

.header {
  text-align: center;
  margin-bottom: 2.5rem;
}

.header h1 {
  color: #1b4332;
  font-size: 2rem;
  margin-bottom: 0.5rem;
}

.header p {
  color: #4b5563;
  margin-bottom: 1.5rem;
}

.input-busca {
  width: 100%;
  max-width: 460px;
  padding: 0.75rem 1rem;
  border-radius: 8px;
  border: 1px solid #b7e4c7;
  font-size: 1rem;
  outline: none;
}

.input-busca:focus {
  border-color: #2d6a4f;
}

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(290px, 1fr));
  gap: 1.5rem;
}

.card {
  background: #ffffff;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.card-top {
  display: flex;
  align-items: center;
  gap: 0.85rem;
}

.icone {
  font-size: 1.6rem;
  width: 48px;
  height: 48px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.card-top h2 {
  color: #1b4332;
  font-size: 1.25rem;
}

.descricao {
  color: #374151;
  line-height: 1.5;
  font-size: 0.95rem;
}

.dica {
  background-color: #f0fdf4;
  color: #1b4332;
  padding: 0.85rem;
  border-radius: 8px;
  font-size: 0.9rem;
  line-height: 1.45;
  margin-top: auto;
}

.vazio {
  text-align: center;
  color: #6b7280;
  margin-top: 2rem;
}
</style>