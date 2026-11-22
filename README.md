# MySQL - Stored Procedures

Projeto desenvolvido como atividade prática de **MySQL**, com foco na criação e utilização de *Stored Procedures* (procedimentos armazenados).

O projeto utiliza um banco de dados fictício de uma loja de tecnologia, chamado `loja_tech`, para praticar operações de atualização de dados, validações e consultas.

## Conteúdo

- [Objetivo](#-objetivo)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Atividades Desenvolvidas](#-atividades-desenvolvidas)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Como Executar](#-como-executar)

## Objetivo

Praticar a criação de procedimentos armazenados no MySQL, utilizando parâmetros de entrada e saída, estruturas condicionais, funções de agregação, atualização de registros e consultas ao banco de dados.

## Estrutura do Projeto

```text
mysql-stored-procedures/
│
├── 01_create_database.sql
├── 02_exercise_01.sql
├── 03_exercise_02.sql
└── README.md
```

## 📝 Atividades Desenvolvidas

### Atividade 1 - Atualizar Preços por Categoria

**Procedure:** `atualizar_preco_categoria`

Procedimento responsável por atualizar os preços dos produtos ativos de uma determinada categoria.

**Funcionalidades:**
- Recebe o ID da categoria e o percentual de reajuste.
- Permite aumentos de até 100%.
- Permite descontos de até 50%.
- Atualiza somente produtos ativos.
- Verifica se a categoria existe.
- Retorna a quantidade de produtos alterados.
- Retorna uma mensagem de sucesso ou erro.
- Registra a operação na tabela `log_operacoes`.

**Principais recursos utilizados:**
`UPDATE`, `ROW_COUNT()`, `IF`, `ELSEIF`, parâmetros `IN` e `OUT`.

### Atividade 2 - Consultar Extrato do Cliente

**Procedure:** `consultar_extrato_cliente`

Procedimento responsável por consultar os dados e o histórico de pedidos de um cliente.

**Funcionalidades:**

Retorna três conjuntos de resultados (*Result Sets*):

1. **Dados do cliente:** nome, e-mail, telefone e data de cadastro.
2. **Histórico de pedidos:** número do pedido, data, status e valor total.
3. **Resumo dos pedidos:** quantidade de pedidos, valor total gasto, ticket médio e data do último pedido.

Também verifica se o cliente existe e retorna uma mensagem de erro caso não seja encontrado.

**Principais recursos utilizados:**
`SELECT`, `COUNT()`, `SUM()`, `AVG()`, `MAX()`, `IFNULL()` e estruturas condicionais.

## Tecnologias Utilizadas

- MySQL
- MySQL Workbench

## Como Executar

1. Clone este repositório

2. Abra o MySQL Workbench e conecte-se ao seu servidor MySQL.

3. Abra e execute os arquivos na seguinte ordem:

| Ordem | Arquivo | Descrição |
|---|---|---|
| 1 | `01_create_database.sql` | Criação do banco de dados e das tabelas |
| 2 | `02_exercise_01.sql` | Criação da procedure de atualização de preços |
| 3 | `03_exercise_02.sql` | Criação da procedure de consulta do extrato |

4. Após executar os scripts, utilize os comandos `CALL` para testar as procedures.

**Exemplos de execução:**

```sql
-- Atividade 1
CALL atualizar_preco_categoria(1, 10, @quantidade, @mensagem);

SELECT @quantidade AS produtos_alterados, @mensagem AS resultado;

-- Atividade 2
CALL consultar_extrato_cliente(1);
```

---

Desenvolvido como atividade prática de Banco de Dados.
