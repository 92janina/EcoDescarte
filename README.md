# ♻️ EcoDescarte

> **Descarte consciente, destino correto.**

Plataforma web Full Stack desenvolvida como Projeto Final da disciplina de **Programação Full Stack**, voltada à conscientização ambiental e à facilitação do descarte correto de resíduos.

---

## 📋 Descrição do Projeto

O **EcoDescarte** centraliza informações sobre diferentes categorias de resíduos, apresenta orientações sobre sua destinação adequada e permite que cidadãos encontrem pontos de coleta compatíveis com os materiais que desejam descartar.

Além da consulta e visualização em mapa interativo, a plataforma permite o registro dos descartes realizados pelos usuários, gerando um histórico pessoal e indicadores administrativos de conscientização ambiental.

### ✨ Funcionalidades Principais
- Cadastro e autenticação de usuários (perfis **Cidadão** e **Administrador**).
- Consulta de categorias de resíduos e orientações para descarte adequado.
- Gerenciamento completo (CRUD) de pontos de coleta e materiais aceitos (área administrativa).
- Preenchimento automático de endereços via integração com a API **ViaCEP**.
- Pesquisa de pontos de coleta por tipo de resíduo e localização.
- Visualização dos pontos de coleta em mapa interativo.
- Registro e acompanhamento do histórico de descartes realizados.
- Dashboard administrativo com indicadores de utilização da plataforma.

---

## 🛠️ Tecnologias Utilizadas

- **Frontend:** Vue.js, Vue Router, Axios
- **Mapas:** Leaflet + OpenStreetMap
- **Backend:** Node.js, Express
- **Banco de Dados:** MySQL
- **Autenticação e Segurança:** JWT (JSON Web Token) e bcrypt
- **API Externa:** ViaCEP
- **Versionamento:** Git e GitHub

---

## 🚀 Instruções para Execução

### Pré-requisitos
Antes de começar, certifique-se de ter instalado em sua máquina:
- [Node.js](https://nodejs.org/) (v18 ou superior)
- [MySQL](https://www.mysql.com/)
- [Git](https://git-scm.com/)

### 1. Clonar o repositório
```bash
git clone https://github.com/92janina/EcoDescarte.git
cd EcoDescarte
```
### 2. Configurar o Banco de Dados
1. Crie o banco de dados no MySQL (ex: `ecodescarte`).
2. Execute o script SQL localizado em `backend/database/schema.sql` para criar as tabelas iniciais.

### 3. Executar o Backend
```bash
cd backend
npm install
```
Crie um arquivo `.env` na pasta `backend` com base no `.env.example`:
```env
PORT=3000
DB_HOST=localhost
DB_USER=seu_usuario
DB_PASSWORD=sua_senha
DB_NAME=ecodescarte
JWT_SECRET=sua_chave_secreta
```
Inicie o servidor:
```bash
npm run dev
```

### 4. Executar o Frontend
Em outro terminal, acesse a pasta do frontend:
```bash
cd frontend
npm install
npm run dev
```
Acesse a aplicação no navegador pelo endereço exibido no terminal (geralmente `http://localhost:5173`).

---

## 🌐 Aplicação Publicada (Deploy)
- **Frontend:** *(em breve)*
- **Backend / API:** *(em breve)*

---

## 👩‍💻 Integrantes da Dupla

- **Janina Siqueira** — [@92janina](https://github.com/92janina)
- **Gisele de Araújo** — [@giseleac](https://github.com/giseleac)
