# Common Table Expressions (CTE)

## CTE Syntax

* CTE - temporary result set. Results stored as temp table in memory. As the name states, use it only when an expression repeats multiple times in a query, otherwise for simple queries using CTE leads to performance hit.

* **column_list** following CTE_NAME is optional. If no column list is provided, all the columns from the CTE query definition will be available.

* SQL_STATEMENT can be a `SELECT`, `INSERT`, `UPDATE` or `DELETE`

```SQL
WITH <CTE_NAME> (column_list) AS (
  CTE_query_definition
)
SQL_STATEMENT;
```

* CTE can be **used like a table or view** in a SQL_STATEMENT.

* CTE exists only during the execution of the SQL_STATEMENT

## Examples

* Simple CTE examples

```SQL
-- create a rate category on films based on the rental rate
-- select all the films which have rental category as "LUXURY"
WITH film_rate_category AS (
  SELECT
    title,
    (
      CASE
      WHEN rental_rate = 0.99 THEN
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
  film_rate_category
WHERE
  rate_category = 'LUXURY'
ORDER BY
  title;

```

* CTE example in join statement

```SQL
-- Applies discount based on film rating
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
-- For new rental rate after applying the discount we can use
-- custom postgresql function
```

## Uses

* Make complex join and subqueries **more readable**
* Helps create temporary tables with new fields (like discount) without having to modify the existing table schema. (In case we need to persist the query, then we should create a **postgresql view**)
* Can create recursive queries
* Can be used with [window functions](http://www.postgresqltutorial.com/postgresql-window-function/)

---

## References

* [Postgresql Common Table Expressions](http://www.postgresqltutorial.com/postgresql-cte/)
* [Postgresql recursive query](http://www.postgresqltutorial.com/postgresql-recursive-query/)
* [`WITH` queries](https://www.postgresql.org/docs/9.1/queries-with.html)
