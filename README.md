Marketplace Distribuído - API

Projeto (Trabalho – 4 pontos)

Descrição

Este projeto consiste no desenvolvimento de uma API para um sistema de marketplace distribuído, onde cada grupo é responsável por um serviço específico da arquitetura.

O sistema é composto por microsserviços, cada um responsável por uma parte da lógica de negócio.

Serviços do sistema

Catálogo → gerenciamento de produtos

Estoque → controle da quantidade disponível

Pedidos → criação e gerenciamento de pedidos

O banco de dados utilizado é PostgreSQL, hospedado no Supabase.

Padrão de Dados (JSON)

Foi adotado o padrão snake_case para os nomes dos campos em todas as requisições e respostas da API.

Exemplo de objeto de produto
{
  "product_id": "89f3b",
  "sku": "SKU-99",
  "display_name": "Monitor UltraWide 29",
  "unit_price": 1850.00,
  "status": "available"
}
Endpoints da API
1. Buscar Produto
GET /v1/products/:sku

Descrição:
Retorna os dados de um produto a partir do seu SKU.

Exemplo de resposta
{
  "product_id": "89f3b",
  "sku": "SKU-99",
  "display_name": "Monitor UltraWide 29",
  "unit_price": 1850.00,
  "status": "available"
}

2. Consultar Estoque
GET /v1/stock/:product_id

Descrição:
Retorna as informações de estoque de um produto.

Exemplo de resposta
{
  "product_id": "89f3b",
  "quantity": 20,
  "reserved": 2
}

Onde:

quantity → quantidade total disponível

reserved → quantidade reservada para pedidos

3. Criar Pedido
POST /v1/orders

Descrição:
Cria um novo pedido contendo os produtos selecionados.

Exemplo de requisição
{
  "items": [
    {
      "sku": "SKU-99",
      "quantity": 1
    }
  ]
}
Exemplo de resposta
{
  "order_id": "a72f98",
  "total_amount": 1850.00,
  "status": "confirmed"
}
Tratamento de Erros

A API utiliza códigos HTTP padrão para indicar o resultado das requisições.

| Código | Significado              |
| ------ | ------------------------ |
| 200    | Sucesso                  |
| 400    | Requisição inválida      |
| 404    | Produto não encontrado   |
| 409    | Estoque insuficiente     |
| 500    | Erro interno do servidor |

Exemplo de erro
{
  "error": "stock_unavailable",
  "message": "Produto sem estoque disponível"
}

Banco de Dados

O banco de dados utilizado é PostgreSQL hospedado no Supabase.

A estrutura do banco está definida no arquivo:

database.sql

Esse arquivo contém a criação das tabelas principais do sistema:

| Tabela | Descrição |
|------|------|
| products | Armazena as informações dos produtos |
| stock | Controla a quantidade disponível de cada produto |
| orders | Registra os pedidos realizados |
| order_items | Armazena os itens que compõem cada pedido |
| physical_locations | Registra os locais físicos de armazenamento |

Schema de Estoque

Arquivo:

stock.json

Define o formato de validação para registros de estoque.

Exemplo
{
  "product_id": "uuid",
  "location_id": "uuid",
  "available_quantity": 20,
  "reserved_quantity": 5
}
Regras das propriedades
Campo	Tipo	Obrigatório	Descrição
product_id	UUID	Sim	Identificador do produto
location_id	UUID	Sim	Identificador do local de armazenamento
available_quantity	number	Sim	Quantidade disponível
reserved_quantity	number	Não	Quantidade reservada (padrão: 0)
Objeto de Local Físico (Physical Location)

Arquivo:

physical_location.json

Define o formato para cadastro ou consulta de locais físicos de armazenamento.

Exemplo de estrutura
{
  "location_name": "Depósito Central",
  "location_type": "warehouse",
  "description": "Área principal de armazenamento",
  "max_capacity": 1000,
  "status": "ACTIVE"
}

| Campo         | Tipo   | Obrigatório | Descrição                            |
| ------------- | ------ | ----------- | ------------------------------------ |
| location_name | string | Sim         | Nome do local                        |
| location_type | string | Sim         | Tipo do local (ex: warehouse, shelf) |
| description   | string | Não         | Informações adicionais               |
| max_capacity  | number | Não         | Capacidade máxima                    |
| status        | string | Não         | Situação do local                    |

Valores permitidos para status
ACTIVE
INACTIVE

Valor padrão:

ACTIVE

Caso o campo não seja informado, o sistema assume automaticamente ACTIVE.

Estrutura do Projeto
projeto/
│
├── database.sql
├── README.md
├── stock.json
└── physical_location.json

| Arquivo                  | Descrição                             |
| ------------------------ | ------------------------------------- |
| `database.sql`           | Estrutura do banco de dados           |
| `README.md`              | Documentação do projeto               |
| `stock.json`             | Schema de validação do estoque        |
| `physical_location.json` | Schema de validação de locais físicos |

