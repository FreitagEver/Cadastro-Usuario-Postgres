#Criar banco de dados
CREATE DATABASE Cadastro-usuarios;

#Criar tabela 
CREATE TABLE IF NOT EXISTS usuario(
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  email VARCHAR(255) NOT NULL,
  senha VARCHAR(64) NOT NULL,
  data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_usuario_email UNIQUE (email)
  );

  CREATE INDEX IF NOT EXISTS idx_usuario_nome ON usuario (nome);

  INSERT INTO usuario (nome, email, senha)
  VALUES ('Administrador', 'admin@teste.com', '21232f297a57a5a743894a0e4a801fc3')
  ON CONFLICT (email) DO NOTHING;
