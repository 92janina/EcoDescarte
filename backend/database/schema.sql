CREATE DATABASE IF NOT EXISTS ecodescarte
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE ecodescarte;

-- 1. Tabela de Usuários (Cidadãos e Administradores)
CREATE TABLE IF NOT EXISTS usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  senha_hash VARCHAR(255) NOT NULL,
  perfil ENUM('cidadao', 'admin') NOT NULL DEFAULT 'cidadao',
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabela de Categorias de Resíduos e Orientações
CREATE TABLE IF NOT EXISTS categorias_residuos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL UNIQUE,
  descricao TEXT NOT NULL,
  orientacao_descarte TEXT NOT NULL,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Tabela de Pontos de Coleta
CREATE TABLE IF NOT EXISTS pontos_coleta (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  cep VARCHAR(9) NOT NULL,
  logradouro VARCHAR(150) NOT NULL,
  numero VARCHAR(20) NOT NULL,
  complemento VARCHAR(100),
  bairro VARCHAR(100) NOT NULL,
  cidade VARCHAR(100) NOT NULL,
  uf CHAR(2) NOT NULL,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  horario_funcionamento VARCHAR(120),
  telefone VARCHAR(20),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Tabela Intermediária (N:N) - Quais materiais cada ponto aceita
CREATE TABLE IF NOT EXISTS ponto_materiais (
  ponto_id INT NOT NULL,
  categoria_id INT NOT NULL,
  PRIMARY KEY (ponto_id, categoria_id),
  CONSTRAINT fk_pm_ponto
    FOREIGN KEY (ponto_id) REFERENCES pontos_coleta(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_pm_categoria
    FOREIGN KEY (categoria_id) REFERENCES categorias_residuos(id)
    ON DELETE CASCADE
);

-- 5. Tabela de Registros de Descarte (Histórico do Usuário + Indicadores)
CREATE TABLE IF NOT EXISTS registros_descarte (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  ponto_id INT NOT NULL,
  categoria_id INT NOT NULL,
  quantidade_estimada VARCHAR(60) NOT NULL,
  data_descarte DATE NOT NULL,
  observacao TEXT,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_rd_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_rd_ponto
    FOREIGN KEY (ponto_id) REFERENCES pontos_coleta(id)
    ON DELETE RESTRICT,
  CONSTRAINT fk_rd_categoria
    FOREIGN KEY (categoria_id) REFERENCES categorias_residuos(id)
    ON DELETE RESTRICT
);

-- ==========================================================
-- Dados iniciais (Seed) de Categorias de Resíduos
-- ==========================================================
INSERT IGNORE INTO categorias_residuos (nome, descricao, orientacao_descarte) VALUES
(
  'Eletrônicos',
  'Celulares, computadores, cabos, carregadores, teclados e pequenos eletrodomésticos.',
  'Apague dados pessoais antes do descarte, remova baterias soltas se possível e entregue em pontos de coleta de lixo eletrônico.'
),
(
  'Pilhas e Baterias',
  'Pilhas comuns, alcalinas, recarregáveis e baterias de celulares ou notebooks.',
  'Nunca descarte no lixo comum. Armazene em local seco e leve a pontos de coleta específicos para evitar contaminação do solo.'
),
(
  'Óleo de Cozinha',
  'Óleo vegetal usado em frituras e preparo de alimentos.',
  'Espere o óleo esfriar completamente, coe os resíduos sólidos e armazene em uma garrafa PET bem fechada antes de levar ao ponto de coleta.'
),
(
  'Vidro',
  'Garrafas, potes de conserva e frascos de vidro.',
  'Lave e seque os recipientes. Se o vidro estiver quebrado, embrulhe bem em papelão ou jornal e identifique o pacote para segurança dos coletores.'
),
(
  'Plástico',
  'Garrafas PET, embalagens de limpeza, potes e sacolas plásticas.',
  'Esvazie e faça uma lavagem rápida para retirar restos de alimentos ou produtos. Amasse as garrafas para reduzir o volume.'
),
(
  'Papel e Papelão',
  'Caixas, jornais, revistas, cadernos e folhas de papel.',
  'Mantenha os papéis secos e limpos (sem gordura). Desmonte as caixas de papelão para facilitar o transporte e armazenamento.'
);