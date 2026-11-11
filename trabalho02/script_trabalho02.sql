-- consultar informações de agendamento/se um agendamento existe !

CREATE OR REPLACE FUNCTION consulta_agendamento(p_agendamento_id INT)
RETURNS TEXT AS $$
DECLARE
    v_resumo TEXT;
BEGIN
    SELECT
        'Cliente: ' || cliente.nome ||
        ' | Animal: ' || animal.nome ||
        ' | Serviço: ' || servico.nome_servico ||
        ' | Data: ' || agendamento.data_agendamento ||
        ' | Horário: ' || agendamento.horario ||
        ' | Status: ' || agendamento.status
    INTO v_resumo
    FROM agendamento
    INNER JOIN animal
        ON animal.idanimal = agendamento.idanimal
    INNER JOIN cliente
        ON cliente.idcliente = animal.idcliente
    INNER JOIN servico
        ON servico.idservico = agendamento.idservico
    WHERE agendamento.idagendamento = p_agendamento_id;

    IF NOT FOUND THEN
        RETURN 'Agendamento não encontrado!';
    END IF;

    RETURN v_resumo;
END;
$$ LANGUAGE plpgsql;

-- -----------------------

-- consultar valor do serviço !

CREATE OR REPLACE FUNCTION retorna_valor_servico(p_servico_id INT)
RETURNS NUMERIC(10, 2) AS $$
DECLARE
    v_valor NUMERIC(10, 2);
BEGIN
    SELECT valor
    INTO v_valor
    FROM servico
    WHERE idservico = p_servico_id;

    RETURN COALESCE(v_valor, 0.00);
END;
$$ LANGUAGE plpgsql;

-- -----------------------

-- atualizar o status de um agendamento !

CREATE OR REPLACE FUNCTION atualiza_status_agendamento(
    p_agendamento_id INT,
    p_novo_status VARCHAR(20)
)
RETURNS TEXT AS $$
BEGIN
    IF p_novo_status IS NULL OR
       p_novo_status NOT IN ('Agendado', 'Concluido', 'Cancelado') THEN

        RETURN 'Status inválido! Informe Agendado, Concluido ou Cancelado.';
    END IF;

    UPDATE agendamento
    SET status = p_novo_status
    WHERE idagendamento = p_agendamento_id;

    IF NOT FOUND THEN
        RETURN 'Agendamento não encontrado!';
    END IF;

    RETURN 'Status do agendamento atualizado com sucesso!';
END;
$$ LANGUAGE plpgsql;

-- -----------------------

-- alguns exemplos de de execução
SELECT consulta_agendamento(1);
SELECT consulta_agendamento(99);

SELECT retorna_valor_servico(1); 
SELECT retorna_valor_servico(3); 
SELECT retorna_valor_servico(99); 
SELECT nome_servico, retorna_valor_servico(idservico) AS valor_servico FROM servico;

SELECT atualiza_status_agendamento(9, 'Concluido');
SELECT atualiza_status_agendamento(10, 'Cancelado');
SELECT atualiza_status_agendamento(99, 'Concluido');
SELECT atualiza_status_agendamento(1, 'Invalido');