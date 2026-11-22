DELIMITER //

CREATE PROCEDURE consultar_extrato_cliente(
    IN p_id_cliente INT
)
BEGIN
    -- Variável para verificar se o cliente existe
    DECLARE v_cliente_existe INT DEFAULT 0;

    -- Verifica se o cliente está cadastrado
    SELECT COUNT(*)
    INTO v_cliente_existe
    FROM clientes
    WHERE id_cliente = p_id_cliente;

    -- Verifica se o cliente existe
    IF v_cliente_existe = 0 THEN

        SELECT 'ERRO: Cliente não encontrado.' AS mensagem;

    ELSE

        -- RESULT SET 1: Dados do cliente
        SELECT
            nome,
            email,
            telefone,
            criado_em AS data_cadastro
        FROM clientes
        WHERE id_cliente = p_id_cliente;

        -- RESULT SET 2: Todos os pedidos do cliente
        SELECT
            id_pedido AS numero_pedido,
            data_pedido,
            status,
            valor_total
        FROM pedidos
        WHERE id_cliente = p_id_cliente
        ORDER BY data_pedido DESC;

        -- RESULT SET 3: Resumo dos pedidos
        SELECT
            COUNT(*) AS total_pedidos,
            IFNULL(SUM(valor_total), 0.00) AS valor_total_gasto,
            IFNULL(AVG(valor_total), 0.00) AS ticket_medio,
            MAX(data_pedido) AS ultimo_pedido
        FROM pedidos
        WHERE id_cliente = p_id_cliente;

    END IF;

END //

DELIMITER ;


-- TESTES

-- Cliente existente
CALL consultar_extrato_cliente(1);

-- Cliente não existente
CALL consultar_extrato_cliente(150);
