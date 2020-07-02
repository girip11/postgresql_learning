# Postgresql Schema

* Schema is a namespace for database objects like tables, views, functions, indexes, datatypes, operators.

```Sql
schema_name.db_object_name
```

* DB -> Schema is 1 -> M while Schema -> DB is 1 -> 1.
* Postgresql creates a **public schema** on every new database. This schema serves as the default schema(current schema) for that database unless explicitly changed. `public` schema can also be deleted.
* `SELECT current_schema();` returns the current schema(which is public by default).
* Schema search path: list of schemas to look for the database object when the database object is specified without its schema explicitly. `SHOW search_path;`

## [Create Schema](https://www.postgresql.org/docs/12/sql-createschema.html)

```Sql
-- create a schema
-- User needs to have CREATE permission on the database.
CREATE SCHEMA [IF NOT EXISTS] <schema_name>;

-- add to the search path
SET search_path TO <schema_name>, public;
```

* Creating a schema with the same name as that of a user(role).

```Sql
-- This will create a schema with the same name as the user_name
CREATE SCHEMA [IF NOT EXISTS] AUTHORIZATION user_name;

-- This will create schema `schema_name` owned by user_name
CREATE SCHEMA [IF NOT EXISTS] <schema_name >AUTHORIZATION user_name;
```

* All the schemas in a database are present in the table `pg_catalog.pg_namespace`.

```Sql
SELECT *
FROM pg_catalog.pg_namespace
WHERE nspname like 'public';
```

## Grant permission to users

```Sql
-- allow users to use objects in this schema
GRANT USAGE ON SCHEMA schema_name TO user_name;

-- allow user to create objects in this schema
GRANT CREATE ON SCHEMA schema_name TO user_name;
```

**Note**: By default, every user has `CREATE` and `USAGE` on the public schema

## Alter schema

```Sql
-- rename schema
ALTER SCHEMA schema_name
RENAME TO new_name;

-- change owner
ALTER SCHEMA schema_name
OWNER TO { new_owner | CURRENT_USER | SESSION_USER};
```

## Drop Schema

```Sql
-- only schema owner or superuser can drop schema
DROP SCHEMA [IF EXISTS] schema_name1, schema_name2, ...
[ CASCADE | RESTRICT ];
```

* `CASCADE` - deletes schema and all of its objects, and in turn, all objects that depend on those objects.
* `RESTRICT` - deletes schema only when it is empty. By default, PostgreSQL uses RESTRICT

---

## References

* [Create schema](https://www.postgresqltutorial.com/postgresql-create-schema/)
* [Alter schema](https://www.postgresqltutorial.com/postgresql-alter-schema/)
* [Drop schema](https://www.postgresqltutorial.com/postgresql-drop-schema/)
