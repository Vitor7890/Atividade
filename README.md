Projeto4pontos
trabalho 4 pontos

Marketplace Distribuído - API
Descrição
Esta API faz parte de um sistema de marketplace distribuído onde cada grupo é responsável por um serviço.

Serviços do sistema:

Catálogo → gerenciamento de produtos
Estoque → controle de quantidade disponível
Pedidos → criação de pedidos
O banco de dados utilizado é PostgreSQL hospedado no Supabase.

Padrão de JSON
Foi definido o padrão snake_case para os nomes dos campos.

Exemplo:

{ "product_id": "89f3b", "sku": "SKU-99", "display_name": "Monitor UltraWide 29", "unit_price": 1850.00, "status": "available" }

Endpoints da API
1. Buscar Produto
GET /v1/products/:sku

Descrição: Retorna os dados de um produto pelo SKU.

Response:

{ "product_id": "89f3b", "sku": "SKU-99", "display_name": "Monitor UltraWide 29", "unit_price": 1850.00, "status": "available" }

2. Consultar Estoque
GET /v1/stock/:product_id

Response:

{ "product_id": "89f3b", "quantity": 20, "reserved": 2 }

3. Criar Pedido
POST /v1/orders

Body:

{ "items": [ { "sku": "SKU-99", "quantity": 1 } ] }

Response:

{ "order_id": "a72f98", "total_amount": 1850.00, "status": "confirmed" }

Tratamento de Erros
200 → Sucesso
400 → Requisição inválida
404 → Produto não encontrado
409 → Estoque insuficiente
500 → Erro interno do servidor

Exemplo de erro:

{ "error": "stock_unavailable", "message": "Produto sem estoque disponível" }

Banco de Dados
O banco utilizado é PostgreSQL no Supabase. As tabelas estão definidas no arquivo database.sql.

Schema de validação para o arquivo de estoque:

Arquivo: stock.json

{ "product_id": "location_id": <number "available_quantity": "reserved_quantity": }

Regras das Propriedades:

product_id (number, Obrigatório): ID do produto.
location_id (number, Obrigatório): ID do local de armazenamento.
available_quantity (number, Obrigatório): Quantidade livre.
reserved_quantity (number, Opcional) : Quantidade reservada (Padrão: 0).
Documentação do Objeto de Local Físico (Physical Location)

Schema de validação para cadastro ou consulta de locais físicos:

Arquivo: physical_location.json

Exemplo de estrutura do arquivo (JSON válido):

{ "location_name": "", "location_type": "", "description": "", "max_capacity": , "status": "" }

Regras das Propriedades:

location_name (string, Obrigatório): O nome de identificação do local.
location_type (string, Obrigatório): A categoria ou classificação do local.
description (string, Opcional) : Detalhes ou observações adicionais sobre o local.
max_capacity (number, Opcional) : Limite máximo de itens ou volume suportado.
status (string, Opcional) : A situação atual de operação do local. ↳ Regra de Enumeração: Só aceita os valores exatos "ACTIVE" ou "INACTIVE". ↳ Regra Padrão: Se o campo não for enviado, assumirá o valor "ACTIVE".
projeto/ | ├─ database.sql ├─ README.md ├─ stock.json └─ physical_location.json
