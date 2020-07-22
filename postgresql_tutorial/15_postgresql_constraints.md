# Postgresql constraints

## Primary key constraint

* A primary key is a column or a group of columns **used to identify a row uniquely in a table**. Technically, a primary key constraint is the combination of a `NOT NULL` constraint and a `UNIQUE` constraint.

* A table can have exactly one primary key.
* Primary key columns are automatically indexed.

```Sql
CREATE TABLE TABLE (
  -- column level primary key
  column_name data_type PRIMARY KEY,
  ...
  -- table level primary key involves multiple columns
  -- marked together to server as primary key
  PRIMARY KEY (column1, column2)
);

-- creating primary key constraint with name
CREATE TABLE TABLE (
  column_name data_type CONSTRAINT prkey_constraint_name PRIMARY KEY,
  ...
  CONSTRAINT constraint_name PRIMARY KEY (column1, column2)
);


-- Adding primary key to existing table(rare case)
ALTER TABLE table_name
ADD [CONSTRAINT constraint_name] PRIMARY KEY (column_1, column_2);

-- remove the primary key constraint from a table
ALTER TABLE table_name
DROP CONSTRAINT primary_key_constraint;
```

* `{table_name}_pkey` will be the default name given for primary key constraint.

## Foreign key constraint

* A foreign key is a column or a group of columns in a table that references the primary key of another table.
* The table that contains the foreign key is called the **referencing table or child table**.
* The table referenced by the foreign key is called the **referenced table or parent table**.
* Table can have multiple foreign key constraints with other tables.
* The foreign key constraint helps maintain the **referential integrity of data** between the child and parent tables.

```Sql
CREATE TABLE TABLE (
  ... -- columns
  [CONSTRAINT fk_name] FOREIGN KEY(fk_columns)
  REFERENCES parent_table(parent_key_columns)
  [ON DELETE delete_action]
  [ON UPDATE update_action]
);

-- Adding foreign key constraint to an existing table
ALTER TABLE child_table
ADD CONSTRAINT constraint_name
FOREIGN KEY (fk_columns)
REFERENCES parent_table (parent_key_columns)
[ON DELETE [action]];

-- drop the foreign key constraint
ALTER TABLE child_table
DROP CONSTRAINT constraint_fkey;
```

* Following actions are supported for `ON DELETE` -
  * `SET NULL` - Sets child table foreign key columns to NULL, when parent table columns get deleted.
  * `SET DEFAULT` - sets the default value to the foreign key column of the referencing rows in the child table when the referenced rows from the parent table are deleted.
  * `RESTRICT`
  * `NO ACTION` (default) - With this value, we get error when deleting referenced columns in the parent table.
  * `CASCADE` - `ON DELETE CASCADE` automatically deletes all the referencing rows in the child table when the referenced rows in the parent table are deleted.

## `UNIQUE` constraint

* Enforces the value of a column(column level) or group of columns(table level) should be unique throughout the entire table.
* When you add a `UNIQUE` constraint to a column or a group of columns, PostgreSQL will **automatically create a unique index** on the column or the group of columns.

```Sql
CREATE TABLE table_name (
  column_name datatype UNIQUE,
  ...
  -- table level constraint
  -- the column value combinations should be unique
  UNIQUE(column1, column2)
);

-- adding unique constraint using unique index
CREATE UNIQUE INDEX CONCURRENTLY unique_index_name
ON table_name(column_name);

-- After creating the unique index, the same should be
-- associated to the table using ALTER TABLE
-- This adds a table level constraint
ALTER TABLE table_name
ADD CONSTRAINT constraint_name UNIQUE
USING INDEX unique_index_name;
```

## `CHECK` constraint

* This constraint uses a boolean expression to enforce that a column value must
satisfy certain conditions.

* This constraint can be applied to a column as well as to a table(involving multiple columns of that table)

```Sql
CREATE TABLE table_name(
  -- this is a column level constraint
  column_name varchar CHECK (column_name != '' and length(column_name) > 8),
  -- named check constraint
  column_name2 varchar CONSTRAINT no_space_check  CHECK (column_name2 !~ '\s'),
  column3 text,
  column2 text,
  ...
  -- table level constraint
  CONSTRAINT column2_column3_notnull CHECK(
    column2 IS NOT NULL AND
    column3 IS NOT NULL
  )
);

-- add check constraint to existing column
ALTER TABLE table_name
ALTER COLUMN column_name
ADD CHECK (condition);

-- OR use the below condition to create a named constraint
ALTER TABLE table_name
ALTER COLUMN column_name
ADD CONSTRAINT constraint_name CHECK (condition);
```

* By default the column level check constraint is named as `{table_name}_{column_name}_check`

## `NOT NULL` constraint

* `NULL` represents absence of value. It does not equal anything, even itself.

```Sql
-- creating a column with NOT NULL constraint
CREATE TABLE table_name(
  column_name data_type NOT NULL,
  
  -- we can use CHECK to enforce NOT NULL constraint
  column_name data_type CHECK (column_name IS NOT NULL)
  ...
);

-- Adding or removing NOT NULL constraint to/from a column
ALTER TABLE table_name
ALTER COLUMN column_name
[SET|DROP] NOT NULL;
```

* `IS NULL` and `IS NOT NULL` are used for comparing a column against `NULL`
* By default all columns accept `NULL` values

---

## References

* [Constraints in Postgresql](https://www.postgresql.org/docs/9.4/ddl-constraints.html)
* [Primary Key constraint](https://www.postgresqltutorial.com/postgresql-primary-key/)
* [Foreign Key constraint](https://www.postgresqltutorial.com/postgresql-foreign-key/)
* [Unique constraint](https://www.postgresqltutorial.com/postgresql-unique-constraint/)
* [Check constraint](https://www.postgresqltutorial.com/postgresql-check-constraint/)
* [NOT NULL constraint](https://www.postgresqltutorial.com/postgresql-not-null-constraint/)
