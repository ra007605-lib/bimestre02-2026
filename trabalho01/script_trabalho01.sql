-- A escolha do tema foi porque minha mãe trabalha com banho e tosa de cachorros e gatos e recentemente começou a trabalhar só em casa. 
-- Por isso acredito que um sistema de banco de dados seria interessante para facilitar a organização dos clientes, animais, serviços, agendamentos e pagamentos.

CREATE DATABASE banho_e_tosa;

CREATE TABLE cliente (
    idcliente INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    data_cadastro DATE DEFAULT CURRENT_DATE
);

CREATE TABLE animal (
    idanimal INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    especie VARCHAR(30) NOT NULL,
    raca VARCHAR(60),
    porte VARCHAR(20) NOT NULL,
    idade INT,
    idcliente INT NOT NULL,
    CONSTRAINT fk_animal_cliente
        FOREIGN KEY (idcliente)
        REFERENCES cliente(idcliente),
    CONSTRAINT chk_animal_porte
        CHECK (porte IN ('Pequeno', 'Medio', 'Grande')),
    CONSTRAINT chk_animal_idade
        CHECK (idade >= 0)
);

CREATE TABLE servico (
    idservico INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_servico VARCHAR(100) NOT NULL UNIQUE,
    descricao VARCHAR(200),
    valor NUMERIC(10,2) NOT NULL,
    duracao_minutos INT NOT NULL,
    CONSTRAINT chk_servico_valor
        CHECK (valor > 0),
    CONSTRAINT chk_servico_duracao
        CHECK (duracao_minutos > 0)
);


CREATE TABLE agendamento (
    idagendamento INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idanimal INT NOT NULL,
    idservico INT NOT NULL,
    data_agendamento DATE NOT NULL,
    horario TIME NOT NULL,
    status VARCHAR(20) DEFAULT 'Agendado',
    observacao VARCHAR(200),
    CONSTRAINT fk_agendamento_animal
        FOREIGN KEY (idanimal)
        REFERENCES animal(idanimal),
    CONSTRAINT fk_agendamento_servico
        FOREIGN KEY (idservico)
        REFERENCES servico(idservico),
    CONSTRAINT chk_agendamento_status
        CHECK (status IN ('Agendado', 'Concluido', 'Cancelado'))
);

CREATE TABLE pagamento (
    idpagamento INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idagendamento INT NOT NULL UNIQUE,
    valor_pago NUMERIC(10,2) NOT NULL,
    forma_pagamento VARCHAR(20) DEFAULT 'Pendente',
    data_pagamento DATE,
    CONSTRAINT fk_pagamento_agendamento
        FOREIGN KEY (idagendamento)
        REFERENCES agendamento(idagendamento),
    CONSTRAINT chk_pagamento_valor
        CHECK (valor_pago >= 0),
    CONSTRAINT chk_pagamento_forma
        CHECK (forma_pagamento IN ('Dinheiro', 'Pix', 'Cartao', 'Pendente')),
    CONSTRAINT chk_pagamento_data
        CHECK (
            (forma_pagamento = 'Pendente' AND data_pagamento IS NULL AND valor_pago = 0)
            OR
            (forma_pagamento <> 'Pendente' AND data_pagamento IS NOT NULL AND valor_pago > 0)
        )
);


-- INSERÇÃO DE DADOS PEGA VIA IA PRA FACILITAR

INSERT INTO cliente (nome, telefone, email) VALUES
('Ana Paula Souza', '35991111111', 'ana@email.com'),
('Carlos Henrique', '35992222222', 'carlos@email.com'),
('Mariana Oliveira', '35993333333', 'mariana@email.com'),
('Roberto Santos', '35994444444', 'roberto@email.com'),
('Juliana Costa', '35995555555', 'juliana@email.com'),
('Fernanda Lima', '35996666666', 'fernanda@email.com'),
('Pedro Almeida', '35997777777', 'pedro@email.com'),
('Camila Rodrigues', '35998888888', 'camila@email.com'),
('Lucas Ferreira', '35999999999', 'lucas@email.com'),
('Beatriz Martins', '35990000000', 'beatriz@email.com');

INSERT INTO animal (nome, especie, raca, porte, idade, idcliente) VALUES
('Mel', 'Cachorro', 'Shih-tzu', 'Pequeno', 3, 1),
('Thor', 'Cachorro', 'Labrador', 'Grande', 5, 2),
('Luna', 'Cachorro', 'Poodle', 'Pequeno', 2, 3),
('Nina', 'Gato', 'Persa', 'Pequeno', 4, 4),
('Bob', 'Cachorro', 'Golden Retriever', 'Grande', 6, 5),
('Mia', 'Gato', 'Siamês', 'Pequeno', 1, 6),
('Max', 'Cachorro', 'Pinscher', 'Pequeno', 7, 7),
('Amora', 'Cachorro', 'Yorkshire', 'Pequeno', 2, 8),
('Bidu', 'Cachorro', 'Border Collie', 'Medio', 4, 9),
('Lili', 'Cachorro', 'Spitz Alemão', 'Pequeno', 3, 10);

