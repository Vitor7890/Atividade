-- =========================
-- TABELAS BASE
-- =========================

CREATE TABLE physical_locations (
    location_id UUID PRIMARY KEY,
    location_code VARCHAR(50) UNIQUE NOT NULL,
    location_name VARCHAR(255) NOT NULL,
    location_type VARCHAR(50),
    capacity INTEGER,
    status VARCHAR(20) DEFAULT 'active'
);

CREATE TABLE stock (
    product_id UUID,
    location_id UUID,
    quantity INTEGER NOT NULL DEFAULT 0,
    reserved INTEGER DEFAULT 0,
    PRIMARY KEY (product_id, location_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (location_id) REFERENCES physical_locations(location_id),
    CONSTRAINT chk_stock_non_negative CHECK (quantity >= 0)
);

-- =========================
-- MOVIMENTAÇÕES
-- =========================

CREATE TABLE stock_movements (
    movement_id UUID PRIMARY KEY,
    product_id UUID NOT NULL,
    from_location UUID,
    to_location UUID,
    movement_type VARCHAR(20) NOT NULL, 
    -- 'IN', 'OUT', 'TRANSFER'
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    movement_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference VARCHAR(255),

    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (from_location) REFERENCES physical_locations(location_id),
    FOREIGN KEY (to_location) REFERENCES physical_locations(location_id)
);

-- =========================
-- FUNÇÃO DE ATUALIZAÇÃO
-- =========================

CREATE OR REPLACE FUNCTION fn_update_stock()
RETURNS TRIGGER AS $$
DECLARE
    current_stock INTEGER;
BEGIN

    -- =====================
    -- TRANSFERÊNCIA
    -- =====================
    IF NEW.movement_type = 'TRANSFER' THEN

        -- Verifica saldo origem
        SELECT quantity INTO current_stock
        FROM stock
        WHERE product_id = NEW.product_id
        AND location_id = NEW.from_location;

        IF current_stock IS NULL OR current_stock < NEW.quantity THEN
            RAISE EXCEPTION 'Estoque insuficiente para transferência';
        END IF;

        -- Saída (X)
        UPDATE stock
        SET quantity = quantity - NEW.quantity
        WHERE product_id = NEW.product_id
        AND location_id = NEW.from_location;

        -- Garante destino (Y)
        INSERT INTO stock (product_id, location_id, quantity)
        VALUES (NEW.product_id, NEW.to_location, 0)
        ON CONFLICT (product_id, location_id) DO NOTHING;

        -- Entrada (Y)
        UPDATE stock
        SET quantity = quantity + NEW.quantity
        WHERE product_id = NEW.product_id
        AND location_id = NEW.to_location;

    END IF;

    -- =====================
    -- ENTRADA
    -- =====================
    IF NEW.movement_type = 'IN' THEN
        INSERT INTO stock (product_id, location_id, quantity)
        VALUES (NEW.product_id, NEW.to_location, NEW.quantity)
        ON CONFLICT (product_id, location_id)
        DO UPDATE SET quantity = stock.quantity + NEW.quantity;
    END IF;

    -- =====================
    -- SAÍDA
    -- =====================
    IF NEW.movement_type = 'OUT' THEN

        SELECT quantity INTO current_stock
        FROM stock
        WHERE product_id = NEW.product_id
        AND location_id = NEW.from_location;

        IF current_stock IS NULL OR current_stock < NEW.quantity THEN
            RAISE EXCEPTION 'Estoque insuficiente para saída';
        END IF;

        UPDATE stock
        SET quantity = quantity - NEW.quantity
        WHERE product_id = NEW.product_id
        AND location_id = NEW.from_location;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =========================
-- TRIGGER
-- =========================

CREATE TRIGGER trg_update_stock
AFTER INSERT ON stock_movements
FOR EACH ROW
EXECUTE FUNCTION fn_update_stock();

-- =========================
-- EXEMPLO PRÁTICO
-- =========================

-- Localizações X e Y
INSERT INTO physical_locations (location_id, location_code, location_name)
VALUES 
('loc-X', 'X', 'Estoque X'),
('loc-Y', 'Y', 'Estoque Y');

-- Produto com 10 unidades no estoque X
INSERT INTO stock (product_id, location_id, quantity)
VALUES ('prod-1', 'loc-X', 10);

-- Transferência de 5 unidades de X → Y
INSERT INTO stock_movements (
    movement_id,
    product_id,
    from_location,
    to_location,
    movement_type,
    quantity
) VALUES (
    gen_random_uuid(),
    'prod-1',
    'loc-X',
    'loc-Y',
    'TRANSFER',
    5
);

-- RESULTADO ESPERADO:
-- Estoque X = 5
-- Estoque Y = 5
