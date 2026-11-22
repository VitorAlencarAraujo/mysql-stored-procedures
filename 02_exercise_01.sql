DELIMITER //

CREATE PROCEDURE atualizar_preco_categoria(
    IN p_id_categoria INT,
    IN p_percentual DECIMAL(5,2),
    OUT p_quantidade_alterada INT,
    OUT p_mensagem VARCHAR(255)
)

BEGIN

    -- Variáveis locais
    DECLARE v_categoria_existe INT DEFAULT 0;

    -- Inicializa os parâmetros de saída
    SET p_quantidade_alterada = 0;
    SET p_mensagem = '';

    -- Valida os parâmetros recebidos
    IF p_id_categoria IS NULL OR p_percentual IS NULL THEN

        SET p_mensagem = 'ERRO: Informe a categoria e o percentual.';

    -- Valida o limite de desconto
    ELSEIF p_percentual < -50 THEN

        SET p_mensagem = 'ERRO: O desconto máximo permitido é de 50%.';

    -- 3. Valida o limite de aumento
    ELSEIF p_percentual > 100 THEN

        SET p_mensagem = 'ERRO: O aumento máximo permitido é de 100%.';

    ELSE

        -- Verifica se a categoria existe
        SELECT COUNT(*)
        INTO v_categoria_existe
        FROM categorias
        WHERE id_categoria = p_id_categoria;

        IF v_categoria_existe = 0 THEN

            SET p_mensagem = 'ERRO: Categoria não encontrada.';

        -- 5. Trata percentual igual a zero
        ELSEIF p_percentual = 0 THEN

            SET p_mensagem = 'Nenhum ajuste realizado: percentual igual a zero.';

        ELSE

            -- Atualiza os preços dos produtos ativos
            UPDATE produtos
            SET preco = ROUND(
                preco + (preco * p_percentual / 100),
                2
            )
            WHERE id_categoria = p_id_categoria
            AND ativo = TRUE;

            -- Captura a quantidade de produtos alterados
            SET p_quantidade_alterada = ROW_COUNT();

            -- Define a mensagem de retorno
            IF p_quantidade_alterada > 0 THEN

                SET p_mensagem = CONCAT(
                    'Sucesso! ',
                    p_quantidade_alterada,
                    ' produto(s) tiveram seus preços ajustados em ',
                    p_percentual,
                    '%.'
                );

            ELSE

                SET p_mensagem = 'Nenhum produto ativo encontrado para atualização.';

            END IF;

            -- Registra a operação no log
            INSERT INTO log_operacoes (
                tabela_afetada,
                operacao,
                descricao
            )
            VALUES (
                'produtos',
                'UPDATE',
                CONCAT(
                    'Categoria: ',
                    p_id_categoria,
                    ' | Percentual: ',
                    p_percentual,
                    '% | Produtos alterados: ',
                    p_quantidade_alterada
                )
            );

        END IF;

    END IF;

END //

DELIMITER ;

-- TESTES 

-- Aumento de 10% na categoria Notebooks
CALL atualizar_preco_categoria(1, 10, @quantidade, @mensagem);

SELECT @quantidade AS produtos_alterados,
       @mensagem AS resultado;
       
-- Desconto de 20% na categoria Periféricos
CALL atualizar_preco_categoria(3, -20, @quantidade, @mensagem);

SELECT @quantidade AS produtos_alterados,
       @mensagem AS resultado;
       
-- Testar desconto acima do permitido
CALL atualizar_preco_categoria(1, -60, @quantidade, @mensagem);

SELECT @quantidade AS produtos_alterados,
       @mensagem AS resultado;
       
