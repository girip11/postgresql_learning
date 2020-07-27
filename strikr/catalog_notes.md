# Catalog notes

* Cluster - may contain one or more databases
* tablespace - storage area
* partition - partitioning of data.
* `initdb` - initializes the cluster

```Bash
# initializes the cluster storage
initdb --pgdata=/home/pgadmin/test/postgres/data \
 --username=pgadmin \
 --pwfile=db.password \
 --debug
```

```Conf
; sample configuration
VERSION=14devel
PGDATA=/home/pgadmin/test/postgres/data
share_path=/home/pgadmin/root/doc/postgresql
PGPATH=/home/pgadmin/root/bin
POSTGRES_SUPERUSERNAME=pgadmin
POSTGRES_BKI=/home/pgadmin/root/doc/postgresql/postgres.bki
POSTGRESQL_CONF_SAMPLE=/home/pgadmin/root/doc/postgresql/postgresql.conf.sample
PG_HBA_SAMPLE=/home/pgadmin/root/doc/postgresql/pg_hba.conf.sample
PG_IDENT_SAMPLE=/home/pgadmin/root/doc/postgresql/pg_ident.conf.sample
The database cluster will be initialized with locale "en_US.UTF-8".
The default database encoding has accordingly been set to "UTF8".
The default text search configuration will be set to "english".
```

* Encoding is important when configuring clusters.
* A single **CLUSTER** may contain one or more database
* A single **DATABASE** may contain one or more schemas.
* A single **SCHEMA** may contain one or more tables and other named objects
* Access control can be applied to schema.
* `database_name.schema_name.table_name` - This is an example of a fully qualified table name.

```Bash
createdb --owner=postgres \
         --username=postgres \
         --password
         <database_name>
```

* System catalog (**pg_catalog**) - set of tables. Can be queried using sql only.
* ways of getting information
  * examine the logs, read the config files, tracing (using systemtap), query postgresql itself.

* `select pg_reload_conf();` - reloads the configuration. This returns true if successful.
* `pg_catalog` is always in the search path. It contains system tables, views, functions etc
* `show search_path;`
* `select * from pg_catalog.pg_namespace;`
* `select * from pg_catalog.pg_tables;`
* `select * from pg_catalog.pg_collation;`
* `select * from information_schema.sql_implementation_info;`

* Foreign data wrapper - calls a method registered on INSERT etc.These function implementation can be in C++, python as well.

* `select * from pg_catalog.pg_proc;` - all procedures.
* `cidr` - type to store IP address. Postgresql has many such useful builtin types.
* `pg_catalog.pg_attribute` - columns
* `select * from pg_stat_*` - statistics

## Psql commands

`psql -E` - dumps a query behind every sql command

* `\?` - help of psql commands
* `\l+` - lists all the databases. Same as executing the query `select * from pg_catalog.pg_database;`
* `\H` - Toggle the HTML output format
* `\dn+` - lists all the schemas in the current database.

## TOD and BKI

* TOD - Tuple on disk
* BKI - Backend Interface

* fillfactor (close to 100 - system catalog, and gives high performance) and vacuum - has effect on performance.

## Commands

```Bash
pgbench --debug --host=127.0.0.1 \
--port=5432 --username=postgres \
--initialize strikrdb
```

* Performance params on pgbench - `pgbench --debug --host=127.0.0.1 --port=5432 --username=postgres --client=100 --connect --jobs=2 --no-vacuum --report-latencies --scale=2 --time=2 --log strikrdb`

```Text
scaling factor: 1
query mode: simple
number of clients: 100
number of threads: 2
duration: 2 s
number of transactions actually processed: 247
latency average = 1012.103 ms
tps = 98.804147 (including connections establishing)
tps = 99.365006 (excluding connections establishing)
statement latencies in milliseconds:
         0.347  \set aid random(1, 100000 * :scale)
         0.088  \set bid random(1, 1 * :scale)
         0.092  \set tid random(1, 10 * :scale)
         0.110  \set delta random(-5000, 5000)
        46.426  BEGIN;
        13.586  UPDATE pgbench_accounts SET abalance = abalance + :delta WHERE aid = :aid;
         9.069  SELECT abalance FROM pgbench_accounts WHERE aid = :aid;
       660.726  UPDATE pgbench_tellers SET tbalance = tbalance + :delta WHERE tid = :tid;
        79.051  UPDATE pgbench_branches SET bbalance = bbalance + :delta WHERE bid = :bid;
         2.235  INSERT INTO pgbench_history (tid, bid, aid, delta, mtime) VALUES (:tid, :bid, :aid, :delta, CURRENT_TIMESTAMP);
         5.608  END;
```

* pgbench - reflects configuration of system catalog for a particular database. With this output, we can tweak/optimize the database operations for our usecase.

* WROC - Workload Resource Optimization Contention

* `select locktype,database,relation,pid,mode,granted from pg_locks where pid != pg_backend_pid()`;

* **pgbench** - simulate a lot of client connections, transactions and operations.

* `foreing key constraints` - perf hit

---

## PG extensions

* `select * from pg_available_extensions;`
* Change configuration of postgresql and execute the following query `select pg_reload_conf();`
* For every extension we need the following files `ext_name.so`, `libpg_ext_name.so`, `ext_name.control`. Update the path containing these .so files in the postgresql PATH.
* `show is_superuser;` - if the current user is superuser.
* `CREATE EXTENSION [ IF NOT EXISTS ] extension_name;` (.so and .control files of those extensions should be in the PATH)

* `pg_stat_statements` - external extension.

## Catalog query usecase

* Given a database 'db', we want to predict which are the top 10 queries that are fired when a postgresql DBA admin session very high load.
* Recognize the pattern of the SQL queries, correlate with the alert fire those 10 queries, collect the data and send out an email to the DBgroup.
