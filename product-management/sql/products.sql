CREATE DATABASE IF NOT EXISTS product_db
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE product_db;

CREATE TABLE IF NOT EXISTS products (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    name     VARCHAR(255)   NOT NULL,
    price    DECIMAL(12, 2) NOT NULL,
    quantity INT            NOT NULL
);

INSERT INTO products (name, price, quantity) VALUES
    ('Laptop Dell XPS 13', 25990000.00, 10),
    ('iPhone 15',          22500000.00, 25),
    ('Chuột Logitech MX',   1890000.00, 40),
    ('Bàn phím cơ Keychron', 2450000.00, 18);
