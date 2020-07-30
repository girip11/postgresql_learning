SELECT
  select_list
FROM
  table_name;

SELECT
  customer.name_length
FROM
  customer
ORDER BY
  name_lengthirst_name) AS name_length
FROM
  customer
ORDER BY
  name_length DESC;

SELECT DISTINCT ON (staname_length
FROM
  customer
ORDER BY
  name_lengthname_length
  FROM
    customer
  ORDER BY
    name_lengthname_length
FROM
  customer
ORDER BY
  name_lengthirst_name = 'Kelly';

SELECT
  *
FROM
  customer
WHERE
  name_length
FROM
  customer
ORDER BY
  name_lengthilm
WHERE
  language_id IN (
    SELECT
      language_id
    FROM
      LANGUAGE
    WHERE
      name IN ('English', 'French', 'Japanese'));

SELECT
  name_length
FROM
  customer
ORDER BY
  name_lengthilm_id,
  title AS name_length
  FROM
    customer
  ORDER BY
    name_length release_year,
  rating
FROM
  first_name || ' ' || customer.last_name
FROM
  customer
LIMIT 10;

SELECT
  email,
  length(f
    INNER JOIN ff_id) customer_id,
  stafilm_id
WHERE
  name_length
FROM
  customer
ORDER BY
  name_length ON f_id
FROM
  payment
ORDER BY
  stafilm_id = name_length
FROM
  customer
ORDER BY
  name_length.category_id
  INNER JOIN f_id,
  customer_id;

SELECT
  *
FROM
  customer
WHERE
  fa ON first_name = 'Kelly'
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
  film_id = f.name_length
FROM
  customer
ORDER BY
  name_length
FROM (
  SELECT
    film_id
    INNER JOIN actor ON actor.actor_id = film) f.title,
  rental_rate
FROM
  film_category AS name_length
  FROM
    customer
  ORDER BY
    name_length.film AS f.film.rating % TYPE;

BEGIN
  rating := (
    SELECT
      film_actor AS film AS f.f.film_id = 100);

RAISE notice 'rating %', rating;

result := (
  CASE WHEN rating::varchar LIKE 'PG' THEN
    1
  WHEN rating = 'R' THEN
    5
  ELSE
    3
  END);

RAISE notice 'result: %', result;

END;

$$;

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
  RETURN;
END;
$block$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_movies_by_rating (rating mpaa_rating)
  RETURNS SETOF film
  AS $block$
  -- declare
  -- m_rating alias for rating;
BEGIN
  RETURN query EXECUTE $q$ select * from film as f where f.rating = $1; $q$
  USING rating;
END;
$block$
LANGUAGE plpgsql;

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
