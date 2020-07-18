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

## Timestamp type

* `TIMESTAMP`, `TIMESTAMPTZ`(with time zone information) stores date and time.

* This datatype is 8 bytes in size.

* `timestamptz` stores the timestamp in UTC and converts the value back to either of database server or user or the DB connection.

> It is a generally best practice to use the timestamptz data type to store the timestamp data.

* `SET timezone = 'America/Los_Angeles';` command sets the timezone of the database server. `SHOW TIMEZONE` displays the currently configured timezone.

### Timestamp functions

* `NOW()` function or `CURRENT_TIMESTAMP` returns the current date and time along with timezone information. `CURRENT_TIME` returns only the time part with zone info.

* `TIMEOFDAY()` - returns the current timestamp as string.

* `timezone(zone, timestamp)` converts the timestamp to the input timezone. Always provide timestamp with current zone info to the `timezone` function.

```Sql
-- timeofday provides a string, we convert to timestamptz explicitly
-- explicit conversion to timestamptz is recommended
SELECT timezone('America/New_York', timeofday()::timestamptz);
```

## Interval datatype

> The interval data type allows you to store and manipulate a period of time in years, months, days, hours, minutes, seconds, etc

* Widely used in date time arithmetic. Adding an interval to a date or subtracting an interval from a date.
* Interval data type takes up 16 bytes. Internally, PostgreSQL stores interval values as months, days, and seconds.
* `quantity unit [quantity unit...] [direction]` - quantity can have + or - sign. interval format. direction can be `ago` or empty string. `unit` can be any of **millennium, century, decade, year, month, week, day, hour, minute, second, millisecond, microsecond, or abbreviation (y, m, d, etc.,) or plural forms (months, days, etc.)**.

```Sql
SELECT interval '10 days -2 hours'
SELECT interval '1 year 2 months 3 days';

-- This returns -10:00:00. In date time arithmetic, we should
-- add the negative interval for subtracting from a given date
SELECT interval '10 hours ago';
```

* ISO 8601 interval formats
  * `P quantity unit [ quantity unit ...] [ T [ quantity unit ...]]`.
  * `P [ years-months-days ] [ T hours:minutes:seconds ]`
Refer to [this article for more details](https://www.postgresqltutorial.com/postgresql-interval/).

```Sql
SELECT interval 'P6Y5M4DT3H2M1S';
SELECT interval 'P0006-05-04T03:02:01';
```

* Interval output style can be either `sql_standard`, `postgres`(default), `postgresverbose` or `iso_8601`. We can change interval style using `SET intervalstyle = '<style>';`. `SHOW intervalstyle;` displays the current style.

### Interval operations and functions

* Arithmetic operators `+`, `-` and `*` can be applied to intervals

```Sql
-- This will subtract 10 hours from current time
SELECT NOW() - interval '10 hours';

-- This will add 10 hours to the current time
-- because ago returns negative interval. `-(-1) = +1`
-- now() - (-10:00:00) = now() + 10:00:00
SELECT NOW() - interval '10 hours ago'
```

* `TO_CHAR(interval, format)` converts interval to string

* `EXTRACT(unit FROM <interval>)` - extract units like year, month, date, hour, minutes, etc

* `justify_days(interval)` - converts number of days to months or years depending on the number of days in the input interval. `justify_hours(interval)` converts hours to days.

```Sql
-- converts to 10 months
SELECT justify_days(interval '300 days');

-- 3 days
SELECT justify_hours(interval '72 hours');

-- adjusts using above two functions
-- minus sign works in a different way in this method
-- This prints 1 mon 29 days 14:00:00
SELECT justify_interval(interval '60 days -10 hours');
-- Suppose I need the interval to be 11 mons 14 days 12:00:00
-- I can write the interval as '1year -15 days -12 hours'
-- Sometimes intervals created using this method can be more readable.
```

## Time datatype

* Stores the time of the day. takes up 8 bytes. `TIME(precision)` where precision can take up to 6 digits. Precision is always associated with seconds component.

```text
<!-- text formats -->
MM:SS.pppppp
HH:MM:SS.pppppp
HHMMSS.pppppp
```

* `TIME with time zone` stores the time of the day along with the time zone information.

### Time functions

* `CURRENT_TIME` - returns the current time of the day with time zone info.Without specifying the precision, the `CURRENT_TIME` function returns a time value with the full available precision.

* `CURRENT_TIME(precision)` - with seconds precision.

* `LOCALTIME(precision)` - returns the time in current timezone.

* `<time_value> AT TIME ZONE <time_zone_value>` converts the time to the target timezone. `timezone(zone, time)` can also be used for conversion.

```Sql
SELECT LOCALTIME AT TIME ZONE 'CST';
SELECT CURRENT_TIME AT TIME ZONE 'PST';
```

* `EXTRACT(unit from time)` can be used to extract hours, minutes and seconds from the input time.

* Arithmetic operations `+`, `-` can be used between time and interval values.

```Sql
SELECT LOCALTIME - interval '3 hours'
```

---

## References

* [Date type](https://www.postgresqltutorial.com/postgresql-date/)
* [Timestamp type](https://www.postgresqltutorial.com/postgresql-timestamp/)
* [Interval type](https://www.postgresqltutorial.com/postgresql-interval/)
* [Time type](https://www.postgresqltutorial.com/postgresql-time/)
