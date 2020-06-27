# Arrays in postgresql

## DECLARATION

* Syntax: `text[]` for array of text. Similarly `integer[]` for array of integers.

```SQL
CREATE TABLE film (
  id serial PRIMARY KEY,
  name varchar(50) NOT NULL,
  categories text[]
);

-- we can also use curly braces
-- Notice that when you use curly braces, you use single quotes '
-- to wrap the array and double quotes " to wrap text array items.
INSERT INTO film (name, categories) values
( 'Action', ARRAY ['Action', 'Drama'] ),
( 'Kong', '{"Action", "Thriller"}' );

SELECT * FROM film;
```

## Query and search array data

* In postgresql, **array index starts from 1**

* `IN` works with either a list of values or with a subquery. To convert array to rows use `SELECT UNNEST(array)`

```SQL
-- selecting an array element using []
SELECT
  name,
  categories[1]
FROM
  film;

-- expand each entry in array column to a separate row using the unnest function
SELECT DISTINCT
  unnest(categories)
FROM
  film;

-- search using ANY to search for a value in the array
SELECT
  name
FROM
  film
WHERE
  'Action' = ANY (categories);

-- search using IN to search for a value in the array
SELECT
  name
FROM
  film
WHERE
  'Action' IN (SELECT unnest(categories));
```

## Updating the arrays

```Sql
-- updating individual entry
UPDATE contacts
SET phones [ 2 ] = '(408)-589-5843'
WHERE
  id = 3;
  
-- updating entire array
UPDATE contacts
SET phones = ARRAY ['(408)-589-5843']
WHERE
  id = 3;
```

---

## References

* [PostgreSQL Array](https://www.postgresqltutorial.com/postgresql-array/)
