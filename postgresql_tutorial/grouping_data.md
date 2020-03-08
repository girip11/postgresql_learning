# Grouping rows and performing aggregation

## `GROUP BY`

## `HAVING`

**NOTE**: Column name aliases can't be used with `HAVING` clause.

```sql

-- This query does not work as we cannot use aliased with HAVING clause
SELECT customer_id AS cust_id, SUM(amount) AS spent
FROM payment
GROUP BY cust_id
HAVING spent > 150
ORDER BY DESC

-- Below query works
SELECT customer_id AS cust_id, SUM(amount) AS spent
FROM payment
GROUP BY cust_id
HAVING SUM(amount) > 150
ORDER BY DESC
```

## References
