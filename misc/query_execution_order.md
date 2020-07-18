# Query order execution

## 1. FROMS and JOINS

* The FROM clause, and subsequent JOINs are first executed to determine the total working set of data that is being queried.

* This includes [**subqueries**](../postgresql_tutorial/8_subquery.md) in this clause

```Sql
-- First subquery on FROM is executed
-- followed by join and then
-- where clause is executed on the result of join.
SELECT
  f.title AS film_title,
  f.rating
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
```

## 2. `WHERE` clause

* Each of the constraints can only access columns directly from the tables requested in the FROM clause(as well as the JOIN tables)

```Sql
-- First subquery inside the FROM clause
-- next the where clause is executed
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
```

* Aliases in the SELECT part of the query are not accessible.

```Sql
-- This query will raise error
-- column "title_length" does not exist
SELECT
  length(title) AS title_length
FROM
  film
WHERE
  title_length > 5;
```

## 3. `GROUP BY` clause

* After `WHERE` constraints are applied, `GROUP BY` clause is executed.

```Sql
-- subquery here is used just for demostrating the order
-- After the where clause is executed, group by gets executed on
-- the filtered data

-- select count of movies by category
-- whose running length is more than 100 minutes
SELECT
  rating,
  count(*) AS movies_count
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
```

## 4. `HAVING` clause

* If the query has a `GROUP BY` clause, then the constraints in the `HAVING` clause are then applied to the grouped rows, discard the grouped rows that don't satisfy the constraint.

* Like the `WHERE` clause, aliases in the `SELECT` step are also not accessible from this step.

```Sql
-- select movies count by rating where
-- rental duration of movies is more than 5 days
-- and the number of movies per rating category
-- should be more than 50
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
  count(*) > 50;
-- Here I cannot replace count(*) with alias movies_count
```

## 5. `SELECT`

* After the `HAVING` is computed, the `count()` function is computed as the alias `movies_count` is available to subsequent steps like `ORDER BY`.

```Sql
-- select movies count by rating where
-- rental duration of movies is more than 5 days
-- and the number of movies per rating category
-- should be more than 50
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
  count(*) > 50;
-- Here I cannot replace count(*) with alias movies_count
```

## 6. `DISTINCT`

* Rows with duplicate values on the distinct columns are discarded

```Sql
SELECT
  distinct release_year
FROM
  film;
```

## 7. `ORDER BY`

* Since all the expressions in the SELECT part of the query have been computed, you can reference aliases in this clause.

```Sql
-- select movies count by rating where
-- rental duration of movies is more than 5 days
-- and the number of movies per rating category
-- should be more than 50
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
  count(*) > 50
ORDER BY
  movies_count DESC;
-- HAVING cannot replace count(*) with alias movies_count
-- But alias can be used in order by

```

## 8. `LIMIT/OFFSET`

* After all the computations, we can limit the rows to be fetched using `LIMIT` and discard those rows which fall outside the `OFFSET`(if provided).

---

## References

* [Query order execution](https://sqlbolt.com/lesson/select_queries_order_of_execution)
