<script setup>
import MapaColeta from '../components/MapaColeta.vue'

function irParaMapa() {
  const el = document.getElementById('mapa-secao')
  if (el) el.scrollIntoView({ behavior: 'smooth' })
}
</script>

<template>
  <section class="home">
    <div class="hero">
      <h1>Descarte consciente, destino correto.</h1>
      <p>
        Encontre pontos de coleta próximos a você, descubra como separar cada tipo de
        resíduo e acompanhe seu histórico de descartes.
      </p>
      <div class="hero-actions">
        <button class="btn-primary" @click="irParaMapa">Ver Mapa de Coleta</button>
        <RouterLink to="/categorias" class="btn-secondary">Guia de Resíduos</RouterLink>
      </div>
    </div>

    <MapaColeta />
  </section>
</template>

<style scoped>
.home {
  max-width: 1100px;
  margin: 0 auto;
  padding: 2.5rem 1.5rem;
}

.hero {
  background: linear-gradient(135deg, #d8f3dc, #b7e4c7);
  border-radius: 14px;
  padding: 3rem 2rem;
  text-align: center;
  color: #1b4332;
}

.hero h1 {
  font-size: 2.2rem;
  margin-bottom: 1rem;
}

.hero p {
  max-width: 650px;
  margin: 0 auto 2rem;
  font-size: 1.05rem;
  line-height: 1.6;
  color: #2d6a4f;
}

.hero-actions {
  display: flex;
  justify-content: center;
  gap: 1rem;
  flex-wrap: wrap;
}

.btn-primary,
.btn-secondary {
  padding: 0.75rem 1.4rem;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  border: none;
  font-size: 1rem;
  text-decoration: none;
  display: inline-block;
}

.btn-primary {
  background-color: #2d6a4f;
  color: #ffffff;
}

.btn-primary:hover {
  background-color: #1b4332;
}

.btn-secondary {
  background-color: #ffffff;
  color: #1b4332;
  border: 1px solid #2d6a4f;
}

.btn-secondary:hover {
  background-color: #f0fdf4;
}
</style>