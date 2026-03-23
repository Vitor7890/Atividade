CREATE TABLE stock (
    product_id UUID PRIMARY KEY,
    quantity INTEGER NOT NULL,
    reserved INTEGER DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE physical_locations (
    location_id UUID PRIMARY KEY,
    location_code VARCHAR(50) UNIQUE NOT NULL,
    location_name VARCHAR(255) NOT NULL,
    location_type VARCHAR(50),
    capacity INTEGER,
    status VARCHAR(20) DEFAULT 'active'
);
