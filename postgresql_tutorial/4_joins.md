# Joins

* Join condition can be any simple or complex(combined using logical operators) boolean condition.

```Sql
-- syntax
SELECT
  column_list
FROM
    left_table AS lt
[
INNER |
LEFT | LEFT OUTER |
RIGHT | RIGHT OUTER |
FULL | FULL OUTER |
CROSS |
NATURAL [INNER | LEFT | RIGHT]] JOIN right_table AS rt ON (join_condition);
```

## Inner join

* Rows that satisfy the join condition are fetched from both left and right tables and combined to a single row.

```Sql
SELECT
  f.title,
  l.name
FROM
  film AS f
  INNER JOIN language AS l ON f.language_id = l.language_id;
```

* We can do join on 3 or more tables as well

```Sql
-- join involving 3 tables
SELECT
  c.name AS film_category,
  COUNT(f.film_id) AS movies
FROM
  film AS f
  INNER JOIN film_category AS fc ON f.film_id = fc.film_id
  INNER JOIN category AS c ON c.category_id = fc.category_id
GROUP BY
  film_category
ORDER BY
  movies DESC;

-- more complex join
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
```

## Left outer join

* Rows that satisfy the join condition as well as that don't satisfy are fetched from only the left table. For the rows that don't satisfy the join condition, columns of right side table will contain **NULL**

```Sql
-- movies that are not in store 1
-- I can use `LEFT` or `LEFT OUTER`
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
```

## Right outer join

```Sql
-- customer who signed up but never rented any movie
SELECT DISTINCT
  c.customer_id
FROM
  payment AS p
  RIGHT OUTER JOIN customer AS c ON p.customer_id = c.customer_id
WHERE
  p.payment_id IS NULL;
```

## Full outer join

* Better example found at [postgresqltutorial.com](https://www.postgresqltutorial.com/postgresql-full-outer-join/)

```Sql
-- select payments that don't have a customer
-- as well as customers who don't have a payment entry against them
SELECT *
FROM
  payment AS p
  FULL OUTER JOIN customer AS c ON p.customer_id = c.customer_id
WHERE
  p.payment_id IS NULL OR c.customer_id IS NULL;
```

## Self join

> A self-join is a query in which a table is joined to itself. Self-joins are useful for comparing values in a column of rows within the same table.
> To form a self-join, you specify the same table twice with different aliases, set up the comparison, and eliminate cases where a value would be equal to itself.

```Sql
-- syntax
SELECT column_list
FROM A a1
INNER JOIN A b1 ON join_predicate;

-- Finds all pair of films that have the same length.
SELECT
    f1.title,
    f2.title,
    f1.length
FROM
    film f1
INNER JOIN film f2 ON f1.film_id != f2.film_id AND f1.length = f2.length;
-- We can also do the above query using cross join
-- and filtering out same film ids. Use Explain statement to see
-- the performance of self vs cross join.
-- SELECT
--     f1.title,
--     f2.title,
--     f1.length
-- FROM
--     film f1
-- CROSS JOIN film f2
-- where f1.film_id != f2.film_id and f1. length = f2. length;
```

## Cross Join

* **Cartesian product** of all the rows in both the tables.
* Huge resulting set. Causes performance issues. Use it sparsely.

```Sql
-- cross join between movie categories and languages
SELECT
  *
FROM (SELECT DISTINCT
    name
  FROM
    category) AS cat
CROSS JOIN ( SELECT DISTINCT
      name
    FROM
      language) AS lang
```

## Natural join

* A natural join is a join that creates an implicit join based on the same column names in the joined tables.

* **Recommendation is to avoid natural joins** as it may lead to unexpected result. Suppose a new column with same name added to a table in join statement. Now we will have the natural join trying to join on the new column name as well.

* With natural join, we can perform **left, right and inner** joins.

```Sql
-- inner join using language_id
-- since the language_id is the common column among both the tables
-- I intentionally removed last_update from language
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
      language) AS l;
```

* If `*` is used to select all the columns from natural join, columns with common names will be present only once. This is not the case with other joins when used with **ON** condition.

```Sql
-- The result set will contain two language_id columns
SELECT *
FROM
  film AS f
  INNER JOIN
  LANGUAGE AS
  l ON f.language_id = l.language_id;

-- with the help of USING keyword, we can achieve dedup of common columns
-- below result set will contain only one language_id column
SELECT
*
FROM
  film as f
  INNER JOIN language  as l USING (language_id);
```

---

## References

* [Postgresql joins](https://www.postgresqltutorial.com/postgresql-joins/)
