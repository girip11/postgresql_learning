# Filtering data

## `WHERE` clause

* `WHERE` clause can be used in `UPDATE` and `DELETE` statements.
  
```Sql
-- condition should evaluate to true or false
SELECT select_list
FROM table_name
WHERE condition;
```

* Relational operators - `= > < >= <= != <>`. `!= <>` both are **not equals** operators.
* Logical operators - `AND OR`

```Sql
-- Equals
SELECT
  *
FROM
  customer
WHERE
  first_name = 'Kelly';

-- not equals
SELECT
  *
FROM
  customer
WHERE
  first_name != 'John';

-- logical operators
SELECT
  *
FROM
  customer
WHERE
  first_name = 'Kelly'
  AND last_name = 'Torres';

SELECT
  *
FROM
  customer
WHERE
  first_name = 'Kelly'
  OR last_name = 'Torres';

-- checking contains in a list using IN
SELECT
  *
FROM
  customer
WHERE
  first_name IN ('Kelly', 'John', 'Jamie');

-- string contains using LIKE
-- gets all customers whose first names starts with Ann
SELECT
  *
FROM
  customer
WHERE
  first_name LIKE 'Ann%';

-- using between
SELECT
  *
FROM
  customer
WHERE
  length(first_name) BETWEEN 5 AND 10;
```

## [`IN` operator](https://www.postgresqltutorial.com/postgresql-in/)

```Sql
-- syntax
value IN (value1,value2,...)
-- or
value IN (SELECT value FROM tbl_name);
```

* The list of values can be a list of numbers or strings or the result set of a SELECT statement.

```Sql
-- select all customers who took rental on particular day
SELECT
  distinct customer_id
FROM
  rental
WHERE
  customer_id IN (
    SELECT
      customer_id
    FROM
      rental
    WHERE
      CAST(rental_date AS DATE) = '2005-05-24');
```

* `NOT IN` - negation of IN.

```Sql
-- select all customers who took rental on particular day
SELECT
  title
FROM
  film
WHERE
  rating NOT IN ('PG', 'PG-13', 'NC-17');
```

## [`BETWEEN` operator](https://www.postgresqltutorial.com/postgresql-between/)

```Sql
-- syntax
-- Same as writing like `value >= low and value <= high`
value BETWEEN low AND high;

-- negation
-- Same as writing like `value < low or value > high`
value NOT BETWEEN low AND high;
```

**NOTE**: If you want to check a value against of date ranges, you should use the literal date in **ISO 8601 format** i.e., `YYYY-MM-DD`

```Sql
SELECT
  title
FROM
  film
WHERE
  release_year BETWEEN 2006 AND 2008;
```

## [`LIKE` operator](https://www.postgresqltutorial.com/postgresql-like/)

* The `LIKE` expression returns true if the string matches the pattern, otherwise it returns false.

```Sql
SELECT
  first_name,
  last_name
FROM
  customer
WHERE
  first_name LIKE '_her%';

SELECT
 first_name,
        last_name
FROM
 customer
WHERE
 first_name NOT LIKE 'Jen%';
```

* `%` - wildcard that matches any sequence of characters
* `_` - matches any single character

* `NOT LIKE` - negation of `LIKE`
* If the pattern does not contain any wildcard character, the LIKE operator acts like the equal ( =) operator.

* `ILIKE` - case insensitive match
* `NOT ILIKE` - negation of `ILIKE`

Following are exclusive to postgresql

* `~~` is equivalent to `LIKE`
* `!~~` is equivalent to `NOT LIKE`
* `~~*` is equivalent to `ILIKE`
* `!~~*` is equivalent to `NOT ILIKE`

## `ISNULL` operator

* NULL is not a value. NULL cannot be compared with any other value. `NULL = NULL` expression yields false. **You should never compare a column to NULL using `=`**. You should use the `IS NULL` and `IS NOT NULL` operators.

```Sql
-- Remember: using the condition like `phone_number = NULL`
-- always returns false.
SELECT
  *
FROM
  customer
WHERE
  email IS NULL;
```

* `IS NOT NULL` -  expression returns true if the value is not NULL or false if the value is NULL.

```Sql
-- Remember: using the condition like `phone_number = NULL`
-- always returns false.
SELECT
  *
FROM
  customer
WHERE
  email IS NOT NULL;
```

## Alias columns and tables using `AS`

> A PostgreSQL alias assigns a table or a column a temporary name in a query. The aliases only exist during the execution of the query.

```Sql
-- Column alias syntax
-- AS keyword is optional but adding it makes the query more readable
SELECT column_name AS alias_name
FROM table;

-- We can also provide alias to expressions
SELECT expression AS alias_name
FROM table;

-- table aliasing syntax
-- aliasing applicable to views as well
-- as keyword is optional
SELECT
  column_list
FROM
  table_name AS alias_name;
```

* Examples

```Sql
-- Because PostgreSQL evaluates the ORDER BY clause after
-- the SELECT clause, you can use the column alias in the
-- ORDER BY clause.

-- For the other clauses evaluated before the SELECT clause such
-- as WHERE, GROUP BY, and HAVING, you cannot reference the column
-- alias in these clauses.
SELECT
  first_name || ' ' || last_name AS full_name
FROM
  customer
ORDER BY
  full_name;
```

* Aliases are very handy when doing joins, particularly self join.

## `LIMIT/OFFSET` clause

* If `n` is zero, query returns an empty set.
* In case `n` is `NULL`, the query returns the same result set as omitting the LIMIT clause.
* **The `LIMIT` clause is not a SQL-standard.**

```Sql
SELECT
  *
FROM
  table_name
LIMIT n;

-- Limit with offset
-- The statement first skips m rows before returning n rows generated by the query.
-- If m is zero, the statement will work like without the OFFSET clause.
SELECT
  *
FROM
  table
LIMIT n OFFSET m;
```

**NOTE**: Because the order of the rows in the database table is unspecified, when you use the `LIMIT` clause, you should always use the `ORDER BY` clause to control the row order. If you don’t do so, you will get a result set whose rows are in an unspecified order.

* If you use a large `OFFSET`, it might not be efficient because PostgreSQL still has to calculate the rows skipped by the `OFFSET` inside the database server, even though the skipped rows are not returned.

* We often use the `LIMIT` clause to get the number of highest or lowest items in a table

```Sql
-- Example
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
```

## `FETCH` clause

* The `FETCH` clause was introduced in SQL:2008

```Sql
-- syntax
-- first statement is to specify the offset
OFFSET <start> {ROW | ROWS}
-- Fetch statement behaves like limit
FETCH {FIRST | NEXT} <row_count> {ROW | ROWS} ONLY
```

* ROW and FIRST are synonymous with ROWS and NEXT respectively.
* `start >= 0`. Default is 0.  In case the start is greater than the number of rows in the underlying result set, no rows are returned.
* The row_count is one or higher. By default, the value of row_count is one if it is not specified.

```Sql
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
OFFSET 3 ROWS FETCH FIRST 5 ROWS ONLY;
```

---

## References

* [Filtering data](https://www.postgresqltutorial.com/postgresql-where/)
