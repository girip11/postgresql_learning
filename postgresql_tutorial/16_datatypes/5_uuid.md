# UUID

* Universal Unique identifiers - 128 bits
* `UUID` guarantees better uniqueness compared to `SERIAL`
* [**uuid-ossp**](https://www.postgresql.org/docs/9.5/uuid-ossp.html) documentation

```Sql
-- This extension contains functions to generate UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- This function generates UUID
-- This function generates the UUID values based on the combination of computer’s MAC address, current timestamp, and a random value
SELECT uuid_generate_v1();

-- To generate a UUID value solely based on random numbers, you can use the uuid_generate_v4()
SELECT uuid_generate_v4();
```

---

## References

* [`UUID`](https://www.postgresqltutorial.com/postgresql-uuid/)
