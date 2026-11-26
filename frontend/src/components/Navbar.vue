<template>
  <header class="navbar">
    <div class="navbar-container">
      <RouterLink to="/" class="logo">
        ♻️ <span>EcoDescarte</span>
      </RouterLink>

      <nav class="nav-links">
        <RouterLink to="/">Início</RouterLink>
        <RouterLink to="/categorias">Categorias</RouterLink>
        <RouterLink to="/meus-descartes">Meus Descartes</RouterLink>
        <RouterLink to="/admin">Admin</RouterLink>
        <RouterLink to="/login" class="btn-login">Entrar</RouterLink>
      </nav>
    </div>
  </header>
</template>

<style scoped>
.navbar {
  background-color: #1b4332;
  color: #ffffff;
  padding: 1rem 1.5rem;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.12);
}

.navbar-container {
  max-width: 1100px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
}

.logo {
  font-size: 1.4rem;
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
  gap: 1.25rem;
  flex-wrap: wrap;
}

.nav-links a {
  color: #d8f3dc;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.2s;
}

.nav-links a:hover,
.nav-links a.router-link-active {
  color: #ffffff;
}

.btn-login {
  background-color: #40916c;
  color: #ffffff !important;
  padding: 0.45rem 1rem;
  border-radius: 6px;
}

.btn-login:hover {
  background-color: #52b788;
}
</style>