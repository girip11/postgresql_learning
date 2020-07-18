# Metadata queryies on type

* Query to get the size of a datatype

```Sql
SELECT
    typname,
    typlen
FROM
    pg_type
WHERE
    typname ~ '^timestamp';
```
