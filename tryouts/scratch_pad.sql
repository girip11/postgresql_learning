SELECT
  f.title AS title,
  fc.category_id AS category_id
FROM
  film AS f
  INNER JOIN film_category AS fc ON f.film_id = fc.film_id
WHERE
  fc.category_id IN (
    SELECT
      category_id
    FROM
      category
    WHERE
      name LIKE 'C%');

SELECT
  1
FROM
  table_name
WHERE
  condition;

SELECT
  title
FROM
  film
WHERE
  EXISTS (
    SELECT
      i.film_id
    FROM
      rental AS r
      INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
    WHERE
      i.film_id = film.film_id FETCH FIRST 1 ROW ONLY);

ORDER BY
  title;

SELECT
  title,
  rental_rate
FROM
  film
WHERE
  rental_rate >= ANY ( SELECT DISTINCT
      rental_rate
    FROM
      film
    ORDER BY
      rental_rate DESC FETCH FIRST 2 ROWS ONLY)
ORDER BY
  rental_rate DESC,
  title ASC;

SELECT DISTINCT
  ROUND(AVG(rental_rate), 2) AS avg_rental_rate
FROM
  film
  INNER JOIN film_category AS fc USING (film_id)
GROUP BY
  fc.category_id;

SELECT
  CAST('100' AS INT);

SELECT
  (price - coalesce(discount, 0)) AS net_price
FROM
  items;

SELECT
  COALESCE(NULLIF (description, ''), 'NOT AVAILABLE')
FROM
  film;

SELECT
  SUM(
    CASE rental_rate
    WHEN 0.99 THEN
      1
    ELSE
      0
    END) AS cheap,
  SUM(
    CASE rental_rate
    WHEN 2.99 THEN
      1
    ELSE
      0
    END) AS moderate,
  SUM(
    CASE rental_rate
    WHEN 4.99 THEN
      1
    ELSE
      0
    END) AS luxury
FROM
  film;

WITH cte_rate_category AS (
  SELECT
    title,
    (
      CASE WHEN rental_rate = 0.99 THEN
        'CHEAP'
      WHEN rental_rate = 2.99 THEN
        'MODERATE'
      WHEN rental_rate = 4.99 THEN
        'LUXURY'
      ELSE
        NULL
      END) AS rate_category
  FROM
    film
)
SELECT
  title
FROM
  cte_rate_category
WHERE
  rate_category = 'LUXURY'
ORDER BY
  title;

WITH film_discount AS (
  SELECT
    film_id,
    (
      CASE rating
      WHEN 'G' THEN
        5
      WHEN 'NC-17' THEN
        7
      WHEN 'PG' THEN
        10
      WHEN 'PG-13' THEN
        15
      WHEN 'R' THEN
        25
      END) AS discount
  FROM
    film
)
SELECT
  f.title,
  fd.discount
FROM
  film AS f
  INNER JOIN film_discount AS fd USING (film_id)
ORDER BY
  discount DESC,
  title ASC;

CREATE DOMAIN constraint_string VARCHAR NOT NULL CHECK (value !~ '\s');

CREATE TABLE student (
  id serial PRIMARY KEY,
  name non_empty_string,
  gender non_empty_string,
);

INSERT INTO student (name, gender)
  VALUES ('John Doe', 'male'), ('Jane');

CREATE TYPE student_summary AS (
  name varchar,
  gender varchar
);

CREATE OR REPLACE FUNCTION get_student_summary (st_id int)
  RETURNS student_summary
  AS $$
  SELECT
    name,
    gender
  FROM
    student
  WHERE
    id = st_id;

$$
LANGUAGE sql;

SELECT
  *
FROM
  get_student_summary (5);

DO $block$
  << outer_block >>
DECLARE
  msg VARCHAR := 'Hello';
BEGIN
  raise notice 'Message is %', msg;
  DECLARE msg VARCHAR := 'Hi';
  BEGIN
    raise notice 'Inside the subblock, Message  is %', msg;
  raise notice 'Inside the subblock, Outer block message is %', outer_block.msg;
END;
END outer_block
$block$;

DO $$
  << block >>
DECLARE
  customer_id INTEGER := 1;
  first_name customer.first_name % TYPE := '';
BEGIN
  first_name := (
    SELECT
      customer.first_name
    FROM
      customer
    WHERE
      customer.customer_id = block.customer_id);
  CASE WHEN first_name IS NULL THEN
  RAISE exception 'First name of customer is null'
    USING MESSAGE = 'Customer not found';
ELSE
  RAISE NOTICE 'First Name of customer with id % is %', customer_id, first_name;
  END CASE;
  END block
$$;

DO $$
DECLARE
  ROW RECORD;
  query TEXT;
BEGIN
  query := $query$
  SELECT
    first_name || ' ' || last_name AS name
  FROM
    customer
  WHERE
    customer_id >= 10
    AND customer_id <= 50
  LIMIT $1 $query$;
  FOR ROW IN EXECUTE query
  USING 20 LOOP
    RAISE NOTICE 'Customer name: %', row.name;
  END LOOP;
END
$$;

CREATE OR REPLACE FUNCTION get_customer_name_from_id (id integer)
  RETURNS VARCHAR
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

CREATE OR REPLACE FUNCTION get_url (host varchar, port integer DEFAULT 80, protocol varchar DEFAULT 'http')
  RETURNS text
  LANGUAGE 'plpgsql'
  AS $$
BEGIN
  RETURN protocol || '://' || host || ':' || port;
END;
$$;

SELECT
  get_url ('www.example.com');

CREATE OR REPLACE FUNCTION get_films_for_category (category_name varchar)
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
      CAST(release_year AS integer) AS film_release_year
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

CREATE OR REPLACE FUNCTION get_actors (fid integer)
  RETURNS varchar[]
  LANGUAGE 'plpgsql'
  AS $$
DECLARE
  ROW record;
  actors varchar[];
BEGIN
  FOR ROW IN (
    SELECT
      a.first_name || ' ' || a.last_name AS actor_name
    FROM
      film_actor AS fc
      INNER JOIN actor AS a ON fc.actor_id = a.actor_id
    WHERE
      fc.film_id = fid)
  LOOP
    raise notice 'actor: %', row.actor_name;
    actors := actors || CAST(row.actor_name AS VARCHAR);
  END LOOP;
  RETURN actors;
END;
$$;

SELECT
  f.title,
  f.release_year,
  f.rating,
  c.name AS category,
  l.name AS
  LANGUAGE,
  get_actors (f.film_id) AS actors
FROM
  film AS f
  INNER JOIN
  LANGUAGE AS
  l ON f.language_id = l.language_id
  INNER JOIN film_category AS fc ON f.film_id = fc.film_id
  INNER JOIN category AS c ON fc.category_id = c.category_id;

SELECT
  *
FROM
  film_info
WHERE
  rating = 'PG';

SELECT
  *
FROM
  film_info
WHERE
  'Penelope Guiness' = ANY (actors);
