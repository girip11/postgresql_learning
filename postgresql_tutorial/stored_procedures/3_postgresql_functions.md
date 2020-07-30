# Postgresql Functions

* [SQL functions vs Postgresql functions](https://stackoverflow.com/questions/24755468/difference-between-language-sql-and-language-plpgsql-in-postgresql-functions)

* Syntax of plpgsql function

```sql
CREATE OR REPLACE FUNCTION function_name(param1 type, param2 type) RETURNS type AS
$$
BEGIN
END;
$$
LANGUAGE language_name;
```

* Languages could be **plpgsql**,**sql** etc (or other language like python if the respective extension is installed)

* Postgresql supports function overloading as in C++, same function name with varying parameters.

```SQL
CREATE OR REPLACE FUNCTION get_customer_name (id integer)
  RETURNS varchar
  LANGUAGE 'plpgsql'
  AS $BODY$
BEGIN
  RETURN (
    SELECT
      first_name || ' ' || last_name AS name
    FROM
      customer
    WHERE
      customer_id = id);
END;
$BODY$;

CREATE OR REPLACE FUNCTION get_customer_name (email varchar)
  RETURNS varchar
  LANGUAGE 'plpgsql'
  AS $BODY$
DECLARE
  -- to resolve column name and variable name ambiguity in the query
  c_email ALIAS FOR email;  
BEGIN
  RETURN (
    SELECT
      c.first_name || ' ' || c.last_name AS name
    FROM
      customer as c
    WHERE
      c.email = c_email);
END;
$BODY$;

-- invoking the above functions
select get_customer_name(5);

select get_customer_name('elizabeth.brown@sakilacustomer.org');
```

* `\df` command in psql to view the created functions.
* By default (if no schema is specified explicitly), the functions get created in to the **public** schema.

* `DROP FUNCTION [ IF EXISTS ] <function_name>` deletes the function definition.

## `IN` parameters

* By default, the parameters are `IN` parameters

```sql
CREATE OR REPLACE sum(op1 numeric, op2 numeric)
RETURNS numeric
AS $BODY$
BEGIN
  RETURN op1 + op2;
END;
$BODY$
LANGUAGE 'pl/pgsql';

-- Following definition is equivalent to the below definition
CREATE OR REPLACE sum(IN op1 numeric, IN op2 numeric)
RETURNS numeric
AS $BODY$
BEGIN
  RETURN op1 + op2;
END;
$BODY$
LANGUAGE 'pl/pgsql';
```

## `OUT` parameters

* These parameters will be returned to the caller as part of the result.
* Useful when the function needs to return multiple values without defining a custom type (using `CREATE TYPE`)
* No explicit `RETURN` statement required.
* Caller doesnot pass these parameters

```SQL
CREATE OR REPLACE FUNCTION get_films_for_category(
IN category_name varchar,
OUT films text[])
AS $BODY$
DECLARE
  row RECORD;
  qry TEXT;
BEGIN
  RAISE NOTICE 'category: %', category_name;
  
  -- Uses common table expression
  qry := $query$
  WITH film_ids AS(
    SELECT film_id FROM film_category
    WHERE category_id = (
      SELECT category_id FROM category
      WHERE category.name = $1
    )
  )
  SELECT film.title as film_title FROM film
  WHERE film_id IN (SELECT film_id FROM film_ids)
 $query$;

 FOR row IN EXECUTE qry USING category_name
 LOOP
  RAISE NOTICE 'Movie: %', row.film_title;
  films = films || row.film_title::text;
 END LOOP;
END;
$BODY$
LANGUAGE 'plpgsql';

-- unnest converts or unpacks each array element in to a row
SELECT unnest(get_films_from_category('Action')) as film_title;
```

## `INOUT` parameters

* Caller can pass and access these parameters.
* Usually the function changes the parameter.

```sql
CREATE OR REPLACE FUNCTION to_uppercase(
  INOUT input text
)
AS $$
BEGIN
  input := UPPER(input);
END;
$$
LANGUAGE 'plpgsql';

SELECT to_uppercase('hello');
```

## `VARIADIC` parameters

* Can pass variable number of arguments with **all of the same data type**.

```SQL
CREATE OR REPLACE FUNCTION sum_avg(
    VARIADIC list NUMERIC[],
    OUT total NUMERIC,
    OUT average NUMERIC)
AS $$
BEGIN
    SELECT INTO total SUM(list[i])
    FROM generate_subscripts(list, 1) g(i);

    SELECT INTO average AVG(list[i])
    FROM generate_subscripts(list, 1) g(i);
END;
$$
LANGUAGE plpgsql;

-- Using loops
CREATE OR REPLACE FUNCTION sum_avg(
   VARIADIC list NUMERIC[],
   OUT total NUMERIC,
   OUT average NUMERIC)
AS $$
DECLARE
  e NUMERIC;
  n integer := 0;
BEGIN
  -- by default the value is NULL  
  total := 0.0;
  average := 0.0;

  -- New foreach syntax
  FOREACH e IN ARRAY list
  LOOP
    total := total + e;
    n := n + 1;
    raise notice 'value: %', e;
  END LOOP;

  average := total/n;
  RAISE NOTICE 'Total: %, average: %' , total, average;
END; $$
LANGUAGE plpgsql;

select * from sum_avg(10, 20, 30);
```

## Function overloading

* In postgresql, we can have same function name with varying parameter list. Depending on the parameter passed, appropriate function is invoked.

```SQL
-- function that returns a url for the input host
CREATE OR REPLACE FUNCTION get_url (host varchar)
RETURNS text
LANGUAGE 'plpgsql'
AS $$
  BEGIN
    RETURN get_url(host, 80, 'http');
  END;
$$;

-- function that accepts host, protocol and port to contruct the url
CREATE OR REPLACE FUNCTION get_url (
host varchar,
port integer,
protocol varchar)
RETURNS text
LANGUAGE 'plpgsql'
AS $$
  BEGIN
    RETURN protocol || '://' || host || ':' || port;
  END;
$$;

select get_url('example.com');
select get_url('example.com', 3000, 'https');
```

* Function with default parameters can help us save from defining multiple methods with varying arguments.

```sql
CREATE OR REPLACE FUNCTION get_url (
host varchar,
port integer DEFAULT 80,
protocol varchar DEFAULT 'http')
RETURNS text
LANGUAGE 'plpgsql'
AS $$
  BEGIN
    RETURN protocol || '://' || host || ':' || port;
  END;
$$;

SELECT get_url ('www.example.com');
SELECT get_url ('www.example.com', 3000, 'https');
```

## Function Returning A Table

* Use `RETURNS TABLE`. `RETURNS SETOF` also serves similar purpose, but there is a slight [difference between them](https://stackoverflow.com/questions/22423958/sql-function-return-type-table-vs-setof-records).

* Use `RETURNS SETOF` when we want to return list of [custom type](../16_datatypes/9_user_defined_datatypes.md) created.

* Returned table column types should match the table column data types declared to be returned.
  
```SQL
CREATE OR REPLACE FUNCTION get_films_for_category (
  category_name varchar)
  RETURNS TABLE (
    title varchar,
    film_release_year integer
  )
  AS $BODY$
  BEGIN
    RAISE NOTICE 'category: %', category_name;

    RETURN QUERY (
      SELECT
        f.title AS title,
        CAST(f.release_year AS integer) AS film_release_year
      FROM
        film_category AS fc
        INNER JOIN category AS c ON fc.category_id = c.category_id
          AND c.name = category_name
        INNER JOIN film AS f ON f.film_id = fc.film_id);
  END;
$BODY$
LANGUAGE 'plpgsql';

SELECT
  *
FROM
  get_films_for_category ('Action');
```

* Iterating over the query results and then returning a table. `RETURN NEXT` statement adds a row to the result set of the function.

```SQL
CREATE OR REPLACE FUNCTION get_films_for_category (
  category_name varchar)
  RETURNS TABLE (
    film_title varchar,
    film_release_year integer
  )
  AS $BODY$
  DECLARE
    row RECORD;
  BEGIN
    RAISE NOTICE 'category: %', category_name;

    FOR row IN (
      SELECT
        f.title AS title,
        f.release_year as release_year
      FROM
        film_category AS fc
        INNER JOIN category AS c ON fc.category_id = c.category_id
          AND c.name = category_name
        INNER JOIN film AS f ON f.film_id = fc.film_id)
      LOOP
        film_title := UPPER(row.title);
        film_release_year := row.release_year;
        RETURN NEXT;
      END LOOP;
  END;
$BODY$
LANGUAGE 'plpgsql';

SELECT
  *
FROM
  get_films_for_category ('Action');
```

---

## References

* [Postgresql SQL fucntions](https://www.postgresql.org/docs/12/xfunc-sql.html)
* [Postgresql functions](https://www.postgresqltutorial.com/postgresql-create-function/)
* [Function parameters](https://www.postgresqltutorial.com/postgresql-stored-procedures/)
* [Function Overloading](https://www.postgresqltutorial.com/plpgsql-function-overloading/)
* [Function That Returns A Table](https://www.postgresqltutorial.com/plpgsql-function-returns-a-table/)
