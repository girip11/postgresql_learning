# User defined data types

## `CREATE DOMAIN`

* Domain is a data type with optional constraints like `NOT NULL`, `CHECK` etc.

* Domain name is unique with in the schema scope.

* Common usecase: Helps in reusing common contraint against a table column

```SQL
-- creates a data type that cannot be NULL as well as should
-- not contain any space in its value.
CREATE DOMAIN Name
  AS varchar
  NOT NULL
  CHECK (value !~ '\s');

CREATE TABLE student (
  id serial PRIMARY KEY,
  first_name Name,
  last_name Name,
  gender VARCHAR NOT NULL
);

INSERT INTO student (first_name, last_name, gender)
  VALUES ('Jane', 'Doe', 'male');

-- Insert will fail since the name contains space
INSERT INTO student (first_name, last_name, gender)
  VALUES ('John B', 'Doe', 'male');
```

* Domain can be updated using [`ALERT DOMAIN`](https://www.postgresql.org/docs/9.4/sql-alterdomain.html) and deleted using `DROP DOMAIN`.

```Sql
-- remove existing check
-- check constraints are given a default name of the format
-- <domain_name>_check
ALTER DOMAIN public.name
  DROP CONSTRAINT name_check;

-- add new check
-- we can also use ADD CONSTRAINT command
ALTER DOMAIN name
  ADD CHECK (value !~ '\s'
    AND length(value) <= 20);

-- For NOT NULL we cannot use ADD/DROP CONSTRAINT
-- To remove not null constraint
ALTER DOMAIN public.name
  DROP NOT NULL;

-- To add the NOT NULL constraint
ALTER DOMAIN public.name
  SET NOT NULL;
```

* `\dD` - psql command to list all the domains

## `CREATE TYPE`

> The CREATE TYPE statement allows you to create a **composite type**, which can be use as the **return type of a function**.

* Fields inside the type are referred to as **attributes**

```SQL
-- creates a type that encaps name and gender
-- Though a simple select from student would serve the purpose this
-- example demonstrates the use of type in postgresql.
CREATE TYPE student_summary AS (
  name varchar,
  gender varchar
);

CREATE OR REPLACE FUNCTION get_student_summary (st_id int)
  RETURNS student_summary
  AS $$
  SELECT
    name,
    gender
  FROM
    student
  WHERE
    id = st_id;
$$
LANGUAGE sql;

-- calling the above function
SELECT
  *
FROM
  get_student_summary (5);
```

* Each field in the type becomes a column in the returned result set.
* [`ALERT TYPE`](https://www.postgresql.org/docs/9.4/sql-altertype.html) - to change the type and `DROP TYPE` - to delete the user defined type.

```Sql
ALTER TYPE name action [, ... ]
ALTER TYPE name OWNER TO new_owner
ALTER TYPE name RENAME ATTRIBUTE attribute_name TO new_attribute_name [ CASCADE | RESTRICT ]
ALTER TYPE name RENAME TO new_name
ALTER TYPE name SET SCHEMA new_schema
ALTER TYPE name ADD VALUE [ IF NOT EXISTS ] new_enum_value [ { BEFORE | AFTER } existing_enum_value ]

where action is one of:

    ADD ATTRIBUTE attribute_name data_type [ COLLATE collation ] [ CASCADE | RESTRICT ]
    DROP ATTRIBUTE [ IF EXISTS ] attribute_name [ CASCADE | RESTRICT ]
    ALTER ATTRIBUTE attribute_name [ SET DATA ] TYPE data_type [ COLLATE collation ] [ CASCADE | RESTRICT ]
```

* `\dT` or `\dT+` - psql command to list all the user defined type

---

## References

* [User defined data types](https://www.postgresqltutorial.com/postgresql-user-defined-data-types/)
