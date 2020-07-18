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
VALUES ('{"name": "John", "age": 25}');
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

* `json_object_keys()` - set of keys of outermost JSON object as separate rows.

* `json_typeof()` function returns type of the outermost JSON value as a string. It can be number, boolean, null, object, array, and string.

```Sql
-- we will get two rows
-- key will be text while the value will be a JSON object
SELECT JSON_EACH('{"name": "John", "age": 25}');

-- both key and value will be text
SELECT JSON_EACH_TEXT('{"name": "John", "age": 25}');
```

## JSONB

* Data is stored in the binary form.
* `jsonb` supports indexing (`json` doesnot), faster to process compared to `json` type.
* JSON types incur heavy performance penalty when aggregating data(`COUNT`, `SUM`, `AVG` etc)

## Useful functions

* `jsonb_array_elements_text(jsonb_col -> 'array_field')` - Expands each array element in to its own row.

* Array contains using `@>`

```Sql
-- Notice the array is also type casted to jsonb
-- Both sides of arrays should be of jsonb type
SELECT '["Fiction", "Thriller", "Horror"]'::jsonb @> '["Fiction", "Horror"]'::jsonb;

SELECT data->'title' FROM books WHERE data->'genres' @> '["Fiction"]'::jsonb;

-- checking top level objects
SELECT '{"book": {"title": "War and Peace"}}'::jsonb @> '{"book": {}}'::jsonb;  
```

* Contains a key check is done similar to that of hstore using `?` operator.

```Sql
-- String exists as array element:
SELECT '["foo", "bar", "baz"]'::jsonb ? 'bar'; -- true

-- String exists as object key:
SELECT '{"foo": "bar"}'::jsonb ? 'foo'; -- true

-- Object values are not considered:
SELECT '{"foo": "bar"}'::jsonb ? 'bar';  -- yields false

-- As with containment, existence must match at the top level:
SELECT '{"foo": {"bar": "baz"}}'::jsonb ? 'bar'; -- yields false

-- A string is considered to exist if it matches a primitive JSON string:
SELECT '"foo"'::jsonb ? 'foo'; --true
```

## `jsonb` caveats

* Does not preserve leading and trailing whitespace within the json string.
* Does not preserve the order of the object keys
* `jsonb` does not store duplicate object keys (stores the last entry)

> The PostgreSQL documentation recommends that most applications should prefer to store JSON data as jsonb.

---

## References

* [Postgresql JSON functions and operators](https://www.postgresql.org/docs/current/functions-json.html)
* [PostgreSQL JSON](https://www.postgresqltutorial.com/postgresql-json/)
* [JSONB](https://www.compose.com/articles/faster-operations-with-the-jsonb-data-type-in-postgresql/)
* [jsonb Indexing](https://www.postgresql.org/docs/current/datatype-json.html#JSON-INDEXING)
