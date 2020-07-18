# Grouping Data

## `GROUP BY` clause

> The `GROUP BY` clause divides the rows returned from the `SELECT` statement into groups. For each group, you can apply an aggregate function e.g.,  `SUM()` to calculate the sum of items or `COUNT()` to get the number of items in the groups.

```Sql
-- Syntax
-- we can group by multiple columns
-- groupby can follow from and where clause
-- can also follow join clause
SELECT
  column_1,
  column_2,
  aggregate_function(column_3)
FROM
  table_name
GROUP BY
  column_1,
  column_2;
```

* Examples

```Sql
-- using SUM function
SELECT
  customer_id,
  SUM(amount) AS total_paid
FROM
  payment
GROUP BY
  customer_id
ORDER BY
  total_paid DESC;

-- groupby on multiple columns
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


-- using the date function to convert timestamp to date
SELECT
  DATE(payment_date) AS paid_date,
  payment_date
FROM
  payment;

-- Using date function to get the key for group by
-- we can also cast a timestamp to date using the cast function
SELECT
  DATE(payment_date) AS paid_date,
  SUM(amount) AS total_amount
FROM
  payment
GROUP BY
  DATE(payment_date)
ORDER BY
  total_amount DESC;
```

## `HAVING` clause

> We often use the `HAVING` clause in conjunction with the `GROUP BY` clause to filter group rows that do not satisfy a specified condition.

```Sql
-- syntax
SELECT
  column_1,
  aggregate_function (column_2)
FROM
  tbl_name
GROUP BY
  column_1
HAVING
  condition;
```

**NOTE**: The `HAVING` clause sets the condition for group rows created by the `GROUP BY` clause after the `GROUP BY` clause applies while the `WHERE` clause sets the condition for individual rows before `GROUP BY` clause applies. -[Query execution order](../misc/query_execution_order.md)

```Sql
SELECT
  customer_id,
  SUM(amount) AS amount_spent
FROM
  payment
GROUP BY
  customer_id
HAVING
  SUM(amount) > 100
ORDER BY
  amount_spent DESC;
```

**NOTE(POSTGRESQL SPECIFIC)**: In PostgreSQL, you can use the `HAVING` clause without the `GROUP BY` clause. In this case, the `HAVING` clause will turn the query into a single group. In addition, the `SELECT` list and `HAVING` clause can only refer to columns from within aggregate functions. This kind of query returns a single row if the condition in the `HAVING` clause is true or zero row if it is false.

---

## References

* [Group By clause](https://www.postgresqltutorial.com/postgresql-group-by/)
* [Having clause](https://www.postgresqltutorial.com/postgresql-having/)
