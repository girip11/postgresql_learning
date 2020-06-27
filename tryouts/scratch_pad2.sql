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
  f.title AS title
FROM (
  SELECT
    film_id,
    title,
    release_year,
    rating
  FROM
    film) f
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
  *
FROM (
  SELECT
    title,
    release_year,
    rental_rate
  FROM
    film
  WHERE
    rating != 'R') AS film
WHERE
  rental_rate >= (
    SELECT
      MAX(rental_rate)
    FROM
      film);

SELECT
  length(title) AS title_length
FROM
  film
WHERE
  title_length > 5;

SELECT
  count(title)
FROM
  film
WHERE
  release_year BETWEEN 1990 AND 2000
GROUP BY
  language_id;

SELECT
  rating,
  count(*)
FROM (
  SELECT
    f.title,
    f.length,
    f.rating
  FROM
    film AS f) AS films
WHERE
  films.length > 100
GROUP BY
  films.rating;

SELECT
  rating,
  count(*) AS movies_count
FROM (
  SELECT
    f.title,
    f.length,
    f.rating,
    f.rental_duration
  FROM
    film AS f) AS films
WHERE
  films.rental_duration > 5
GROUP BY
  films.rating
HAVING
  count(*) > 10;

SELECT
  m.director,
  sum(bo.domestic_sales) / 1000000 AS total_domestic_sales,
  sum() / 1000000 AS total_intl_sales
FROM
  movies AS m
  JOIN boxoffice AS bo ON m.id = bo.movie_id
GROUP BY
  m.director
ORDER BY
  total_domestic_sales DESC,
  total_intl_sales DESC;

SELECT
  *
FROM
  film
WHERE
  rating = 'R'
  AND film.length > 180
ORDER BY
  film.length DESC,
  rental_rate DESC
LIMIT 5 OFFSET 3;

-- OFFSET 3 ROWS FETCH FIRST 5 ROWS ONLY;
SELECT
  customer_id,
  SUM(amount) AS total_paid
FROM
  payment
GROUP BY
  customer_id
ORDER BY
  total_paid DESC;

SELECT
  language_id,
  rating,
  count(film_id) AS film_count
FROM
  film
GROUP BY
  language_id,
  rating
ORDER BY
  film_count DESC;

SELECT
  customer_id,
  sum(amount) AS amount_spent
FROM
  payment
GROUP BY
  customer_id
HAVING
  sum(amount) > 100
ORDER BY
  amount_spent DESC;

SELECT
  title,
  rental_rate
FROM
  film
WHERE
  rating = 'PG'
UNION
SELECT
  title,
  rental_rate
FROM
  film
WHERE
  length BETWEEN 50 AND 100
UNION
SELECT
  title,
  rental_rate
FROM
  film
WHERE
  title ILIKE '%love%'
ORDER BY
  rental_rate DESC;

SELECT
  title
FROM
  film
WHERE
  rating = 'G'
EXCEPT
SELECT
  title
FROM
  film
WHERE
  film.length > 100;

SELECT
  f.title,
  l.name
FROM
  film AS f
  INNER JOIN
  LANGUAGE AS
  l ON f.language_id = l.language_id;

SELECT
  c.name AS film_category,
  count(f.film_id) AS movies
FROM
  film AS f
  INNER JOIN film_category AS fc ON f.film_id = fc.film_id
  INNER JOIN category AS c ON c.category_id = fc.category_id
GROUP BY
  film_category
ORDER BY
  movies DESC;

SELECT
  c.name AS film_category,
  f.title,
  actor.first_name || ' ' || actor.last_name AS actor_name
FROM
  film AS f
  INNER JOIN film_category AS fc ON f.film_id = fc.film_id
  INNER JOIN category AS c ON c.category_id = fc.category_id
  INNER JOIN film_actor AS fa ON f.film_id = fa.film_id
  INNER JOIN actor ON actor.actor_id = fa.actor_id;

SELECT DISTINCT
  f.title
FROM
  film AS f
  LEFT OUTER JOIN (
  SELECT
    *
  FROM
    inventory
  WHERE
    store_id = 1) AS i ON f.film_id = i.film_id
WHERE
  i.film_id IS NULL;

SELECT DISTINCT
  c.customer_id
FROM
  payment AS p
  RIGHT OUTER JOIN customer AS c ON p.customer_id = c.customer_id
WHERE
  p.payment_id IS NOT NULL;

SELECT
  *
FROM ( SELECT DISTINCT
    name
  FROM
    category) AS cat
  CROSS JOIN ( SELECT DISTINCT
      name
    FROM
      LANGUAGE) AS lang;

SELECT
  f.title,
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
