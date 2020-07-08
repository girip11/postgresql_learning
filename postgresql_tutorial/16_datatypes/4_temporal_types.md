# Temporal types

## `DATE` datatype

* `DATE` types takes 4 bytes.
* When storing, the value is stored in `yyyy-mm-dd` format.

```Sql
CREATE TABLE <table_name> (
  joining_date DATE NOT NULL DEFAULT CURRENT_DATE
);
```

### Date functions

* `NOW()` returns the current timestamp.

```Sql
-- gets the date in yyyy-mm-dd format
SELECT (NOW()::DATE) AS today;

-- This returns the current day in yyyy-mm-dd format
SELECT CURRENT_DATE AS today;
```

* `TO_CHAR(date_value, format)`

```Sql
SELECT TO_CHAR(CURRENT_DATE, 'dd/mm/yyyy') as today;

-- outputs Jul 08, 2020
SELECT TO_CHAR(CURRENT_DATE, 'Mon dd, yyyy') as today;

-- outputs July 08, 2020
SELECT TO_CHAR(CURRENT_DATE, 'Mon dd, yyyy') as today;
```

* Subtracting two date values, return the interval between those two dates in days.

```Sql
SELECT CURRENT_DATE - ('2010-10-10'::date) AS diff_in_days;
```

* `AGE()` function returns the age of a person in years, months and days from the current date. Future date can also be passed to this function.

```Sql
-- prints 47 years 2 mons 14 days
SELECT AGE('1973-04-24'::DATE) AS sachin_age;

-- Find the age on a particular date
SELECT AGE('2011-04-24'::DATE, '1973-04-24'::DATE) AS sachin_world_cup_age;
```

* `EXTRACT()` function can be used to extract year, month, day, quarter and week from the given date input.

```Sql
SELECT EXTRACT(YEAR FROM CURRENT_DATE) AS current_year;
SELECT EXTRACT(MONTH FROM CURRENT_DATE) AS current_month;
SELECT EXTRACT(DAY FROM CURRENT_DATE) AS current_day_of_month;
SELECT EXTRACT(QUARTER FROM CURRENT_DATE) AS current_quarter;
SELECT EXTRACT(WEEK FROM CURRENT_DATE) AS current_week_of_year;
```

---

## References

* [Date type](https://www.postgresqltutorial.com/postgresql-date/)
* [Timestamp type](https://www.postgresqltutorial.com/postgresql-timestamp/)
* [Interval type](https://www.postgresqltutorial.com/postgresql-interval/)
* [Time type](https://www.postgresqltutorial.com/postgresql-time/)
