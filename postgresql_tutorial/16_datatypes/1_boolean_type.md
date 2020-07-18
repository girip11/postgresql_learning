# `BOOLEAN` type

* Boolean values - `true`, `'t'`, `'yes'`, `'y'`, `'1'`, `'true'` all evaluate to true and `false`, `'f'`, `'no'`, `'n'`, `'0'` and `'false'` evaluate to false.

```Sql
-- Strings with values y, yes, t and true can be type casted to boolean
SELECT
  1::boolean, 'y'::boolean, 'yes'::boolean,'t'::boolean,'true'::boolean;

SELECT
  0::boolean, 'n'::boolean, 'no'::boolean,'f'::boolean,'false'::boolean;
```

* Columns of boolean data type can be used in `WHERE` clause directly.

```Sql
-- suppose films table has a column called recent
-- which is a boolean type, then the
-- following query select the recent movies.
SELECT *
FROM films
WHERE recent;
```

* To set default value for a boolean column, use the `ALTER TABLE` query.

```Sql
ALTER TABLE <table_name>
ALTER COLUMN <column_name>
SET DEFAULT <true | false>;

-- to create a table with default value
CREATE TABLE <table_name>(
  <column_name> BOOLEAN DEFAULT 't'
);
```

---

## References

* [Boolean Data Type](https://www.postgresqltutorial.com/postgresql-boolean/)
