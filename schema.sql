-- Schema for the grocery_store database, reverse-engineered from backend/*_dao.py
-- (the upstream repo ships no schema of its own).

CREATE TABLE IF NOT EXISTS uom (
  uom_id INT AUTO_INCREMENT PRIMARY KEY,
  uom_name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  uom_id INT NOT NULL,
  price_per_unit DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (uom_id) REFERENCES uom(uom_id)
);

CREATE TABLE IF NOT EXISTS orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(255) NOT NULL,
  total DECIMAL(10, 2) NOT NULL,
  datetime DATETIME NOT NULL
);

CREATE TABLE IF NOT EXISTS order_details (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity DECIMAL(10, 2) NOT NULL,
  total_price DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO uom (uom_name)
SELECT * FROM (SELECT 'kgs') AS tmp
WHERE NOT EXISTS (SELECT 1 FROM uom WHERE uom_name = 'kgs') LIMIT 1;

INSERT INTO uom (uom_name)
SELECT * FROM (SELECT 'pieces') AS tmp
WHERE NOT EXISTS (SELECT 1 FROM uom WHERE uom_name = 'pieces') LIMIT 1;

INSERT INTO uom (uom_name)
SELECT * FROM (SELECT 'litres') AS tmp
WHERE NOT EXISTS (SELECT 1 FROM uom WHERE uom_name = 'litres') LIMIT 1;

INSERT INTO uom (uom_name)
SELECT * FROM (SELECT 'dozen') AS tmp
WHERE NOT EXISTS (SELECT 1 FROM uom WHERE uom_name = 'dozen') LIMIT 1;
