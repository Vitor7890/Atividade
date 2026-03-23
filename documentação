# API de Estoque

## 1. Visão Geral

Esta API foi desenvolvida para gerenciar o controle de estoque em um sistema de marketplace distribuído.

A API segue o padrão RESTful, utilizando métodos HTTP para realizar operações de consulta, criação e atualização de recursos relacionados ao estoque.

### Recursos principais da API

* Estoque
* Locais físicos

---

## Métodos HTTP utilizados

| Método | Função                              |
| ------ | ----------------------------------- |
| GET    | Consultar informações               |
| POST   | Criar novos registros               |
| PUT    | Atualizar completamente um registro |
| PATCH  | Atualizar parcialmente um registro  |

---

## 2. API de Estoque

### Consultar estoque de um produto

**GET /v1/stock/{product_id}**

Retorna as informações de estoque de um produto em diferentes locais.

#### Resposta

```json id="z6rx35"
{
  "product_id": "uuid",
  "locations": [
    {
      "location_id": "uuid",
      "quantity": 20,
      "reserved": 5
    }
  ]
}
```

---

### Adicionar produto ao estoque

**POST /v1/stock**

Registra um produto em um local físico.

#### Exemplo

```json id="1wh3ns"
{
  "product_id": "uuid",
  "location_id": "uuid",
  "quantity": 50
}
```

#### Resposta (201)

```json id="eqm3mm"
{
  "message": "stock_created",
  "product_id": "uuid",
  "location_id": "uuid",
  "quantity": 50
}
```

---

### Atualizar quantidade do estoque

**PATCH /v1/stock/{product_id}/{location_id}**

Atualiza parcialmente os dados de estoque de um produto em um local específico.

#### Exemplo

```json id="74h8u5"
{
  "quantity": 60
}
```

#### Resposta (200)

```json id="g9prb7"
{
  "message": "stock_updated",
  "product_id": "uuid",
  "location_id": "uuid",
  "quantity": 60
}
```

---

### Reservar estoque

**PATCH /v1/stock/{product_id}/reserve**

Reserva uma quantidade de produto.

#### Exemplo

```json id="0w34nr"
{
  "quantity": 5
}
```

#### Resposta (200)

```json id="drd6gl"
{
  "message": "stock_reserved",
  "product_id": "uuid",
  "reserved": 5
}
```

---

### Remover itens do estoque

**POST /v1/stock/exit**

Remove itens do estoque (ex: saída por venda).

#### Exemplo

```json id="q4lh9t"
{
  "product_id": "uuid",
  "quantity": 15
}
```

#### Resposta (200)

```json id="qv0f6j"
{
  "message": "stock_updated",
  "product_id": "uuid",
  "remaining_quantity": 5
}
```

#### Erro (409 - Estoque insuficiente)

```json id="ikg2k6"
{
  "error": "stock_unavailable",
  "message": "Estoque insuficiente",
  "available_quantity": 10,
  "requested_quantity": 15
}
```

---

## 3. API de Locais Físicos

### Criar local físico

**POST /v1/locations**

Cria um novo local de armazenamento.

#### Exemplo

```json id="1d8xq2"
{
  "location_code": "DEP01",
  "location_name": "Depósito Principal",
  "location_type": "warehouse",
  "capacity": 1000
}
```

---

### Listar locais

**GET /v1/locations**

Retorna todos os locais cadastrados.

---

### Buscar local específico

**GET /v1/locations/{location_id}**

Retorna os dados de um local específico.

---

### Atualizar local

**PUT /v1/locations/{location_id}**

Atualiza completamente os dados do local.

---

### Atualizar status do local

**PATCH /v1/locations/{location_id}/status**

Atualiza apenas o status do local.

---

## 4. Códigos de Resposta HTTP

| Código | Significado                      |
| ------ | -------------------------------- |
| 200    | Requisição realizada com sucesso |
| 201    | Recurso criado com sucesso       |
| 400    | Requisição inválida              |
| 404    | Recurso não encontrado           |
| 409    | Conflito (estoque insuficiente)  |
| 500    | Erro interno do servidor         |

### Exemplo de erro

```json id="o3hgyj"
{
  "error": "stock_unavailable",
  "message": "Produto sem estoque disponível"
}
```

### Erro interno do servidor (500)

```json id="2q5k0c"
{
  "error": "internal_server_error",
  "message": "Ocorreu um erro inesperado ao processar a requisição"
}
```

---

## 5. Fluxo Básico do Sistema

O funcionamento básico da API segue os seguintes passos:

1. Criar locais físicos:

   * POST /v1/locations

2. Registrar produtos no estoque:

   * POST /v1/stock

3. Consultar disponibilidade:

   * GET /v1/stock/{product_id}

4. Reservar itens:

   * PATCH /v1/stock/{product_id}/reserve

5. Realizar saída de estoque:

   * POST /v1/stock/exit

---

## 6. Estrutura do Projeto

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
