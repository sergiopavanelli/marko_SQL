CREATE DATABASE marko;
USE marko;

-- Tabela usuario
CREATE TABLE usuario (
    idUsuario INT NOT NULL,
    senha VARCHAR(45) NULL,
    nomeUsuario VARCHAR(45) NULL,
    sexo VARCHAR(45) NULL,
    dataCadastro DATETIME NULL,
    endereco VARCHAR(45) NULL,
    email VARCHAR(45) NULL,
    PRIMARY KEY (idUsuario)
);

-- Tabela promotor
CREATE TABLE promotor (
    cnpj VARCHAR(20) NOT NULL,
    cargo VARCHAR(45) NULL,
    informacoesRelatorio VARCHAR(45) NULL,
    Usuario_idUsuario INT NOT NULL,
    PRIMARY KEY (cnpj),
    INDEX fk_promotor_Usuario1_idx (Usuario_idUsuario ASC),
    CONSTRAINT fk_promotor_Usuario1
      FOREIGN KEY (Usuario_idUsuario)
      REFERENCES usuario (idUsuario)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

-- Tabela produtor_geral
CREATE TABLE produtor_geral (
    cnpj VARCHAR(20) NOT NULL,
    cargo VARCHAR(45) NULL,
    informacoesRelatorio VARCHAR(45) NULL,
    Usuario_idUsuario INT NOT NULL,
    PRIMARY KEY (cnpj),
    INDEX fk_produtor_geral_Usuario1_idx (Usuario_idUsuario ASC),
    CONSTRAINT fk_produtor_geral_Usuario1
      FOREIGN KEY (Usuario_idUsuario)
      REFERENCES usuario (idUsuario)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

-- Tabela cliente
CREATE TABLE cliente (
    cpf VARCHAR(20) NOT NULL,
    saldoConta FLOAT NULL,
    Usuario_idUsuario INT NOT NULL,
    nomeCliente VARCHAR(45) NULL,
    PRIMARY KEY (cpf),
    INDEX fk_cliente_Usuario_idx (Usuario_idUsuario ASC),
    CONSTRAINT fk_cliente_Usuario
      FOREIGN KEY (Usuario_idUsuario)
      REFERENCES usuario (idUsuario)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

-- Tabela relatorio_evento
CREATE TABLE relatorio_evento (
	idRelatorio INT NOT NULL,
    quantIngressos INT NOT NULL,
    valorTotalCompra FLOAT NULL,
    numeroOcorrencias DATETIME NULL,
    pulseirasAtivas FLOAT NULL,
    pulseirasDevolvidas VARCHAR(45) NULL,
    totalFuncionarios INT NULL,
    produtor_geral_cnpj VARCHAR(20) NOT NULL, 
    promotor_cnpj VARCHAR(20) NOT NULL,
    PRIMARY KEY (idRelatorio),
    INDEX fk_relatorio_evento_produtor_geral1_idx (produtor_geral_cnpj ASC), 
    INDEX fk_relatorio_evento_promotor1_idx (promotor_cnpj ASC), 
    CONSTRAINT fk_relatorio_evento_produtor_geral1 
      FOREIGN KEY (produtor_geral_cnpj)
      REFERENCES produtor_geral (cnpj) 
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
    CONSTRAINT fk_relatorio_evento_promotor1 
      FOREIGN KEY (promotor_cnpj)
      REFERENCES promotor (cnpj)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

-- Tabela evento
CREATE TABLE evento (
    idEvento INT NOT NULL,
    nomeEvento VARCHAR(45) NULL,
    dataEvento DATETIME NULL,
    eventocol VARCHAR(45) NULL,
    idUsuario INT NULL,
    cliente_cpf VARCHAR(20) NOT NULL,
    promotor_cnpj VARCHAR(20) NOT NULL,
    produtor_geral_cnpj VARCHAR(20) NOT NULL,
    PRIMARY KEY (idEvento),
    INDEX fk_evento_cliente1_idx (cliente_cpf ASC),
    INDEX fk_evento_promotor1_idx (promotor_cnpj ASC),
    INDEX fk_evento_produtor_geral1_idx (produtor_geral_cnpj ASC),
    CONSTRAINT fk_evento_cliente
      FOREIGN KEY (cliente_cpf)
      REFERENCES cliente (cpf)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
    CONSTRAINT fk_evento_promotor1
      FOREIGN KEY (promotor_cnpj)
      REFERENCES promotor (cnpj)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
    CONSTRAINT fk_evento_produtor_geral1
      FOREIGN KEY (produtor_geral_cnpj)
      REFERENCES produtor_geral (cnpj)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

-- As cláusulas ON DELETE NO ACTION e ON UPDATE NO ACTION são mecanismos para manter a integridade referencial
-- do banco de dados, impedindo que alterações em uma tabela pai afetem negativamente as tabelas filhas que dependem dela.

-- Tabela pagamento
CREATE TABLE pagamento (
	idPagamento INT NOT NULL,
    idIngresso INT NOT NULL,
    dataValidade DATETIME NULL,
    CVV VARCHAR(45) NULL,
    nomeCartao VARCHAR(45) NULL,
    CPF VARCHAR(20) NULL,
    email VARCHAR(45) NULL,
    PRIMARY KEY (idPagamento)
);

-- Tabela ingresso
CREATE TABLE ingresso (
    idIngresso INT NOT NULL,
    dataPedido DATETIME NULL,
    valorPedido FLOAT NULL,
    pagamento_idIngresso INT NOT NULL,
    PRIMARY KEY (idIngresso),
    INDEX fk_Ingresso_pagamento1_idx (pagamento_idIngresso ASC),
    CONSTRAINT fk_Ingresso_pagamento1
      FOREIGN KEY (pagamento_idIngresso)
      REFERENCES pagamento (idPagamento)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

-- Tabela ingresso_has_evento
CREATE TABLE ingresso_has_evento (
    ingresso_idIngresso INT NOT NULL,
    evento_idEvento INT NOT NULL,
    PRIMARY KEY (ingresso_idIngresso, evento_idEvento),
    INDEX fk_ingresso_has_evento_evento1_idx (evento_idEvento ASC),
    INDEX fk_Ingresso_has_evento_Ingresso1_idx (ingresso_idIngresso ASC),
    CONSTRAINT fk_ingresso_has_evento_Ingresso1
      FOREIGN KEY (ingresso_idIngresso)
      REFERENCES ingresso (idIngresso)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
    CONSTRAINT fk_ingresso_has_evento_evento1
      FOREIGN KEY (evento_idEvento)
      REFERENCES evento (idEvento)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

-- Inserir dados na tabela usuario
INSERT INTO usuario (idUsuario, senha, nomeUsuario, sexo, dataCadastro, endereco, email) VALUES 
(1, 'senha123', 'usuario1', 'M', '2023-01-01 12:00:00', 'Endereço 1', 'usuario1@example.com'),
(2, 'senha456', 'usuario2', 'F', '2023-02-01 12:00:00', 'Endereço 2', 'usuario2@example.com');

SELECT * from usuario;

-- Inserir dados na tabela promotor
INSERT INTO promotor (cnpj, cargo, informacoesRelatorio, Usuario_idUsuario) VALUES 
('12345678901234', 'Promotor de Eventos', 'Responsável pela organização do evento X', 1),
('98765432109876', 'Promotor Assistente', 'Auxilia na logística dos eventos', 2);

SELECT * from promotor;

-- Inserir dados na tabela produtor_geral
INSERT INTO produtor_geral (cnpj, cargo, informacoesRelatorio, Usuario_idUsuario) VALUES 
('45678901234567', 'Produtor Geral', 'Coordena todas as atividades do evento', 1),
('32165498765432', 'Produtor Assistente', 'Apoia na produção geral dos eventos', 2);

SELECT * from produtor_geral;

-- Inserir dados na tabela cliente
INSERT INTO cliente (cpf, saldoConta, Usuario_idUsuario, nomeCliente) VALUES 
('04188487660', 1000.00, 1, 'Cliente A'),
('98765432100', 500.00, 2, 'Cliente B');

SELECT * from cliente;

-- Inserir dados na tabela evento
INSERT INTO evento (idEvento, nomeEvento, dataEvento, cliente_cpf, promotor_cnpj, produtor_geral_cnpj) VALUES 
(1, 'Evento X', '2024-06-20 19:00:00', '04188487660', '12345678901234', '45678901234567'),
(2, 'Evento Y', '2024-07-15 20:00:00', '98765432100', '98765432109876', '32165498765432');

-- Inserir dados na tabela relatorio_evento
INSERT INTO relatorio_evento (quantIngressos, valorTotalCompra, numeroOcorrencias, pulseirasAtivas, pulseirasDevolvidas, totalFuncionarios, produtor_geral_cnpj, promotor_cnpj) VALUES 
(100, 5000.00, '2024-06-10 18:00:00', 80, '20', 10, '45678901234567', '12345678901234'),
(50, 2500.00, '2024-06-11 12:00:00', 40, '10', 5, '32165498765432', '98765432109876');

-- Inserir dados na tabela pagamento
INSERT INTO pagamento (idIngresso, dataValidade, CVV, nomeCartao, CPF, email) VALUES 
(1, '2024-12-31 23:59:59', '123', 'Cartao1', '04188487660', 'clientea@example.com'),
(2, '2024-12-31 23:59:59', '456', 'Cartao2', '98765432100', 'clienteb@example.com');

-- Inserir dados na tabela ingresso
INSERT INTO ingresso (idIngresso, dataPedido, valorPedido, pagamento_idIngresso) VALUES 
(1, '2024-06-01 10:00:00', 100.00, 1),
(2, '2024-06-02 11:00:00', 150.00, 2);

-- Inserir dados na tabela ingresso_has_evento
INSERT INTO ingresso_has_evento (ingresso_idIngresso, evento_idEvento) VALUES 
(1, 1),
(2, 2);

SELECT * FROM usuario;
SELECT * FROM promotor;
SELECT * FROM produtor_geral;
SELECT * FROM cliente;
SELECT * FROM evento;
SELECT * FROM relatorio_evento;
SELECT * FROM pagamento;
SELECT * FROM ingresso;
SELECT * FROM ingresso_has_evento;


-- Exemplos de comandos ALTER TABLE, DELETE, UPDATE, DROP

UPDATE evento
SET nomeEvento = 'Novo Evento X', dataEvento = '2024-06-25 20:30:00'
WHERE idEvento = 1;

ALTER TABLE evento ADD COLUMN descricaoEvento VARCHAR(255);

-- 1. Excluir referências na tabela ingresso_has_evento
DELETE FROM ingresso_has_evento WHERE ingresso_idIngresso = 1;
-- 2. Excluir registros na tabela ingresso
DELETE FROM ingresso WHERE idIngresso = 1;
-- 3. Excluir o registro na tabela pagamento
DELETE FROM pagamento WHERE idIngresso = 1;

-- DROP
ALTER TABLE evento DROP COLUMN eventocol;

-- TRUNCATE: Em nosso script não foi possível utilizar o comando TRUNCATE, devido às dependências de chave estrangeira existentes. 
-- Portanto, foi utilizado o comando DELETE para remover os registros de tabelas, garantindo que os registros relacionados em outras tabelas fossem tratados adequadamente antes de deletar.
