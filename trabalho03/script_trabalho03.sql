-- QUESTÃO 1 - PRECEDÊNCIA LÓGICA COM PARÊNTESES [AND, OR]

-- Consulta os agendamentos com status Concluido ou Agendado, desde que tenham sido realizados a partir de 10/11/2026.
-- Os parênteses garantem que a condição de data seja aplicada aos dois status.
-- Sem os parênteses, todos os agendamentos Concluidos seriam exibidos, independentemente da data.

SELECT
    idagendamento,
    data_agendamento,
    horario,
    status
FROM agendamento
WHERE
    (status = 'Concluido' OR status = 'Agendado')
    AND data_agendamento >= '2026-11-10';



-- QUESTÃO 2 - NEGAÇÃO E VERIFICAÇÃO DE NULOS [NOT, IS NOT NULL]

-- Consulta os clientes que possuem e-mail cadastrado e cujo endereço não contém a palavra 'teste'.
-- Permite localizar clientes com e-mails disponíveis para contato.

SELECT
    idcliente,
    nome,
    telefone,
    email
FROM cliente
WHERE
    email IS NOT NULL
    AND NOT (email ILIKE '%teste%');



-- QUESTÃO 3 - INTERVALOS INCLUSIVOS E LISTAS [BETWEEN, IN]

-- Consulta os serviços com valores entre R$ 20,00 e R$ 70,00, incluindo os limites, e que pertencem à lista de serviços selecionados.
-- Permite localizar serviços dentro de uma determinada faixa de preço.

SELECT
    idservico,
    nome_servico,
    valor
FROM servico
WHERE
    valor BETWEEN 20.00 AND 70.00
    AND nome_servico IN (
        'Banho',
        'Tosa Completa',
        'Hidratacao',
        'Banho Medicinal',
        'Banho Premium'
    );



-- QUESTÃO 4A - BUSCA CASE-INSENSITIVE E CURINGA %

-- Localiza os serviços que possuem a palavra 'banho' em qualquer posição do nome, sem diferenciar letras maiúsculas e minúsculas.
-- O símbolo % representa qualquer quantidade de caracteres.

SELECT
    idservico,
    nome_servico,
    valor
FROM servico
WHERE nome_servico ILIKE '%banho%';


-- QUESTÃO 4B - BUSCA COM CORINGA DE CARACTERE ÚNICO _

-- Consulta os clientes cujos telefones começam com '359' e possuem exatamente oito caracteres após esse prefixo.
-- O símbolo _ representa um único caractere.

SELECT
    idcliente,
    nome,
    telefone
FROM cliente
WHERE telefone LIKE '359________';



-- QUESTÃO 5 - SIMULAÇÃO NUMÉRICA E ARREDONDAMENTOS

-- Simula um reajuste de 10% no valor dos serviços.
-- Apresenta o valor original, o valor reajustado com arredondamento utilizando ROUND e o valor cortado utilizando TRUNC, ambos com duas casas decimais.

SELECT
    nome_servico,
    valor AS valor_original,
    ROUND(valor * 1.10, 2) AS valor_com_reajuste,
    TRUNC(valor * 1.10, 2) AS valor_truncado
FROM servico;



-- QUESTÃO 6A - CLASSIFICAÇÃO POR MÓDULO [MOD]

-- Classifica os clientes de acordo com seus códigos,
-- identificando quais possuem ID par ou ímpar.
-- Permite separar os clientes em dois grupos.

SELECT
    idcliente,
    nome,
    MOD(idcliente, 2) AS resultado_modulo,
    CASE
        WHEN MOD(idcliente, 2) = 0 THEN 'Par'
        ELSE 'Impar'
    END AS classificacao
FROM cliente;


-- QUESTÃO 6B - SORTEIO DE REGISTRO [RANDOM()]

-- Sorteia aleatoriamente um agendamento que não esteja cancelado.
-- Pode ser utilizado em ações promocionais ou sorteios
-- realizados pelo estabelecimento.

