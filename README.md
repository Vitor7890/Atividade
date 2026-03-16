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
