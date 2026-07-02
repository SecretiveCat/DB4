CREATE OR REPLACE PROCEDURE update_book_price(p_book_id VARCHAR(36), p_new_price DECIMAL)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE books 
    SET price = p_new_price 
    WHERE id = p_book_id;
    
    --перевірка чи така книга існує взагалі
    IF NOT FOUND THEN
        RAISE NOTICE 'Книгу з таким ID не знашли!';
    END IF;
END;
$$;


CALL update_book_price('7a98ae60-5805-413f-a914-de1b509541ea', 50.99);

SELECT title, price FROM books WHERE id = '7a98ae60-5805-413f-a914-de1b509541ea';