SELECT
    idagendamento,
    idanimal,
    idservico,
    data_agendamento,
    horario,
    status
FROM agendamento
WHERE status <> 'Cancelado'
ORDER BY RANDOM()
LIMIT 1;



-- QUESTÃO 7 - CONCATENAÇÃO, PADRONIZAÇÃO E EXTRAÇÃO DE STRINGS

-- Gera uma descrição reunindo o nome do cliente e a raça do animal utilizando CONCAT.
-- Utiliza COALESCE para proteger contra valores nulos.
-- Padroniza a espécie com INITCAP e extrai o primeiro nome do cliente utilizando SPLIT_PART.

SELECT
    CONCAT(
        cliente.nome,
        ' - ',
        COALESCE(animal.raca, 'Raca nao informada')
    ) AS identificacao_animal,
    INITCAP(animal.especie) AS especie_padronizada,
    SPLIT_PART(cliente.nome, ' ', 1) AS primeiro_nome
FROM animal
INNER JOIN cliente
    ON cliente.idcliente = animal.idcliente;



-- QUESTÃO 8 - EXTRAÇÃO TEMPORAL E JANELA DE PERÍODO

-- Consulta os agendamentos realizados nos últimos 30 dias.
-- Utiliza EXTRACT para identificar o ano e o mês, DATE_TRUNC para identificar o início do mês e INTERVAL para determinar o período da consulta.

SELECT
    idagendamento,
    data_agendamento,
    EXTRACT(YEAR FROM data_agendamento) AS ano,
    EXTRACT(MONTH FROM data_agendamento) AS mes,
    DATE_TRUNC(
        'month',
        data_agendamento::TIMESTAMP
    ) AS inicio_mes
FROM agendamento
WHERE data_agendamento >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY data_agendamento;



-- QUESTÃO 9 - TEMPO DECORRIDO E PROJEÇÃO FUTURA

-- Consulta o tempo decorrido desde o cadastro dos clientes utilizando AGE e NOW.
-- Também apresenta uma previsão de renovação cadastral, considerando um período de um ano após o cadastro.

SELECT
    idcliente,
    nome,
    data_cadastro,
    AGE(NOW(), data_cadastro) AS tempo_desde_cadastro,
    data_cadastro + INTERVAL '1 year' AS previsao_renovacao
FROM cliente
ORDER BY idcliente;



-- QUESTÃO 10 - RELATÓRIO GERENCIAL FORMATADO

-- Gera um relatório dos atendimentos, relacionando clientes, animais, serviços e pagamentos.
-- Formata as datas no padrão brasileiro DD/MM/YYYY, os valores monetários com TO_CHAR e os códigos dos agendamentos com zeros à esquerda utilizando LPAD.

SELECT
    LPAD(
        agendamento.idagendamento::TEXT,
        5,
        '0'
    ) AS codigo_agendamento,
    cliente.nome AS nome_cliente,
    animal.nome AS nome_animal,
    servico.nome_servico AS servico_contratado,
    TO_CHAR(
        agendamento.data_agendamento,
        'DD/MM/YYYY'
    ) AS data_atendimento,
    agendamento.horario,
    TO_CHAR(
        servico.valor,
        'FM"R$" 999G990D00'
    ) AS valor_servico,
    TO_CHAR(
        pagamento.valor_pago,
        'FM"R$" 999G990D00'
    ) AS valor_pago,
    pagamento.forma_pagamento AS forma_pagamento
FROM agendamento
INNER JOIN animal
    ON animal.idanimal = agendamento.idanimal
INNER JOIN cliente
    ON cliente.idcliente = animal.idcliente
INNER JOIN servico
    ON servico.idservico = agendamento.idservico
INNER JOIN pagamento
    ON pagamento.idagendamento = agendamento.idagendamento
ORDER BY agendamento.data_agendamento;