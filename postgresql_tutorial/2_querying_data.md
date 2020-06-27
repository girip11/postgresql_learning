# Select Statement

```Sql
SELECT
  select_list
FROM
  table_name;

-- To select all the columns in the table use *
-- Not recommended in production systems due to
-- to volume of the data fetched
SELECT
  *
FROM
  table_name;
```

## Select statements with expressions

* `||` - string concatenation operator

```Sql
-- using string concatenation to form a new column name
-- we can also name the new column using the AS keyword
SELECT
  first_name || ' ' || last_name AS full_name
FROM
  customer
LIMIT 10;

-- Inferring the column name using the table name
-- will be helpful in join scenarios
SELECT
  customer.first_name || ' ' || customer.last_name AS full_name
FROM
  customer
LIMIT 10;
```

* We can also use constant expressions

```Sql
SELECT 5 * 3 AS result;
```

## `ORDER BY` clause

* Default ordering is **asc** (ascending order)

* We can also sort based on multiple columns

**NOTE**: Notice that the SQL standard only allows you to sort rows based on the columns that appear in the `SELECT` clause. However, **PostgreSQL** allows you to sort rows based on the columns that even does not appear in the selection list.

> It is good practice to follow SQL Standard to make your code portable and adapt to the changes that may potentially happen in the next release of PostgreSQL.

```Sql
-- Expressions as columns for ordering
SELECT
  email
FROM
  customer
ORDER BY
  length(first_name) DESC;

-- Computed expressions can be used in the column for ordering
SELECT
  email,
  length(first_name) AS name_length
FROM
  customer
ORDER BY
  name_length DESC;

-- if the first names are same, then the last names are
-- ordered in descending order
SELECT
  first_name,
  last_name
FROM
  customer
ORDER BY
  first_name ASC,
  last_name DESC;
```

## `DISTINCT` clause

* `DISTINCT` clause is used in the `SELECT` statement to remove duplicate rows from a result set. The `DISTINCT` clause keeps one row for each group of duplicates.

```Sql
-- syntax
SELECT
  DISTINCT column_1, column_2
FROM
  table_name;
```

* `DISTINCT ON (expression)` - keeps the “first” row of each group of duplicates.

> The order of rows returned from the SELECT statement is unpredictable therefore the “first” row of each group of the duplicate is also unpredictable. It is good practice to always use the ORDER BY clause with the DISTINCT ON(expression) to make the result set obvious.

```Sql
-- order by happens first and then distinct is performed
SELECT DISTINCT staff_id, customer_id
FROM
  payment
ORDER BY
  staff_id,
  customer_id;

-- In distinct ON, distinct values on the expression column
-- is taken and for each such value, exactly on value from
-- the column2 is taken
SELECT DISTINCT ON (staff_id)
  staff_id,
  customer_id
FROM
  payment
ORDER BY
  staff_id,
  customer_id;
```

---

## References

* [Select sql statement](https://www.postgresqltutorial.com/postgresql-select/)
