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

### Using `SELECT INTO`

* Creates a table from the data of another table.

* Besides the `WHERE` clause, you can use other clauses in the SELECT statement for the `SELECT INTO` statement such as `INNER JOIN, LEFT JOIN, GROUP BY, and HAVING`.

**Note**: You **cannot** use the `SELECT INTO` statement in **PL/pgSQL** because they interpret the INTO clause differently

```Sql
SELECT
    select_list
INTO [ TEMPORARY | TEMP | UNLOGGED ] [ TABLE ] new_table_name
FROM
    table_name
WHERE
    search_condition;
```

### Using `CREATE TABLE AS`

* Created table will contain the rows returned by the query.

* This statement provides a superset of functionality offered by the `SELECT INTO` statement.

* `CREATE TABLE AS` can be used in **PL\pgsql** without any issues unlike `SELECT INTO`.

```Sql
-- Syntax
-- giving column names explicitly is recommended
CREATE [TEMP|TEMPORARY|UNLOGGED] TABLE [IF NOT EXISTS] new_table_name (col_names_list)
AS query;
```

* Example

```Sql
CREATE TABLE action_film AS
SELECT
    film_id,
    title,
    release_year,
    length as film_length,
    rating
FROM
    film
INNER JOIN film_category USING (film_id)
WHERE
    category_id = 1;
```

**NOTE**: Prefer using `CREATE TABLE AS` to `SELECT INTO`.

## Altering tables

* Command format - `ALTER TABLE [IF EXISTS] table_name ACTION;`
* [`ALTER TABLE`](https://www.postgresql.org/docs/9.4/sql-altertable.html) - can work only on a single table.
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

* Column operations are covered separately in [managing columns](./14_managing_columns.md)

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
-- order of this command matters in writing the optionals
-- I cannot place cascade before restart|continue identity
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
