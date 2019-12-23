# Postgresql Syntax preferences

* Always use **as** for table or column aliasing eventhough its optional
* Always use `!=` for **not equals** operator instead of `<>`.
* Use appropriate clauses wherever possible. For instance, use `BETWEEN` for range check instead of `value >= min and value <= max`. Also this practice helps overcome issues like using`value = NULL` checks which will always evaluate to false while the correct way to do this check is to use `IS NULL`.
* Conform to SQL standards wherever possible unless the postgresql specific syntax offers a greater level of performance. For instance, prefer using `FETCH` to `LIMIT`, since `LIMIT` is postgresql specific.
* Always use `table_name.column_name` to refer to the required columns in join statements.
