DROP TABLE IF EXISTS clients CASCADE;

CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL CHECK (position('@' in email) > 0),
    discount_percent INT CHECK (discount_percent >= 0 AND discount_percent <= 50)
);

INSERT INTO clients (full_name, email, discount_percent) VALUES
('Александр Маландин', 'alexmal05@mail.ru', 37),
('Иван Почтималандин', 'ivanpoch@gmail.com', 20),
('Алексей Мегамаландин', 'alexemega@mail.ru', 50),
('Саша Маландина', 'sashamala@malala.com', 0);
