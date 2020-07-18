# UNION, INTERSECT and EXCEPT set operations

## `UNION` operator

* The `UNION` operator combines result sets of **two or more** `SELECT` statements into a single result set

```Sql
-- This is just to explain the syntax of union operator
-- The same query can be optimized with WHERE in combination with logical operators
-- rating = 'PG' OR film.length BETWEEN 50 AND 100 OR title ILIKE '%love%'
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
  film.length BETWEEN 50 AND 100
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
```

* **Rules** - All select statements should return same number of columns and
their data types should be compatible as well.

* Duplicate rows are removed.

* `UNION ALL` - keeps the duplicate rows.

## `INTERSECT` operator

* Same rules of union operator applies here as well.

```Sql
-- (rating = 'PG') AND (film.length BETWEEN 50 AND 100) AND (title ILIKE '%love%')
SELECT
  title,
  rental_rate
FROM
  film
WHERE
  rating = 'PG'
INTERSECT
SELECT
  title,
  rental_rate
FROM
  film
WHERE
  film.length BETWEEN 50 AND 100
INTERSECT
SELECT
  title,
  rental_rate
FROM
  film
WHERE
  title ILIKE '%love%'
ORDER BY
  rental_rate DESC;
```

## `EXCEPT` operator

> The EXCEPT operator **returns distinct rows** from the first (left) query that are not in the output of the second (right) query.

* Rules of union operator applies to this operator too.

* Same as **set difference**. `A(left table) - B(right table)` returns element exclusive to A.

```Sql
-- movies that have G rating and are less than 100 minutes in length
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
```

---

## References

* [UNION operator](https://www.postgresqltutorial.com/postgresql-union/)
* [INTERSECT operator](https://www.postgresqltutorial.com/postgresql-intersect/)
* [EXCEPT operator](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-except/)
