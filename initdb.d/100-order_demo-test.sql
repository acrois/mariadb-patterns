USE order_demo;

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