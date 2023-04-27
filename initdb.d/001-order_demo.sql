CREATE DATABASE IF NOT EXISTS order_demo;
USE order_demo;

# Base table for products.
CREATE TABLE IF NOT EXISTS product (
	id INT UNSIGNED AUTO_INCREMENT NOT NULL,
	name VARCHAR(256) NOT NULL,
	created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
	PRIMARY KEY (id),
	UNIQUE (`name`)
)
ENGINE=InnoDB
;

# Base table for orders.
CREATE TABLE IF NOT EXISTS `order` (
	id INT UNSIGNED AUTO_INCREMENT NOT NULL,
	created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
	PRIMARY KEY (id)
)
ENGINE=InnoDB
;

# Base table for order items.
CREATE TABLE IF NOT EXISTS order_items (
	id INT UNSIGNED AUTO_INCREMENT NOT NULL,
	order_id INT UNSIGNED NOT NULL,
	product_id INT UNSIGNED NOT NULL,
	created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
	PRIMARY KEY (id),
  	CONSTRAINT `oi_order_FK` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  	CONSTRAINT `oi_product_FK` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)
ENGINE=InnoDB
;

# Blackhole table for our order items with quantity trigger.
CREATE OR REPLACE TABLE order_items_qty (
	order_id INT UNSIGNED NOT NULL,
	product_id INT UNSIGNED NOT NULL,
	quantity INT UNSIGNED NOT NULL
)
ENGINE=BLACKHOLE
;

# Actual insert into individual order items.
DELIMITER $
CREATE OR REPLACE TRIGGER order_item_split BEFORE INSERT ON order_items_qty
FOR EACH ROW 
BEGIN
	INSERT INTO order_items
		(order_id, product_id)
		SELECT
			NEW.order_id,
			NEW.product_id
		FROM seq_1_to_10000000
		WHERE seq <= NEW.quantity
	;
END $
DELIMITER ;

# Create a placeholder product (test quantity)
INSERT INTO `product` (
	`name` 
) VALUES (
	'harry potter'
) ON DUPLICATE KEY UPDATE
	id = LAST_INSERT_ID(id),
	`name` = VALUES(`name`)
;
SET @pid := LAST_INSERT_ID();

# Single quantity
INSERT INTO `product` (
	`name` 
) VALUES (
	'norris putter'
) ON DUPLICATE KEY UPDATE
	id = LAST_INSERT_ID(id),
	`name` = VALUES(`name`)
;
SET @pid2 := LAST_INSERT_ID(); 

SELECT * FROM product;

# Create a new order
INSERT INTO `order` () VALUES ();
SET @oid := LAST_INSERT_ID();
SET @qty := 5;

SELECT @pid, @oid, @qty;
SELECT * FROM `order`;

# Create a quantity of order items.
INSERT INTO order_items_qty (
	order_id,
	product_id,
	quantity
) VALUES (
	@oid,
	@pid,
	@qty
);

# Create a single order item.
INSERT INTO order_items (order_id, product_id) VALUES (@oid, @pid2);

# See line items
SELECT * FROM order_items WHERE order_id = @oid;