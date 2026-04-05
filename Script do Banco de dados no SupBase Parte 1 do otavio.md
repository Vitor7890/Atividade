
-- 1. Tabela responsável por organizar as categorias do estoque
CREATE TABLE categorias (
  
  -- Identificador único universal (UUID), gerado automaticamente. 
  -- É o padrão de nuvem por ser mais seguro que usar números sequenciais (1, 2, 3).
  -- A PRIMARY KEY (Chave Primária) garante que este ID não se repita.
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  
  -- Coluna que guarda o nome da categoria.
  -- A regra NOT NULL atua como uma trava de segurança, impedindo o cadastro de uma categoria sem nome.
 
  nome text NOT NULL,
  -- Coluna de auditoria (Carimbo de tempo).
  -- A função DEFAULT timezone() preenche a data e hora exatas em padrão UTC automaticamente.
  criado_em timestamp with time zone DEFAULT timezone('utc'::text, now())
);

-- 2. Tabela principal onde os dados de todos os produtos do estoque ficam armazenados
CREATE TABLE itens (
  
  -- Identificador único do item (UUID padrão de nuvem).
  -- A PRIMARY KEY garante a exclusividade deste registro no banco.
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  
  -- Nome do produto. A regra NOT NULL torna o preenchimento obrigatório.
  nome text NOT NULL,
  
  -- Descrição detalhada do produto. Como não possui NOT NULL, o preenchimento é opcional.
  descricao text,
  
  -- Código SKU (Stock Keeping Unit), que funciona como um código de barras interno.
  -- A restrição UNIQUE garante que não existam dois produtos diferentes usando o mesmo código SKU.
  sku text UNIQUE,
  
  -- Quantidade de peças disponíveis no estoque físico.
  -- O DEFAULT 0 assegura que, ao cadastrar um item sem informar a quantidade, ele nasce zerado no sistema.
  quantidade_atual integer DEFAULT 0,
  
  -- Preço do produto.
  -- O tipo numeric(10,2) permite números precisos para dinheiro: até 10 dígitos no total, sendo 2 casas decimais (ex: 99999999.99).
  preco_unitario numeric(10,2),
  
  -- Chave Estrangeira (Foreign Key). 
  -- O comando REFERENCES conecta este produto diretamente à tabela de categorias.
  -- Isso atua como uma barreira de segurança: impede que você cadastre um item apontando para uma categoria que não existe.
  categoria_id uuid REFERENCES categorias(id),
  
  -- Coluna de auditoria que registra automaticamente o momento exato em que o produto foi criado.
  criado_em timestamp with time zone DEFAULT timezone('utc'::text, now()),
  
  -- Coluna de auditoria para registrar a data e hora da última vez que esse item foi modificado.
  atualizado_em timestamp with time zone DEFAULT timezone('utc'::text, now())
);

-- 3. Tabela responsável por registrar o histórico de entradas e saídas de produtos

CREATE TABLE movimentacoes (
  
  -- Identificador único da movimentação (UUID padrão de nuvem).
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  
  -- Chave Estrangeira (Foreign Key). 
  -- O comando REFERENCES liga esta movimentação ao produto específico na tabela 'itens'.
  -- O NOT NULL garante que não exista uma movimentação "fantasma" sem um produto real associado.
  item_id uuid REFERENCES itens(id) NOT NULL,
  
  -- Tipo de movimentação. 
  -- A regra CHECK é uma trava de segurança essencial: ela força o banco a aceitar APENAS as palavras 'entrada' ou 'saida'. Qualquer erro de digitação será bloqueado.
  tipo text NOT NULL CHECK (tipo IN ('entrada', 'saida')),
  
  -- Quantidade de itens sendo adicionados ou retirados do estoque naquela transação.
  -- O NOT NULL obriga o preenchimento desse número.
  quantidade integer NOT NULL,
  
  -- Campo de texto livre para anotações (ex: "Lote danificado" ou "Compra do fornecedor X"). 
  -- Como não tem a restrição NOT NULL, o preenchimento é opcional.
  observacao text,
  
  -- Coluna de auditoria para registrar automaticamente a data e hora exatas em que a transação ocorreu.
  data_movimentacao timestamp with time zone DEFAULT timezone('utc'::text, now())
);
