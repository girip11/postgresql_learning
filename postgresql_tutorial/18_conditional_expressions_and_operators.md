# Conditional Expressions and Operators

## `CASE` expression

* Syntax is very similar to `CASE` statement in **ruby programming language**

```SQL
CASE
  WHEN expr_1 THEN result_1
  WHEN expr_2 THEN result_2
  WHEN expr_n THEN result_n
  ELSE result_else
END

-- ALTERNATE SYNTAX
CASE expr
  WHEN value_1 THEN result_1
  WHEN value_2 THEN result_2
  WHEN value_n THEN result_n
  ELSE result_else
END
```

* If the `ELSE` clause is not provided and none of the `WHEN` conditions are satisfied, `CASE` statement returns `NULL`

```SQL
SELECT
  SUM(
    CASE
    WHEN rental_rate = 0.99 THEN
      1
    ELSE
      0
    END) AS cheap,
  SUM(
    CASE
    WHEN rental_rate = 2.99 THEN
      1
    ELSE
      0
    END) AS moderate,
  SUM(
    CASE
    WHEN rental_rate = 4.99 THEN
      1
    ELSE
      0
    END) AS luxury
FROM
  film;
  
-- Using the alternate syntax
SELECT
  SUM(
    CASE rental_rate
    WHEN 0.99 THEN
      1
    ELSE
      0
    END) AS cheap,
  SUM(
    CASE rental_rate
    WHEN 2.99 THEN
      1
    ELSE
      0
    END) AS moderate,
  SUM(
    CASE rental_rate
    WHEN 4.99 THEN
      1
    ELSE
      0
    END) AS luxury
FROM
  film;
```

## `CAST` operator

* Syntax - `CAST (expression AS type)`
* **type** refers to the [data type](http://www.postgresqltutorial.com/postgresql-data-types/)

```SQL
SELECT
  CAST ('100' AS INT) as int_value;

SELECT
  CAST ('98.6' AS FLOAT) as body_temperature;
-- or
SELECT
  CAST ('98.6' AS DOUBLE PRECISION) as body_temperature;

-- to boolean
SELECT
  CAST ('true' AS BOOLEAN) as enabled;

```

* `::` is postgresql specific cast operator

```SQL
SELECT
  '100'::INT as int_value;
```

## `COALESCE` function

* Syntax - `COALESCE(arg1, arg2 ...)`
* Returns the first argument which is **not `NULL`**
* Used to return default values in cases where an expression can evaluate to `NULL`

```SQL
SELECT COALESCE(NULL, 1 - NULL, (100 * 5))

-- if description is NULL, return description as **NOT AVAILABLE**
SELECT
  COALESCE(
      description,
      'NOT AVAILABLE')
FROM
  film;
```

## `NULLIF` function

* Syntax - `NULLIF(arg1, arg2)`. Returns `NULL` if `arg1` **equals** `arg2` else returns the `arg1`

* Useful in handling division by zero cases.

```SQL
SELECT NULLIF(1, 1);

SELECT NULLIF(1, 0);

-- if description is '' or NULL, return description as **NOT AVAILABLE**
SELECT
  COALESCE(
      NULLIF(description, ''),
      'NOT AVAILABLE')
FROM
  film;
```

---

## References

* [Postgresql `CAST`](http://www.postgresqltutorial.com/postgresql-cast/)
* [Postgresql `CASE`](http://www.postgresqltutorial.com/postgresql-case/)
* [Postgresql `COALESCE`](http://www.postgresqltutorial.com/postgresql-coalesce/)
* [Postgresql `NULLIF`](http://www.postgresqltutorial.com/postgresql-nullif/)
