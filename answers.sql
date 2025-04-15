CREATE DATABASE IF NOT EXISTS bookstore;
USE bookstore;

CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    language_id INT,
    publisher_id INT,
    price DECIMAL(8,2),
    publication_year YEAR,
    FOREIGN KEY (language_id) REFERENCES book_language(language_id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

INSERT INTO book (title, language_id, publisher_id, price, publication_year) VALUES
('Things Fall Apart', 1, 1, 9.99, 1958),
('Harry Potter and the Sorcerer\s Stone', 1, 2, 12.99, 1997);


CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    bio TEXT
);

INSERT INTO author (name, bio) VALUES
('Chinua Achebe', 'Nigerian novelist and poet'),
('J.K. Rowling', 'British author, known for Harry Potter');




CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

INSERT INTO book_author (book_id, author_id) VALUES
(1, 1),
(2, 2);


CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(100)
);

INSERT INTO book_language (language_name) VALUES
('English'), ('French'), ('Spanish');



CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    address VARCHAR(255)
);

INSERT INTO publisher (name, address) VALUES
('Penguin Random House', '375 Hudson Street, NY'),
('HarperCollins', '195 Broadway, NY');



CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO customer (first_name, last_name, email) VALUES
('Alice', 'Kariuki', 'alice@example.com'),
('John', 'Doe', 'john@example.com');



CREATE TABLE address_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50)
);

INSERT INTO address_status (status_name) VALUES
('Current'), ('Old');


CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100)
);

INSERT INTO country (country_name) VALUES
('Kenya'), ('USA');


CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(255),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

INSERT INTO address (street, city, postal_code, country_id) VALUES
('Moi Avenue', 'Nairobi', '00100', 1),
('5th Avenue', 'New York', '10001', 2);


CREATE TABLE customer_address (
    customer_id INT,
    address_id INT,
    status_id INT,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

INSERT INTO customer_address (customer_id, address_id, status_id) VALUES
(1, 1, 1),
(2, 2, 1);



CREATE TABLE cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status_id INT,
    shipping_method_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id)
);

INSERT INTO cust_order (customer_id, order_date, status_id, shipping_method_id) VALUES
(1, '2025-04-14', 1, 1),
(2, '2025-04-15', 2, 2);


CREATE TABLE order_line (
    order_id INT,
    book_id INT,
    quantity INT,
    PRIMARY KEY (order_id, book_id),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

INSERT INTO order_line (order_id, book_id, quantity) VALUES
(1, 1, 2),
(2, 2, 1);


CREATE TABLE order_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50)
);

INSERT INTO order_status (status_name) VALUES
('Pending'), ('Shipped'), ('Delivered');



CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    status_id INT,
    change_date DATETIME,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

INSERT INTO order_history (order_id, status_id, change_date) VALUES
(1, 1, NOW()),
(2, 2, NOW());


CREATE TABLE shipping_method (
    shipping_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100),
    cost DECIMAL(6,2)
);

INSERT INTO shipping_method (method_name, cost) VALUES
('Standard Shipping', 5.00),
('Express Shipping', 10.00);



-- Create a new user
CREATE USER 'store_manager'@'localhost' IDENTIFIED BY 'password123';

-- Grant permissions
GRANT ALL PRIVILEGES ON bookstore.* TO 'store_manager'@'localhost';

-- Another user with limited access
CREATE USER 'store_viewer'@'localhost' IDENTIFIED BY 'viewonly';

-- Grant read-only access
GRANT SELECT ON bookstore.* TO 'store_viewer'@'localhost';
