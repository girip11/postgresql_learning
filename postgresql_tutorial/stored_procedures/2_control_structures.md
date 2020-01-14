# Control structures

## `IF` statement

* Syntax is very similar to the one in Ruby language.

```SQL
IF condition_1 THEN
  statements;
ELSIF condition_2 THEN
  statements;
...
ELSIF condition_n THEN
  statements;
ELSE
  statements;
END IF;
```

## `CASE` statement

* Syntax is very similar to [SQL case statement](../18_conditional_expressions_and_operators.md), only difference being the statement end tag is **END CASE**

```SQL
-- Simple case statement
CASE expr
  WHEN value_1 THEN
    result_1;
  WHEN value_2 THEN
    result_2;
  WHEN value_n THEN
    result_n;
  ELSE
    result_else;
END CASE;

-- Searched case statement
CASE
  WHEN expr_1 THEN
    result_1;
  WHEN expr_2 THEN
    result_2;
  WHEN expr_n THEN
    result_n;
  ELSE
  result_else;
END CASE;
```

## `LOOP` statement

* Similar to a `do-while` loop
* Label is required when nesting loop statement inside another loop statement.

```sql
<<loop_label>>
LOOP
  statements;
  EXIT [label] WHEN condition;
END LOOP;
```

## `WHILE` loop

* Syntax

```SQL
[<<loop_label>>]
while condition LOOP
  statements;
END LOOP;
```

## `FOR` loop

```SQL
DO $$
  BEGIN
    FOR c IN 1..5 LOOP
      RAISE NOTICE 'Value: %', c;
    END LOOP;
  END
$$;

-- To increment by more than 1
-- BY value >0
DO $$
  BEGIN
    FOR c IN 1..15 BY 3 LOOP
      RAISE NOTICE 'Value: %', c;
    END LOOP;
  END
$$;

-- To iterate reverse
DO $$
  BEGIN
    FOR c IN REVERSE 5..1 LOOP
      RAISE NOTICE 'Value: %', c;
    END LOOP;
  END
$$;

-- iterate through arrays using foreach
DO $$
  DECLARE
    arr integer[] := array[10, 20, 30];
    c integer;
  BEGIN
    FOREACH c IN ARRAY arr
    LOOP
      RAISE NOTICE 'Value: %', c;
    END LOOP;
  END
$$;

-- Looping through query result
-- each row will be stored in row variable
DO $$
  DECLARE
   row RECORD;
  BEGIN
    FOR row IN (SELECT first_name || ' ' || last_name as name FROM customer where customer_id >=10 and customer_id <= 50) LOOP
      RAISE NOTICE 'Customer name: %', row.name;
    END LOOP;
  END
$$;


-- Loop through the results of dynamically executed query from a string parameter
-- Query on the dvdrental database
-- `USING` statement to pass parameters to the query
DO $$
DECLARE
  ROW RECORD;
  query TEXT;
BEGIN
  query := $query$
  SELECT
    first_name || ' ' || last_name AS name
  FROM
    customer
  WHERE
    customer_id >= 10
    AND customer_id <= 50
  LIMIT $1
  $query$;
  FOR ROW IN EXECUTE query
  USING 20 LOOP
    RAISE NOTICE 'Customer name: %', row.name;
  END LOOP;
END
$$;

```

---

## References

* [Case statement](https://www.postgresqltutorial.com/plpgsql-case-statement/)
* [If statement](https://www.postgresqltutorial.com/plpgsql-if-else-statements/)
* [Loop statements](https://www.postgresqltutorial.com/plpgsql-loop-statements/)
