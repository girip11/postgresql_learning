# Sequence in Postgresql

* Sequence is an ordered list of integers.

## Creating a sequence

* Sequence name should be unique from any other object(table, views etc) within the schema

```SQL
CREATE SEQUENCE [ IF NOT EXISTS ] sequence_name
    [ AS { SMALLINT | INT | BIGINT } ]
    [ INCREMENT [ BY ] increment ]
    [ MINVALUE minvalue | NO MINVALUE ]
    [ MAXVALUE maxvalue | NO MAXVALUE ]
    [ START [ WITH ] start ]
    [ CACHE cache ]
    [ [ NO ] CYCLE ]
    [ OWNED BY { table_name.column_name | NONE } ]
```

* Default increment is 1. Increment can also be negative.

* MINVALUE  should always be less than the MAXVALUE.

* `NO MINVALUE| MAXVALUE` - Will set the min and max values to the default minimum which is 1 and default max will be the max value of `SMALLINT, INT, BIGINT`.

* In case of a descending sequence, the default maximum value is -1 and the default minimum value is the minimum value of the data type of the sequence.

* Default starting value is the minimum value(ascending) and maxvalue(descending).

* `NO CYCLE` is default

* By default `CACHE` option is not set. `CACHE 100` will generate first 100 values of the sequence.

* The `OWNED BY` clause allows you to associate the table column with the sequence so that when you drop the column or table, PostgreSQL will automatically drop the associated sequence.

```SQL
-- This is a descending sequence
CREATE SEQUENCE desc_seq
  AS int
  INCREMENT BY -1
  MINVALUE 0
  MAXVALUE 1000000
  START 1000000
  CYCLE
  CACHE 10;

-- generates numbers from 1000000 to 0
SELECT nextval('desc_seq');
```

* `\d <seq_name>` - can be used to describe the sequence.

## Sequence functions

* `nextval('seq_name')` - returns the next value in the sequence.
* `currval('seq_name')` - returns the last generated value.

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

## Deleting sequences

If a sequence is associated with a table column, it will be automatically dropped once the table column is removed or the table is dropped.

```Sql
-- This statement is for manually deleting the sequences
DROP SEQUENCE [ IF EXISTS ] sequence_name [, ...]
[ CASCADE | RESTRICT ];
```

## Uses

Sequence is used by `SERIAL` pseudo-type and `IDENTITY` columns.

---

## References

* [Sequence](https://www.postgresqltutorial.com/postgresql-sequences/)
* [Identity column and sequence options](https://www.postgresqltutorial.com/postgresql-identity-column/)
