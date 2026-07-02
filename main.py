import uuid
import random
import psycopg2
from psycopg2 import extras
from faker import Faker

DB_CONFIG = {"dbname": "assignment_04", "user": "postgres", "password": "*****", "host": "localhost", "port": "5432"}
fake = Faker()

def fill_store():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    print("Починаю генерацію...")

    # 1. Автори (10к)
    authors = [(str(uuid.uuid4()), fake.name(), fake.text(max_nb_chars=50)) for _ in range(10000)]
    extras.execute_values(cur, "INSERT INTO authors VALUES %s", authors)
    
    # 2. Книги (500к)
    print("Генерую 500к книг...")
    books = [(str(uuid.uuid4()), fake.sentence(nb_words=3), round(random.uniform(5, 50), 2), authors[random.randint(0, 9999)][0]) for _ in range(500000)]
    extras.execute_values(cur, "INSERT INTO books (id, title, price, author_id) VALUES %s", books)
    
    # 3. Клієнти (100к)
    customers = [(str(uuid.uuid4()), fake.name(), fake.unique.email()) for _ in range(100000)]
    extras.execute_values(cur, "INSERT INTO customers VALUES %s", customers)
    
    # 4. Замовлення (100к)
    orders = [(str(uuid.uuid4()), customers[random.randint(0, 99999)][0]) for _ in range(100000)]
    extras.execute_values(cur, "INSERT INTO orders (id, customer_id) VALUES %s", orders)

    # 5. Самі елементи замовлення (200к)
    print("Генерую елементи замовлення...")
    items_set = set()
    while len(items_set) < 200000:
        order_idx = random.randint(0, 99999)
        book_idx = random.randint(0, 499999)
        items_set.add((orders[order_idx][0], books[book_idx][0], random.randint(1, 3)))
    
    extras.execute_values(cur, "INSERT INTO order_items (order_id, book_id, quantity) VALUES %s", list(items_set))

    conn.commit()
    print("Усі таблиці заповнені!")
    cur.close()
    conn.close()

if __name__ == "__main__":
    fill_store()