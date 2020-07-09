# PostgreSQL JSON

* We can define a column in Postgresql table with json data type

```Sql
CREATE TABLE <table_name>(
  <col_name> json NOT NULL
);
```

## Insert JSON value

```Sql
INSERT INTO <table_name> (json_col)
VALUES ('{"name": "John", "age": 25');
```

## Querying JSON data

* `->` - returns JSON object field by key
* `->>` - returns JSON object field by text

* If we misspell the key in the JSON, we might get zero rows. Always check if the json keys are correctly spelled.

```Sql
SELECT <json_col> FROM <table_name>;

-- orders table with info column
-- '{ "customer": "Lily Bush", "items": {"product": "Diaper","qty": 24}}'
-- to get the customer name
SELECT info -> 'customer' as customer_name FROM orders;

-- select some key from nested object
SELECT info -> 'items' ->> 'product' as product_name FROM orders;

-- select some key from nested object using where
SELECT info -> 'items' ->> 'product' as product_name
FROM orders
WHERE CAST(info -> 'items' ->> 'qty' as INT) >= 5;
```

## Aggregate functions

* `MIN`, `MAX`, `SUM`, `AVG` can all be applied to numerical columns in the json data.

```Sql
SELECT MAX(CAST(info -> 'items' ->> 'qty' as INT)) as max_product_qty
FROM orders;
```

## JSON functions

* `json_each()` - expands the outermost JSON object into a set of key-value pairs

* `json_each_text()` - key value pairs as text of outermost JSON.

* `json_object_keys()` - set of keys of outermost JSON object.

* `json_typeof()` function returns type of the outermost JSON value as a string. It can be number, boolean, null, object, array, and string.

```Sql
-- we will get two rows
-- key will be text while the value will be a JSON object
SELECT JSON_EACH('{"name": "John", "age": 25}');

-- both key and value will be text
SELECT JSON_EACH_TEXT('{"name": "John", "age": 25}');
```

## JSONB

* Binary representation of JSON data.

---

## References

* [Postgresql JSON functions](https://www.postgresql.org/docs/current/functions-json.html)
* [PostgreSQL JSON](https://www.postgresqltutorial.com/postgresql-json/)
* [JSONB](https://www.compose.com/articles/faster-operations-with-the-jsonb-data-type-in-postgresql/)
