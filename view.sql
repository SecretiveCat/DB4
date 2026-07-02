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