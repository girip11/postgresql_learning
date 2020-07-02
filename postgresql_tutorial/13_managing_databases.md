# Managing databases

## Create database

* `CREATE DATABASE` query can be used to create a new database.

```Sql
-- = is optional but makes the query more readable
CREATE DATABASE db_name
 OWNER =  role_name
 TEMPLATE = template
 ENCODING = encoding
 LC_COLLATE = collate
 LC_CTYPE = ctype
 TABLESPACE = tablespace_name -- https://www.postgresqltutorial.com/postgresql-create-tablespace/
 CONNECTION LIMIT = max_concurrent_connection
 ALLOW_CONNECTIONS = [false | true(default)]
```

* Postgresql also has a helper utility `createdb` to create a new database

```Bash
# createdb --help
createdb --tablespace=<tablespace> \
--encoding=<encoding> \
--locale=<locale> \
--lc-collate=<LC_COLLATE> \
--lc-ctype=<LC_CTYPE> \
--owner=<owner> \
--template=<template> \
# below are connection options
--host=<db_host> \
--port=<db_port> \
--username=<username> \
--password \
<database_name> <database_description>
```

* `template1` is the default template in the database.

## Tablespace

> A tablespace is a location on disk where PostgreSQL stores data files containing database objects e.g., indexes., and tables.  PostgreSQL uses a tablespace to map a logical name to a physical location on disk.

Postgresql ships with two default tablespaces.

* `pg_default` - stores user data
* `pg_global` - stores global data

## [Alter database](https://www.postgresql.org/docs/12/sql-alterdatabase.html)

```Sql
ALTER DATABASE target_database RENAME TO new_name;

-- Only the superuser or owner of the DB can change it’s owner.
ALTER DATABASE name OWNER TO { new_owner | CURRENT_USER | SESSION_USER };

ALTER DATABASE target_database SET TABLESPACE new_tablespace;

-- only superuser or database owner can execute this command
ALTER DATABASE name SET configuration_parameter { TO | = } { value | DEFAULT};
```

## [Drop database](https://www.postgresql.org/docs/12/sql-dropdatabase.html)

```Sql
DROP DATABASE [ IF EXISTS ] name
```

> * The `DROP DATABASE` statement deletes catalog entries and data directory permanently. This action cannot be undone so you have to use it with caution.
> * Only the database owner can execute the DROP DATABASE statement.
> * You cannot execute the `DROP DATABASE` statement if there is any active connection to the database.

## Copy database

* To copy the database to another database in the same server execute the following command.

```Sql
-- copies contents of sourcedb to targetdb
CREATE DATABASE targetdb
TEMPLATE = sourcedb;
```

* To copy the database from one server to another, we need to import and export the database

```Bash
# dumps database to file
pg_dump -U postgres -O sourcedb sourcedb.sql

# before this, targetdb should be created on the remote server
# copies dump file to remote server
psql -U postgres -d targetdb -f sourcedb.sql
```

---

## References

* [Create database](https://www.postgresqltutorial.com/postgresql-create-database/)
* [Alter database](https://www.postgresqltutorial.com/postgresql-alter-database/)
* [Drop database](https://www.postgresqltutorial.com/postgresql-drop-database/)
* [Copy database](https://www.postgresqltutorial.com/postgresql-copy-database/)