INSERT INTO servico (nome_servico, descricao, valor, duracao_minutos) VALUES
('Banho', 'Banho completo com shampoo e secagem', 40.00, 60),
('Tosa Completa', 'Tosa completa na máquina ou tesoura', 70.00, 90),
('Banho e Tosa', 'Banho completo acompanhado de tosa', 100.00, 120),
('Corte de Unhas', 'Corte e acabamento das unhas', 15.00, 15),
('Limpeza de Ouvidos', 'Higienização da região auricular', 20.00, 15),
('Hidratacao', 'Hidratação dos pelos do animal', 30.00, 30),
('Escovacao', 'Escovação e remoção de pelos soltos', 25.00, 30),
('Banho Medicinal', 'Banho com produto dermatológico específico', 60.00, 60),
('Tosa Higienica', 'Tosa das regiões íntimas e patas', 35.00, 30),
('Banho Premium', 'Banho com produtos especiais e perfume', 55.00, 75);

INSERT INTO agendamento (idanimal, idservico, data_agendamento, horario, status, observacao) VALUES
(1, 3, '2026-10-20', '09:00', 'Concluido', 'Animal tranquilo durante o atendimento'),
(2, 1, '2026-10-20', '10:00', 'Concluido', 'Utilizar shampoo neutro'),
(3, 2, '2026-10-21', '09:00', 'Concluido', 'Manter a tosa baixa'),
(4, 1, '2026-10-21', '14:00', 'Concluido', 'Animal com pelos longos'),
(5, 3, '2026-10-22', '09:00', 'Concluido', 'Realizar secagem completa'),
(6, 4, '2026-10-22', '14:00', 'Concluido', 'Animal tranquilo'),
(7, 10, '2026-10-23', '10:00', 'Concluido', 'Utilizar perfume suave'),
(8, 9, '2026-10-24', '09:00', 'Concluido', 'Tosa das patas e região higiênica'),
(9, 1, '2026-11-10', '09:00', 'Agendado', 'Cliente solicitou horário pela manhã'),
(10, 3, '2026-11-11', '14:00', 'Agendado', 'Primeiro atendimento do animal');

INSERT INTO pagamento (idagendamento, valor_pago, forma_pagamento, data_pagamento) VALUES
(1, 100.00, 'Pix', '2026-10-20'),
(2, 40.00, 'Dinheiro', '2026-10-20'),
(3, 70.00, 'Cartao', '2026-10-21'),
(4, 40.00, 'Pix', '2026-10-21'),
(5, 100.00, 'Dinheiro', '2026-10-22'),
(6, 15.00, 'Pix', '2026-10-22'),
(7, 55.00, 'Cartao', '2026-10-23'),
(8, 35.00, 'Dinheiro', '2026-10-24'),
(9, 0.00, 'Pendente', NULL),
(10, 0.00, 'Pendente', NULL);


-- CONSULTAS SQL

SELECT * FROM cliente;

SELECT * FROM animal;

SELECT * FROM servico ORDER BY valor;

SELECT * FROM agendamento WHERE status = 'Concluido';

SELECT
    cliente.nome AS cliente,
    animal.nome AS animal,
    servico.nome_servico AS servico,
    agendamento.data_agendamento,
    agendamento.horario,
    agendamento.status
FROM agendamento
INNER JOIN animal
    ON animal.idanimal = agendamento.idanimal
INNER JOIN cliente
    ON cliente.idcliente = animal.idcliente
INNER JOIN servico
    ON servico.idservico = agendamento.idservico;

SELECT
    cliente.nome AS cliente,
    animal.nome AS animal,
    pagamento.valor_pago,
    pagamento.forma_pagamento,
    pagamento.data_pagamento
FROM pagamento
INNER JOIN agendamento
    ON agendamento.idagendamento = pagamento.idagendamento
INNER JOIN animal
    ON animal.idanimal = agendamento.idanimal
INNER JOIN cliente
    ON cliente.idcliente = animal.idcliente;

SELECT
    cliente.nome AS cliente,
    COUNT(animal.idanimal) AS quantidade_animais
FROM cliente
LEFT JOIN animal
    ON animal.idcliente = cliente.idcliente
GROUP BY cliente.idcliente, cliente.nome
ORDER BY quantidade_animais DESC;

SELECT
    servico.nome_servico,
    COUNT(agendamento.idagendamento) AS quantidade_realizada
FROM servico
INNER JOIN agendamento
    ON agendamento.idservico = servico.idservico
WHERE agendamento.status = 'Concluido'
GROUP BY servico.idservico, servico.nome_servico
ORDER BY quantidade_realizada DESC;

SELECT
    forma_pagamento,
    SUM(valor_pago) AS total_recebido
FROM pagamento
WHERE forma_pagamento <> 'Pendente'
GROUP BY forma_pagamento;

SELECT
    cliente.nome AS cliente,
    animal.nome AS animal,
    servico.nome_servico AS servico,
    agendamento.data_agendamento,
    agendamento.horario
FROM agendamento
INNER JOIN animal
    ON animal.idanimal = agendamento.idanimal
INNER JOIN cliente
    ON cliente.idcliente = animal.idcliente
INNER JOIN servico
    ON servico.idservico = agendamento.idservico
WHERE agendamento.status = 'Agendado';
