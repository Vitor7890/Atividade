
# API Marketplace Distribuído

## Descrição

Este projeto consiste no desenvolvimento de uma API para um sistema de marketplace distribuído, onde cada grupo é responsável por um serviço específico da arquitetura.

O sistema é composto por microsserviços, cada um responsável por uma parte da lógica de negócio.

---

## Serviços do sistema

* Catálogo → gerenciamento de produtos
* Estoque → controle da quantidade disponível

O banco de dados utilizado é PostgreSQL, hospedado no Supabase.

---

## Padrão de Dados (JSON)

Foi adotado o padrão `snake_case` para os nomes dos campos em todas as requisições e respostas da API.

### Exemplo de objeto de produto

```json
{
  "product_id": "89f3b",
  "sku": "SKU-99",
  "display_name": "Monitor UltraWide 29",
  "unit_price": 1850.00,
  "status": "available"
}
```

---

## Endpoints da API

## Estoque

### 2. Consultar Estoque

**GET /v1/stock/:product_id**

#### Descrição

Retorna as informações de estoque de um produto.

#### Exemplo de resposta

```json
{
  "product_id": "89f3b",
  "quantity": 20,
  "reserved": 2
}
```

#### Onde

* `quantity` → quantidade disponível
* `reserved` → quantidade reservada

---

### 3. Entrada de Estoque

**POST /v1/stock/entry**

#### Descrição

Adiciona itens ao estoque de um produto.

#### Request Body

```json
{
  "product_id": "89f3b",
  "quantity": 10
}
```

#### Resposta (200)

```json
{
  "message": "stock_updated",
  "product_id": "89f3b",
  "quantity": 30
}
```

#### Erro (400)

```json
{
  "error": "invalid_request",
  "message": "Quantidade inválida"
}
```

---

### 4. Saída de Estoque

**POST /v1/stock/exit**

#### Descrição

Remove itens do estoque (ex: compra de produto).

#### Request Body

```json
{
  "product_id": "89f3b",
  "quantity": 15
}
```

#### Resposta (200)

```json
{
  "message": "stock_updated",
  "product_id": "89f3b",
  "remaining_quantity": 5
}
```

#### Estoque insuficiente (409)

```json
{
  "error": "stock_unavailable",
  "message": "Estoque insuficiente",
  "available_quantity": 10,
  "requested_quantity": 15
}
```

#### Produto não encontrado (404)

```json
{
  "error": "product_not_found",
  "message": "Produto não encontrado"
}
```

---

### 5. Ajuste de Estoque

**PUT /v1/stock/:product_id**

#### Descrição

Atualiza manualmente a quantidade de um produto.

#### Request Body

```json
{
  "quantity": 50
}
```

#### Resposta (200)

```json
{
  "message": "stock_adjusted",
  "product_id": "89f3b",
  "quantity": 50
}
```

---

## Tratamento de Erros

A API utiliza códigos HTTP padrão para indicar o resultado das requisições.

| Código | Significado              |
| ------ | ------------------------ |
| 200    | Sucesso                  |
| 400    | Requisição inválida      |
| 404    | Produto não encontrado   |
| 409    | Estoque insuficiente     |
| 500    | Erro interno do servidor |

### Exemplo de erro

```json
{
  "error": "stock_unavailable",
  "message": "Produto sem estoque disponível"
}
```

---

## Banco de Dados

O banco de dados utilizado é PostgreSQL hospedado no Supabase.

A estrutura do banco está definida no arquivo:

`database.sql`

Esse arquivo contém a criação das tabelas principais do sistema:

| Tabela             | Descrição                                        |
| ------------------ | ------------------------------------------------ |
| stock              | Controla a quantidade disponível de cada produto |
| physical_locations | Registra os locais físicos de armazenamento      |

---

## Schema de Estoque

Arquivo: `stock.json`

Define o formato de validação para registros de estoque.

### Exemplo

```json
{
  "product_id": "uuid",
  "location_id": "uuid",
  "available_quantity": 20,
  "reserved_quantity": 5
}
```

### Regras das propriedades

| Campo              | Tipo   | Obrigatório | Descrição                        |
| ------------------ | ------ | ----------- | -------------------------------- |
| product_id         | UUID   | Sim         | Identificador do produto         |
| location_id        | UUID   | Sim         | Identificador do local           |
| available_quantity | number | Sim         | Quantidade disponível            |
| reserved_quantity  | number | Não         | Quantidade reservada (padrão: 0) |

---

## Objeto de Local Físico (Physical Location)

Arquivo: `physical_location.json`

Define o formato para cadastro ou consulta de locais físicos de armazenamento.

### Exemplo de estrutura

```json
{
  "location_name": "Depósito Central",
  "location_type": "warehouse",
  "description": "Área principal de armazenamento",
  "max_capacity": 1000,
  "status": "ACTIVE"
}
```

### Propriedades

| Campo         | Tipo   | Obrigatório | Descrição              |
| ------------- | ------ | ----------- | ---------------------- |
| location_name | string | Sim         | Nome do local          |
| location_type | string | Sim         | Tipo do local          |
| description   | string | Não         | Informações adicionais |
| max_capacity  | number | Não         | Capacidade máxima      |
| status        | string | Não         | Situação do local      |

### Valores permitidos para status

* ACTIVE
* INACTIVE

Valor padrão:
ACTIVE

---

## Estrutura do Projeto

```
projeto/
│
├── database.sql
├── README.md
├── stock.json
└── physical_location.json
```

| Arquivo                | Descrição                      |
| ---------------------- | ------------------------------ |
| database.sql           | Estrutura do banco de dados    |
| README.md              | Documentação do projeto        |
| stock.json             | Schema de validação do estoque |
| physical_location.json | Schema de locais físicos       |

---
