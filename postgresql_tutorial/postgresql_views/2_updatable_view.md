# PostgreSQL Updatable Views

>A PostgreSQL view is updatable when it meets the following conditions:
>
> * The defining query of the view must have exactly one entry in the FROM clause, which can be a table or another updatable view.
> * The defining query must not contain one of the following clauses at the top level: GROUP BY, HAVING, LIMIT, OFFSET, DISTINCT, WITH, UNION, INTERSECT, and EXCEPT.
> * The selection list must not contain any window function , any set-returning function(Function returning a table), or any aggregate function such as SUM, COUNT, AVG, MIN, and MAX.

```SQL
-- Example of NON updatable view
CREATE OR REPLACE VIEW action_movies AS
SELECT
f.*
FROM
film as f
INNER JOIN film_category as fc on f.film_id = fc.film_id
INNER JOIN category as c on c.category_id = fc.category_id and c.name = 'Action';

SELECT * FROM action_movies;

-- Raises error
-- ERROR:  cannot update view "action_movies"
-- DETAIL:  Views that do not select from a single table or view are not automatically updatable.
UPDATE action_movies SET release_year = 2007 where title = 'Amadeus Holy';
```

```SQL
-- Above example made to work as updatable view

-- The below function cannot return a table, otherwise usage of such function in the view violates the condition 3(cannot use a set returning function)
CREATE OR REPLACE FUNCTION get_movies_for_category(cat varchar)
RETURNS integer[]
LANGUAGE 'plpgsql'
AS $$
DECLARE
  rec RECORD;
  films integer[];
BEGIN
  FOR rec IN (
  SELECT
    fc.film_id as film_id
  FROM film_category as fc
  INNER JOIN category as c on fc.category_id = c.category_id and c.name = cat)
  LOOP
    films := films || CAST( rec.film_id as integer);
  END LOOP;
  
  RAISE NOTICE 'Total Movies of category % are %', cat, array_length(films, 1);
  RETURN films;
END;
$$;

CREATE OR REPLACE VIEW action_movies AS
SELECT
*
FROM
film
where
film_id IN (SELECT UNNEST(get_movies_for_category('Action')));

-- Test the view
SELECT * FROM action_movies;

-- Update the release year of a single row
SELECT * FROM action_movies where title = 'Amadeus Holy';

UPDATE action_movies SET release_year = 2010 where title = 'Amadeus Holy';

SELECT * FROM action_movies where title = 'Amadeus Holy';
```

---

## References

* [PostgreSQL Updatable Views](https://www.postgresqltutorial.com/postgresql-updatable-views/)
