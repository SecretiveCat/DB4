DROP TABLE IF EXISTS order_items, orders, books, authors, customers CASCADE;

CREATE TABLE authors (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    bio TEXT
);

CREATE TABLE books (
    id VARCHAR(36) PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    price DECIMAL(10, 2) CHECK (price >= 0),
    author_id VARCHAR(36) REFERENCES authors(id) ON DELETE CASCADE
);

CREATE TABLE customers (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    email VARCHAR(200) UNIQUE
);

CREATE TABLE orders (
    id VARCHAR(36) PRIMARY KEY,
    customer_id VARCHAR(36) REFERENCES customers(id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    order_id VARCHAR(36) REFERENCES orders(id),
    book_id VARCHAR(36) REFERENCES books(id),
    quantity INT CHECK (quantity > 0),
    PRIMARY KEY (order_id, book_id)
);

CREATE INDEX idx_book_title ON books(title);
CREATE INDEX idx_customer_email ON customers(email);