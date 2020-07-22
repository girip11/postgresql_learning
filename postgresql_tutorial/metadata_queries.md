# Database and table related metadata queries

* The `ALTER TABLE` statement acquires an exclusive lock on the table. If you have any pending transactions, it will wait for all transactions to complete before changing the table.
* Therefore, you should check the `pg_stat_activity` table to see the current pending transactions that are on-going using the following query:

```Sql
SELECT
  datid,
  datname,
  usename,
  state
FROM
  pg_stat_activity;
```
