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
