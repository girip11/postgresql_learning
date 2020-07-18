# Tips on writing readable SQL queries

> * Make all declarative keywords their own new line if possible because it’s easier to read and understand which table and which columns are being referenced.
> * Make all declarative statements and DB functions uppercase

To achieve the above mentioned guidelines in modern editors like VSCODE, we can use extensions like **pgFormatter**.

> * Try to limit the amount of subqueries in your query.
> * Include comments
> * Use short but concise table aliases
> * Use indentation. If you have multiple subqueries, it’s much easier to read where the subqueries came from.

---

## References

* [Creating readable SQL](http://veekaybee.github.io/2015/06/02/good-sql/)
