# Control structures

## `IF` statement

* Syntax is very similar to the one in **Ruby** language, except that the IF ends withs `END IF`

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

### Iterate over a range

```Sql
-- Syntax
[ <<label>> ]
FOR name IN [ REVERSE ] expression .. expression [ BY expression ] LOOP
    statements
END LOOP [ label ];

-- Examples
DO $$
  BEGIN
    FOR c IN 1..5 LOOP
      RAISE NOTICE 'Value: %', c;
    END LOOP;
  END;
$$;

-- To increment by more than 1
-- BY value >0
DO $$
  BEGIN
    FOR c IN 1..15 BY 3 LOOP
      RAISE NOTICE 'Value: %', c;
    END LOOP;
  END;
$$;

-- To iterate reverse
DO $$
  BEGIN
    FOR c IN REVERSE 5..1 LOOP
      RAISE NOTICE 'Value: %', c;
    END LOOP;
  END;
$$;
```

### Iterate over array

```Sql
-- Syntax
--  The SLICE value must be an integer constant not larger
-- than the number of dimensions of the array.
[ <<label>> ]
FOREACH target [ SLICE number ] IN ARRAY expression LOOP
    statements
END LOOP [ label ];

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
  END;
$$;

-- using slice in case of multidimensional arrays
DO $$
  DECLARE
    arr integer[] := ARRAY[[1,2,3],[4,5,6],[7,8,9],[10,11,12]];
    c integer[];
  BEGIN
    FOREACH c SLICE 1 IN ARRAY arr
    LOOP
      RAISE NOTICE 'Value: %', c;
    END LOOP;
  END;
$$;
```

### Query execution syntax

```Sql
-- iterating over query results
-- Query can be select, update, insert or delete
[ <<label>> ]
FOR target IN query LOOP
    statements
END LOOP [ label ];

-- Using a query as text and passing parameters to the query
[ <<label>> ]
FOR target IN EXECUTE text_expression [ USING expression [, ... ] ] LOOP
    statements
END LOOP [ label ];
```

* Examples

```SQL
-- Looping through query result
-- each row will be stored in row variable
DO $$
  DECLARE
   row RECORD;
  BEGIN
    FOR row IN (SELECT first_name || ' ' || last_name as name FROM customer where customer_id >=10 and customer_id <= 50) LOOP
      RAISE NOTICE 'Customer name: %', row.name;
    END LOOP;
  END;
$$;


-- Loop through the results of dynamically executed query
-- from a string parameter
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
    customer_id between $1 and $2
  $query$;

  FOR ROW IN EXECUTE query
  USING 10, 20 LOOP
    RAISE NOTICE 'Customer name: %', row.name;
  END LOOP;
END;
$$;
```

---

## References

* [Case statement](https://www.postgresqltutorial.com/plpgsql-case-statement/)
* [If statement](https://www.postgresqltutorial.com/plpgsql-if-else-statements/)
* [Loop statements](https://www.postgresqltutorial.com/plpgsql-loop-statements/)
