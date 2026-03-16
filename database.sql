
CREATE TABLE produtos (
    product_id UUID PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'available'
);

CREATE TABLE estoque (
    product_id UUID PRIMARY KEY,
    quantity INTEGER NOT NULL,
    reserved INTEGER DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE orders (
    order_id UUID PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_item_id UUID PRIMARY KEY,
    order_id UUID,
    product_id UUID,
    quantity INTEGER,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE local_fisico (
    location_id UUID PRIMARY KEY,
    location_code VARCHAR(50) UNIQUE NOT NULL,
    location_name VARCHAR(255) NOT NULL,
    location_type VARCHAR(50),
    capacity INTEGER,
    status VARCHAR(20) DEFAULT 'active'
);
