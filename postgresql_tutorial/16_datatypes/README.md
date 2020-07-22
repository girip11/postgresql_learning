# Metadata queryies on type

* Query to get the size of a datatype

```Sql
SELECT
    typname,
    typlen
FROM
    pg_catalog.pg_type
WHERE
    typname ~ '^timestamp';
```

* Listing all the domains in a specific schema

```Sql
SELECT
  typname, nspname
FROM
  pg_catalog.pg_type
  JOIN pg_catalog.pg_namespace ON pg_namespace.oid = pg_type.typnamespace
WHERE
  typtype = 'd' -- type is domain
  AND nspname = 'public';
```

* Listing all sequences in a namespace

```SQL
-- this returns all the sequences in a given namespace
SELECT
    relname
FROM
    pg_class
JOIN pg_catalog.pg_namespace ON pg_namespace.oid = pg_class.relnamespace
WHERE
    relkind = 'S' and
     nspname = 'public';
```
