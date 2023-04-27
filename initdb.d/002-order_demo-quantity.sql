USE order_demo;

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