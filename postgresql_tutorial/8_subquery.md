# Postgresql Subquery

Subquery - query nested inside another query

* Subquery returning a single value

```SQL
-- find all films with maximum rental rate
SELECT
  title rental_rate
FROM
  film
WHERE
  rental_rate >= (
    SELECT
      MAX(rental_rate)
    FROM
      film);
```

## Subquery with `IN` operator

* Subquery returning a list of values

```SQL
-- match movies belonging to category names starting with C
SELECT
  f.title AS title,
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
```

## Subquery with `ANY` operator

* Syntax - `expression operator ANY (subquery)`

* `SOME` is a synonym for `ANY`

* Operator can be any of the comparison operators - `=`, `!=`, `<`, `<=`, `>` and `>=`

* Subquery must return result set containing **exactly one column**.

```SQL
-- select top 2 rental amount movies

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
```

* `ANY` with `=` is same as using `IN` operator, while `ANY` with `!=` is not the same as using `NOT IN` operator (`NOT IN` will be equivalent to  `!= ALL`).

**NOTE**: `x != ANY (a,b,c)` is equivalent to `x != a OR != b OR x != c`, while `x NOT IN (a,b,c)` is equivalent to `x != a AND x != b AND x != c`

```SQL
-- observe the difference between != ANY and NOT IN
SELECT
  title,
  rental_rate
FROM
  film
WHERE
  rental_rate != ANY ( SELECT DISTINCT
      rental_rate
    FROM
      film
    ORDER BY
      rental_rate DESC FETCH FIRST 2 ROWS ONLY)
ORDER BY
  rental_rate DESC,
  title ASC;

-- above query but using NOT IN
SELECT
  title,
  rental_rate
FROM
  film
WHERE
  rental_rate NOT IN ( SELECT DISTINCT
      rental_rate
    FROM
      film
    ORDER BY
      rental_rate DESC FETCH FIRST 2 ROWS ONLY)
ORDER BY
  rental_rate DESC,
  title ASC;
```

## Subquery with `ALL` operator

* Syntax - `expression operator ALL (subquery)`

* Operator can be any of the comparison operators - `=`, `!=`, `<`, `<=`, `>` and `>=`

* Subquery must return result set containing **exactly one column**.

```SQL
-- select movies with rental rates higher than the
-- average rental rate of all the film categories
SELECT
  title,
  rental_rate
FROM
  film
WHERE
  rental_rate > ALL (SELECT DISTINCT
    ROUND(AVG(rental_rate), 2) AS avg_rental_rate
  FROM
    film
    INNER JOIN film_category AS fc USING (film_id)
  GROUP BY
    fc.category_id)
ORDER BY
  rental_rate DESC,
  title ASC;
```

* `NOT IN` will be equivalent to  `!= ALL`.

```SQL
-- observe the similarity between != ALL and NOT IN
-- Select all the movies whose rental rate is not in the
-- top 2 rental rates
SELECT
  title,
  rental_rate
FROM
  film
WHERE
  rental_rate != ALL ( SELECT DISTINCT
      rental_rate
    FROM
      film
    ORDER BY
      rental_rate DESC FETCH FIRST 2 ROWS ONLY)
ORDER BY
  rental_rate DESC,
  title ASC;

SELECT
  title,
  rental_rate
FROM
  film
WHERE
  rental_rate NOT IN ( SELECT DISTINCT
      rental_rate
    FROM
      film
    ORDER BY
      rental_rate DESC FETCH FIRST 2 ROWS ONLY)
ORDER BY
  rental_rate DESC,
  title ASC;
```

## Subquery with `EXISTS` operator

* `EXISTS (subquery)`. Returns true if the subquery returns atleast 1 row, otherwise returns false.

* Convention is to use `EXISTS (SELECT 1 FROM table_name WHERE condition);` as query format for subquery passed to `EXISTS`.

* We can also use `FETCH` or `LIMIT` to return only one row for the subquery result

```SQL
-- To find the movies which are present in inventory
-- and have been rented out atleast once
SELECT
 DISTINCT film.title as title
FROM
  film
INNER JOIN
  inventory USING(film_id)
WHERE
  EXISTS (
    SELECT
      i.film_id
    FROM
      rental AS r
      INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
    WHERE
      i.film_id = film.film_id
    FETCH FIRST 1 ROW ONLY)
ORDER BY
  title;
```

* `EXISTS` returns true even if the subquery returns `NULL`

```SQL
SELECT
  title
FROM
  film
WHERE
  EXISTS (SELECT NULL)
ORDER BY
  title;
```

* `NOT EXISTS` returns true when the subquery returns no rows.

```SQL
-- select all the  movies that are in the inventory and
--  that never have been rented atleast once
SELECT
  DISTINCT film.title as title
FROM
  film
INNER JOIN
  inventory USING(film_id)
WHERE
  NOT EXISTS (
    SELECT
      i.film_id
    FROM
      inventory AS i
      INNER JOIN  rental AS r ON r.inventory_id = i.inventory_id
    WHERE
      i.film_id = film.film_id
      FETCH FIRST 1 ROW ONLY)
ORDER BY
  title;
```

---

## References

* [Postgresql Subquery](http://www.postgresqltutorial.com/postgresql-subquery/)

* [Postgresql `ANY`](http://www.postgresqltutorial.com/postgresql-any/)
* [Postgresql `ALL`](http://www.postgresqltutorial.com/postgresql-all/)
* [Postgresql `EXISTS`](http://www.postgresqltutorial.com/postgresql-exists/)
