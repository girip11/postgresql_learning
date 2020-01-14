# Postgresql views

* View - stored query with a name. View does not store data, it acts as a virtual table. It is `SELECT` query over underlying physical tables.

* Users can be granted permissions to views similar to tables.

* Syntax: `CREATE VIEW view_name AS query`

* To change existing view definition if the view already exists use, `CREATE OR REPLACE VIEW view_name AS query`.

* While updating the view with new query definition, removal of columns from existing definition in not allowed. In such case, the current view is deleted and recreated. `DROP VIEW [IF EXISTS] view_name` to delete the view.

> The query must generate the same columns that were generated when the view was created. To be more specific, the new columns must have the same names, same data types, and in the same order as they were created. However, PostgreSQL allows you to append additional columns at the end of the column list.

* `ALTERT VIEW view_name` - to change view definition, for instance renaming the view.

```SQL
-- select movie information like title, release year, rating, category, language and actors.

-- First create a function to return actors as array for a given film
CREATE OR REPLACE FUNCTION get_actors (fid integer)
  RETURNS varchar[]
  LANGUAGE 'plpgsql'
  AS $$
DECLARE
  row RECORD;
  actors varchar[];
BEGIN
  FOR row IN (
    SELECT
      a.first_name || ' ' || a.last_name AS actor_name
    FROM
      film_actor AS fc
      INNER JOIN actor AS a ON fc.actor_id = a.actor_id
    WHERE
      fc.film_id = fid)
  LOOP
    RAISE NOTICE 'actor: %', row.actor_name;
    actors := actors || CAST(row.actor_name AS VARCHAR);
  END LOOP;
  RETURN actors;
END;
$$;


-- Then create a view to display the movie info
CREATE OR REPLACE VIEW film_info AS
SELECT
  f.title,
  f.release_year,
  f.rating,
  c.name AS category,
  l.name AS language,
  get_actors (f.film_id) AS actors
FROM
  film AS f
  INNER JOIN language AS l ON f.language_id = l.language_id
  INNER JOIN film_category AS fc ON f.film_id = fc.film_id
  INNER JOIN category AS c ON fc.category_id = c.category_id;

SELECT
  *
FROM
  film_info
WHERE
  rating = 'PG';

SELECT
  *
FROM
  film_info
WHERE
  'Penelope Guiness' = ANY (actors);
```

---

## References

* [PostgreSQL Views](https://www.postgresqltutorial.com/postgresql-views/)
