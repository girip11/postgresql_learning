# PL/pgSQL Blocks

* Syntax

```sql
<<block_label>>
DECLARE
    var_name type := value;
BEGIN
    -- body of the block
    -- This statement is used to break out of this block
    EXIT block_label
END block_label;
```

* Label and declare section are **optional**. A label is only needed if you want to identify the block for use in an `EXIT` statement, or to qualify the names of the variables declared in the block.

* Every declaration statement is terminated with **;**. Similarly every statement in the body too.

* Block definition is also terminated with **;**

* `DO` statement is used for executing the blocks

* Enclosing string between `$[token]$` is equivalent to enclosing the content within single quotes

```Sql
-- escaping single quotes inside string
SELECT 'I''m also a string constant';
SELECT E'I\'m also a string constant';

-- using $$
-- No escaping required for single quotes and backslashes
SELECT $$I'm also a string constant with a backslash \ $$;
-- using optional tag( can be anything)
SELECT $tag$I'm also a string constant with a backslash \ $tag$;
```

* Helps to **avoid escaping single quotes and backslashes** inside a single quoted string.

```sql
DO $block$
<<simple_block>>
DECLARE
  op1 integer := 10;
  op2 integer := 30;
  sum_val integer := 0;
BEGIN
  sum_val := op1 + op2;
  RAISE NOTICE 'Sum of % and % is %', op1, op2, sum_val;
END simple_block;
$block$;
```

## Subblocks

* A block may contain many subblocks.
* Variables inside the subblock with same name as a variable defined in the outer block will shadow that outer block variable.
* Outer block variable can be accessed using its label

```sql
DO $block$
<< outer_block >>
DECLARE
  msg VARCHAR := 'Hello';
BEGIN
  raise notice 'Message is %', msg;

  -- inner block
  DECLARE
    msg VARCHAR := 'Hi';
  BEGIN
    raise notice 'Inside the subblock, Message  is %', msg;
    raise notice 'Inside the subblock, Outer block message is %', outer_block.msg;
  END;

END outer_block;
$block$;
```

## Variables

* All variables should be declared in the `DECLARE` section.
* Variable declaration syntax - `var_name var_type [:= expr]`
* By default the variable is assigned `NULL`
* Data type can be any of the postgresql data type

```sql
DO $$
DECLARE
  name VARCHAR(20) := 'John Doe';
BEGIN
  RAISE NOTICE 'Name is %', name;
END;
$$;
```

* Data type of a variable can also come from a table column. Such variable can store the value of the column returned from a query.

```sql
DO $$
<<block>>
DECLARE
  customer_id INTEGER := 1;
  -- SYNTAX: `variable_name table_name.column_name%TYPE;`
  first_name customer.first_name%TYPE := '';
BEGIN
  first_name := (select customer.first_name from customer where customer.customer_id = block.customer_id);
  RAISE NOTICE 'First Name of customer with id % is %', customer_id, first_name;
END block;
$$;
```

* Variables can be aliased. Syntax `new_name ALIAS FOR old_name`

## Constants

* Value cannot be changed after initialization
* Syntax: `CONSTANT_NAME CONSTANT data_type := expression;`
* Upper case is used for naming constants.

> PostgreSQL evaluates the value for the constant when the block is entered at run-time, not compile-time

## `RAISE` statement

* Syntax: `RAISE <LEVEL> MESSAGE_FORMAT`

* **LEVEL** can be one of the following values **DEBUG**, **LOG** ,**NOTICE**, **INFO**, **WARNING**, **EXCEPTION**(default)

```sql
DO $$
BEGIN
  RAISE DEBUG 'DEBUG: Current time is %', NOW();
  RAISE NOTICE 'Current time is %', NOW();
  -- Number of % should match the arguments
  RAISE NOTICE 'Length of % is %', 'Hello', LENGTH('HELLO');
END;
$$;
```

* `client_min_messages` and `log_min_messages` configuration parameters control the current log level that can be displayed.

## [Raising exception](https://www.postgresql.org/docs/12/plpgsql-errors-and-messages.html)

* Syntax

```Sql
RAISE [ level ] 'format' [, expression [, ... ]] [ USING option = expression [, ... ] ];

RAISE [ level ] condition_name [ USING option = expression [, ... ] ];

RAISE [ level ] SQLSTATE 'sqlstate' [ USING option = expression [, ... ] ];

-- option can be one of (MESSAGE, HINT, DETAIL, ERRCODE)
RAISE [ level ] USING option = expression [, ... ];

RAISE ;
```

```sql
DO $$
  << block >>
DECLARE
  customer_id INTEGER := 1;
  first_name customer.first_name % TYPE := '';
BEGIN
  first_name := (
    SELECT
      customer.first_name
    FROM
      customer
    WHERE
      customer.customer_id = block.customer_id);

  CASE
    WHEN first_name IS NULL THEN
      RAISE exception 'First name of customer is null' USING HINT = 'Customer name should not be NULL';
    ELSE
      RAISE NOTICE 'First Name of customer with id % is %', customer_id, first_name;
  END CASE;
END block;
$$;
```

## Debugging using `ASSERT` statement

* Used for debugging purposes only.
* Syntax: `ASSERT condition [, message]`
* Condition should be a boolean expression and assert statement raises `ASSERT_FAILURE` when the condition evaluates to false.

---

## References

* [PL/pgSQL Block Structure](https://www.postgresqltutorial.com/plpgsql-block-structure/)
* [Constants](https://www.postgresqltutorial.com/plpgsql-constants/)
* [Variables](https://www.postgresqltutorial.com/plpgsql-variables/)
* [Errors and Messages](https://www.postgresqltutorial.com/plpgsql-errors-messages/)
