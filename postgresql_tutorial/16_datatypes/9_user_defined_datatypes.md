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

* Domain can be updated using `ALERT DOMAIN` and deleted using `DROP DOMAIN`.
* `\dD` - psql command to list all the domains

## `CREATE TYPE`

> The CREATE TYPE statement allows you to create a **composite type**, which can be use as the **return type of a function**.

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
* `ALERT TYPE` - to change the type and `DROP TYPE` - to delete the user defined type.
* `\dT` or `\dT+` - psql command to list all the user defined type

---

## References

* [User defined data types](https://www.postgresqltutorial.com/postgresql-user-defined-data-types/)
