# Hstore type

* `hstore` (remember as hashstore) type is available after creating the hstore extension.
* This is a map data type.

```Sql
CREATE EXTENSION hstore;
```

## Insert hstore data

* Map data is enclosed within single quotes. Keys and values are enclosed within double quotes.

```Sql
INSERT INTO test_table(name, kvpair)
VALUES (
  'Entry1',
  '"length" => 10,
  "width" => 20,
  "height" => 30,
  "weight" => 50'
),
(
  'Entry2',
  '"length" => 10,
  "width" => 5,
  "height" => 20,
  "weight" => 30'
);
```

## Query from hstore

```Sql
-- Select length of all entries
SELECT
  name,
  kvpair -> 'length' AS value1
FROM
  test_table;

-- need to cast the values inside the hstore
SELECT
  name,
  kvpair -> 'length' AS value1
FROM test_table
WHERE CAST(kvpair -> 'width' as INT)  >= 10;
```

* We can do operations like containsKey , contains list of keys

```Sql
-- contains a key using ?
SELECT
  name,
  kvpair -> 'length' AS value1
FROM test_table
WHERE
  kvpair ? 'width';

-- contains a list of keys using ?&
SELECT
  name,
  kvpair -> 'length' AS value1
FROM test_table
WHERE
  kvpair ?& ARRAY ['width', 'length'] ;

-- query if hstore contains exact key value pair using @>
SELECT
  name,
  kvpair -> 'length' AS value1
FROM test_table
WHERE
  kvpair @> 'height=>30'::hstore;
```

* Fetch all keys using `akeys` and `skeys`and fetch all values using `avals` and `svals`. `akeys` and `avals` return keys and values list as single row while `skeys` and `svals` convert each key or value in the list to its separate column.

```Sql
-- prints
--   name  |            akeys
--------+------------------------------
--  Entry1 | {width,height,length,weight}
--  Entry2 | {width,height,length,weight}
SELECT
  name,
  akeys(kvpair)
FROM
  test_table;

-- prints
--   name  | skeys  
--------+--------
--  Entry1 | width
--  Entry1 | height
--  Entry1 | length
--  Entry1 | weight
--  Entry2 | width
--  Entry2 | height
--  Entry2 | length
--  Entry2 | weight
SELECT
  name,
  skeys(kvpair)
FROM
  test_table;

-- prints
-- Entry1 | {20,30,10,50}
-- Entry2 | {5,20,10,30}
SELECT
  name,
  avals(kvpair)
FROM
  test_table;

-- prints
--  Entry1 | 20
--  Entry1 | 30
--  Entry1 | 10
--  Entry1 | 50
--  Entry2 | 5
--  Entry2 | 20
--  Entry2 | 10
--  Entry2 | 30
SELECT
  name,
  svals(kvpair)
FROM
  test_table;
```

## Update hstore values

```Sql
-- adding a key value pair
UPDATE books
SET attr = attr || '"freeshipping"=>"yes"' :: hstore;

-- modifying an existing key value pair
UPDATE books
SET attr = attr || '"freeshipping"=>"no"' :: hstore;

-- removing a key value pair
UPDATE books
SET attr = delete(attr, 'freeshipping');
```

## hstore functions

* `hstore_to_json()` converts hstore data to json.

```Sql
SELECT
  hstore_to_json ('"key1" => 1, "key2" => 2'::hstore) AS j;
```

* `each()` function converts each key value pair in to separate row.

```Sql
-- prints
--   name  |  key   | value
--------+--------+-------
--  Entry1 | width  | 20
--  Entry1 | height | 30
--  Entry1 | length | 10
--  Entry1 | weight | 50
--  Entry2 | width  | 5
--  Entry2 | height | 20
--  Entry2 | length | 10
--  Entry2 | weight | 30
SELECT
  name,
  (each(kvpair)).*
FROM
  test_table;
```
