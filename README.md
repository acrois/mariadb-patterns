# MariaDB Examples

Demonstrations of MariaDB patterns.

## Orders

### Discrete Invoice Items with Quantity

Demonstrates discrete records (`order_items`) while supporting inserting a record with a count (`order_items_qty`.`quantity`).

Combines `BLACKHOLE` engine with a `BEFORE INSERT` trigger to transparently insert `order_items_qty`.`quantity` number of records into `order_items`.

Note that `order_items_qty` should match the schema of `order_items` with one new field, `order_items_qty.quantity`.

- [001-order_demo-init.sql](./initdb.d/001-order_demo-init.sql)
- [002-order_demo-quantity.sql](./initdb.d/002-order_demo-quantity.sql)
- [100-order_demo-test.sql](./initdb.d/100-order_demo-test.sql)

## Development

### Clone

```sh
git clone https://github.com/acrois/mariadb-examples
```

### Start

```sh
docker compose up -d
```

### Cleanup

```sh
docker compose down --remove-orphans --rmi local -v
```