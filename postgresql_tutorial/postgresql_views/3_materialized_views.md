# PostgreSQL Materialized Views

* Materialized views can store the data physically.

> A materialized view caches the result of a complex expensive query and then allow you to refresh this result periodically.

* Syntax

```SQL
CREATE MATERIALIZED VIEW view_name
AS
query
WITH [NO] DATA;
```

* `WITH DATA` - when data is loaded in to materialized view at the time of creation.

* We can query materialized views only after loading data in to it.

* `REFRESH MATERIALIZED VIEW view_name;` - loads data in to the materialized view.

> When you refresh data for a materialized view, PosgreSQL locks the entire table therefore you cannot query data against it. To avoid this, you can use the `CONCURRENTLY` option.
> `REFRESH MATERIALIZED VIEW CONCURRENTLY view_name;`
> One requirement for using CONCURRENTLY option is that the materialized view must have a UNIQUE index.

* `DROP MATERIALIZED VIEW view_name;` - deletes the materialized view.

```SQL
CREATE MATERIALIZED VIEW rental_by_category AS
SELECT
  c.name AS category,
  sum(p.amount) AS total_sales
FROM
  payment AS p
  INNER JOIN rental AS r ON p.rental_id = r.rental_id
  INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
  INNER JOIN film AS f ON i.film_id = f.film_id
  INNER JOIN film_category AS fc ON f.film_id = fc.film_id
  INNER JOIN category AS c ON fc.category_id = c.category_id
GROUP BY
  category
ORDER BY
  total_sales DESC WITH NO DATA;

-- this will load the data in to the view
REFRESH MATERIALIZED VIEW rental_by_category;

SELECT * FROM rental_by_category;
```

* To refresh the `rental_by_category` concurrently, it requires a unique index.

```SQL
CREATE UNIQUE INDEX rental_category ON rental_by_category (category);

REFRESH MATERIALIZED VIEW CONCURRENTLY rental_by_category;
```

---

## References

* [PostgreSQL Materialized Views](https://www.postgresqltutorial.com/postgresql-materialized-views/)
