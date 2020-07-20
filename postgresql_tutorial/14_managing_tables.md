# Managing tables

## Creating tables

```Sql
-- table can have many columns and table constraints
CREATE TABLE [IF NOT EXISTS] table_name (
   column_name datatype column_contraint,
   ...
   table_constraints
);
```

* Posgresql constraints are `NOT NULL`, `CHECK`, `UNIQUE`, `PRIMARY KEY` and `FOREIGN KEY`
* Table constraints involve more than one column, while column constraint involve only that column.

## Altering tables

* Command format - `ALTER TABLE [IF EXISTS] table_name ACTION;`
* `ALTER TABLE` - can work only on a single table.
* When you rename a table, PostgreSQL will automatically update its dependent objects such as **foreign key constraints, views, and indexes**.

* Table operations

```Sql
-- rename a table
ALTER TABLE table_name
RENAME TO new_table_name;

-- Adding a constraint to the table
ALTER TABLE table_name
ADD CONSTRAINT constraint_name constraint_definition;

-- adding a check constraint to the table.
ALTER TABLE table_name
ADD CHECK expression;
```

* Column operations

```Sql
-- Adding a column
ALTER TABLE table_name
ADD COLUMN column_name data_type column_constraint;

-- renaming a column
ALTER TABLE table_name
RENAME COLUMN column_name
TO new_column_name;

-- Set or delete default
ALTER TABLE table_name
ALTER COLUMN column_name
[SET DEFAULT value | DROP DEFAULT];

-- set or remove NOT NULL constraint
ALTER TABLE table_name
ALTER COLUMN column_name
[SET NOT NULL| DROP NOT NULL];

-- Deleting a column
ALTER TABLE table_name
DROP COLUMN column_name;
```

## Deleting tables

### `DROP TABLE`

* Removes the table from the database.
* Removing a non existent table raises error. To avoid that we can use `IF EXISTS`

```Sql
--Syntax
-- only superuser, schema owner, and table owner
-- have sufficient privilege to remove the table.
DROP TABLE [IF EXISTS] (table_name1, table_name2, ...) [CASCADE | RESTRICT(default)];
```

* `RESTRICT` is default. Donot drop the table if any other object(like views) depends on it.

* `CASCADE` allows you to remove all dependent objects(views, contraints etc) together with the table automatically.

* We can delete multiple tables by specifying all the table names comma separated.

### `TRUNCATE TABLE`

> * To remove all data from a table, you use the `DELETE` statement. However, for a large table, it is more efficient to use the  `TRUNCATE TABLE` statement.
> * `TRUNCATE TABLE` statement removes all rows from a table without scanning it. This is the reason why it is faster than the `DELETE` statement.
> * In addition, the `TRUNCATE TABLE` statement reclaims the storage right away so you do not have to perform a subsequent `VACUMM` operation, which is useful in case of large tables.

```Sql
TRUNCATE TABLE (table_name1, table_name2, ...)
[[RESTART|CONTINUE(default)] IDENTITY] [CASCADE];
```

* `RESTART IDENTITY` - Sequence generator is also reset.
* Use `CASCADE` - Removes all the data from the specified tables as well as from table associated with it via the  **foreign key constraints**.

* To fire a trigger on truncate statement, `BEFORE TRUNCATE` and `AFTER TRUNCATE` have to be defined on that table.

* `TRUNCATE TABLE` is **transaction-safe**

---

## References

* [PostgreSQL CREATE TABLE](https://www.postgresqltutorial.com/postgresql-create-table/)
* [PostgreSQL  SELECT INTO](https://www.postgresqltutorial.com/postgresql-select-into/)
* [PostgreSQL CREATE TABLE AS](https://www.postgresqltutorial.com/postgresql-create-table-as/)
* [PostgreSQL ALTER TABLE](https://www.postgresqltutorial.com/postgresql-alter-table/)
* [PostgreSQL Rename TABLE](https://www.postgresqltutorial.com/postgresql-rename-table/)
* [PostgreSQL DROP TABLE](https://www.postgresqltutorial.com/postgresql-drop-table/)
* [PostgreSQL TRUNCATE TABLE](https://www.postgresqltutorial.com/postgresql-truncate-table/)
