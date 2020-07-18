# Character Types

* `CHAR(n)`, `VARCHAR(n)` and `TEXT`

* Trying to store more than n characters(where the extra characters are not spaces) in `CHAR(n)` and `VARCHAR(n)` will raise error.

* `TEXT` and `VARCHAR` are most commonly used types.

## CHAR

* `CHAR(n)` - fixed length string with values padded with space if the actual string length is less than n.

```Sql
-- this will truncate the string
-- Same effect on VARCHAR as well
SELECT
  CAST('HelloWorld' AS CHAR(5));

```

* Character type without length specified explicitly equals `CHAR(1)`

## VARCHAR

* `VARCHAR(n)` - variable length string that can contain upto n characters, but will not be padded with space if the string length is less than n.

> If you do not specify the n integer for the varchar data type, it behaves like the text data type. The performance of the varchar (without n) and text are the same.

## TEXT

* `TEXT` - variable-length, but the length is unlimited.

---

## References

* [Character Types](https://www.postgresqltutorial.com/postgresql-char-varchar-text/)
