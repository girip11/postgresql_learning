SELECT
  select_list
FROM
  table_name;

SELECT
  customer.first_name || ' ' || customer.last_name
FROM
  customer
LIMIT 10;

SELECT
  email,
  length(first_name) AS name_length
FROM
  customer
ORDER BY
  name_length DESC;

SELECT DISTINCT ON (staff_id)
  customer_id,
  staff_id
FROM
  payment
ORDER BY
  staff_id,
  customer_id;

SELECT
  *
FROM
  customer
WHERE
  first_name = 'Kelly';

SELECT
  *
FROM
  customer
WHERE
  first_name = 'Kelly'
  AND last_name = 'Torres';

SELECT
  customer_id
FROM
  rental
WHERE
  customer_id IN (
    SELECT
      customer_id
    FROM
      rental
    WHERE
      CAST(rental_date AS date) = '2005-05-24');

SELECT
  *
FROM
  film
WHERE
  language_id IN (
    SELECT
      language_id
    FROM
      LANGUAGE
    WHERE
      name IN ('English', 'French', 'Japanese'));

SELECT
  f.name_length
FROM
  customer
ORDER BY
  name_length
FROM (
  SELECT
    film_id,
    title AS name_length
  FROM
    customer
  ORDER BY
    name_length release_year,
    rating
  FROM
    film) f
  INNER JOIN film_category AS name_length
FROM
  customer
ORDER BY
  name_length.film_id
WHERE
  name_length
FROM
  customer
ORDER BY
  name_length ON f.film_id = name_length
FROM
  customer
ORDER BY
  name_length.category_id
  INNER JOIN film_actor AS fa ON f.film_id = fa.film_id
  INNER JOIN actor ON actor.actor_id = fa.actor_id;

SELECT DISTINCT
  f.title,
  rental_rate
FROM
  film
WHERE
  length BETWEEN 50 AND 100
UNION
SELECT
  title,
  l.name
FROM
  film AS f
  NATURAL JOIN (
    SELECT
      language_id,
      name
    FROM
      LANGUAGE) AS l;

SELECT
  'y'::boolean;

SELECT
  'n'::boolean;

SELECT
  payment.customer_id,
  amount
FROM
  payment
  INNER JOIN (
    SELECT
      customer_id,
      max(payment_date) AS latest_payment_date
    FROM
      payment
    GROUP BY
      customer_id
    ORDER BY
      customer_id) AS latest_payment ON payment.customer_id = latest_payment.customer_id
  AND payment.payment_date = latest_payment.latest_payment_date
ORDER BY
  customer_id;

SELECT DISTINCT ON (customer_id)
  customer_id,
  amount
FROM
  payment
ORDER BY
  customer_id,
  payment_date DESC;

INSERT INTO student (name, age, course)
  VALUES ('John', 23, DEFAULT);

UPDATE
  student
SET
  ta = DEFAULT
WHERE
  ta IS NULL;

SELECT
  CAST('HelloWorld' AS char(5));

SELECT
  CAST('1000.282' AS numeric(5, 1));

SELECT
  unnest(ARRAY[100.21, 'NAN']) AS numbers
ORDER BY
  numbers DESC;

CREATE TABLE table_name (
  joining_date date NOT NULL DEFAULT CURRENT_DATE
);

ALTER TABLE student
  ALTER COLUMN courses SET DEFAULT ARRAY[]::varchar[];

SELECT
  kvpair -> 'key1' AS value1
FROM
  test_table;

SELECT
  kvpair -> 'key1' AS value1
FROM
  test_table;

SELECT
  name,
  svals (kvpair)
FROM
  test_table;

SELECT
  hstore_to_json ('"key1" => 1, "key2" => 2'::hstore) AS j;

ALTER DOMAIN name
  ADD CHECK (value !~ '\s'
    AND length(value) <= 20);

ALTER DOMAIN public.name
  DROP CONSTRAINT name_check;
