# More control structures in Postgresql

## Returning from a function

### `RETURN NEXT`

```Sql
```

### `RETURN QUERY`

```Sql
CREATE OR REPLACE FUNCTION get_movies_by_rating (rating mpaa_rating)
  RETURNS SETOF film
  AS $block$
DECLARE
  m_rating alias FOR rating;
BEGIN
  RETURN query (
    SELECT
      * FROM film AS f
    WHERE
      f.rating = m_rating);

  -- optional return at the end
  RETURN;
END;
$block$
LANGUAGE plpgsql;
```

### `RETURN QUERY EXECUTE query_text [USING expr1 ...]`

```Sql
CREATE OR REPLACE FUNCTION get_movies_by_rating (rating mpaa_rating)
RETURNS SETOF film
AS $block$
BEGIN
  RETURN QUERY EXECUTE $q$ select * from film as f where f.rating = $1; $q$
  USING rating;
END;
$block$
LANGUAGE plpgsql;
```

## Returning a set of rows from a function

### `RETURNS SETOF`

* `SETOF` can be used with an existing table name to return rows of that table, or custom type to return rows of the custom type..

```Sql
-- returning rows of table
CREATE OR REPLACE FUNCTION get_movies_by_rating (rating mpaa_rating)
RETURNS SETOF film
AS $block$
BEGIN
  RETURN QUERY EXECUTE $q$ select * from film as f where f.rating = $1; $q$
  USING rating;
END;
$block$
LANGUAGE plpgsql;

-- returning rows of custom type customer_summary
-- CREATE TYPE public.customer_summary AS
-- (
--  c_id integer,
--  full_name text,
--  email character varying
-- );
-- Note the column types returned should match the data types of the
-- attributes in the custom type

CREATE OR REPLACE FUNCTION get_customer_summaries2 (spend numeric)
  RETURNS SETOF customer_summary
  AS $block$
DECLARE
  query_text text;
BEGIN
  query_text := $q$
  select customer_id,
  first_name || ' ' || last_name as full_name,
  email
  from customer
  where customer_id in
    (select customer_id
    from payment
    group by customer_id
    having sum(amount) >= $1);
$q$;
  RETURN query EXECUTE query_text
  USING spend;
END;
$block$
LANGUAGE plpgsql;
```

### `RETURNS TABLE`

```Sql
CREATE OR REPLACE FUNCTION get_customer_summaries (spend numeric)
  RETURNS TABLE (
    customer_id integer,
    full_name text,
    email varchar
  )
  AS $block$
DECLARE
  query_text text;
BEGIN
  query_text := $q$
  select customer_id,
  first_name || ' ' || last_name as full_name,
  email
  from customer
  where customer_id in
    (select customer_id
    from payment
    group by customer_id
    having sum(amount) >= $1);
$q$;

  RETURN query EXECUTE query_text
  USING spend;
END;
$block$
LANGUAGE plpgsql;
```

## `EXECUTE` vs `PERFORM`

---

## References

* [Plpgsql Control Structures](https://www.postgresql.org/docs/9.1/plpgsql-control-structures.html)
