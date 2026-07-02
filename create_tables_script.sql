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




---view

CREATE OR REPLACE VIEW view_order_details AS
SELECT 
    o.id AS order_id,
    o.order_date,
    c.name AS customer_name,
    b.title AS book_title,
    oi.quantity,
    (oi.quantity * b.price) AS total_price
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN books b ON oi.book_id = b.id;

SELECT * FROM view_order_details limit 90;


---procedure

CREATE OR REPLACE PROCEDURE update_book_price(p_book_id VARCHAR(36), p_new_price DECIMAL)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE books 
    SET price = p_new_price 
    WHERE id = p_book_id;
    
    --перевірка чи така книга існує взагалі
    IF NOT FOUND THEN
        RAISE NOTICE 'Книгу з таким ID не знайшли!';
    END IF;
END;
$$;


CALL update_book_price('7a98ae60-5805-413f-a914-de1b509541ea', 57.99);

SELECT title, price FROM books WHERE id = '7a98ae60-5805-413f-a914-de1b509541ea';



---create users

CREATE USER book_admin WITH PASSWORD 'admin';
GRANT ALL PRIVILEGES ON DATABASE assignment_04 TO book_admin;

CREATE USER book_manager WITH PASSWORD 'manager';
GRANT SELECT, UPDATE ON books TO book_manager;

CREATE USER book_viewer WITH PASSWORD 'viewer';
GRANT SELECT ON books TO book_viewer;


SET ROLE book_viewer;
SELECT * FROM books;
UPDATE books SET price = 0 WHERE id = '7a98ae60-5805-413f-a914-de1b509541ea';
RESET ROLE;



--- function

CREATE OR REPLACE FUNCTION book_status(book_name VARCHAR)   
RETURNS TABLE(title VARCHAR, price DECIMAL, status TEXT)
AS $$
BEGIN
	RETURN QUERY 
	SELECT
		b.title,
		b.price,
		CASE
			WHEN b.price > 20 THEN 'дорога'
			ELSE 'дешева'
		END AS status
	FROM books b
	WHERE b.title = book_name;

	IF NOT FOUND THEN 
		RAISE EXCEPTION 'Книгу не знайдено';
	END IF;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM book_status('Really read like');



