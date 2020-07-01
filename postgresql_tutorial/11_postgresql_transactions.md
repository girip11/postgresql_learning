# Postgresql Transactions

Transaction has 4 properties coined as **ACID**

* Atomicity - All or none
* Consistency of the database state
* Isolation of transactions.
* Durability of data

* `BEGIN TRANSACTION` or `BEGIN WORK` or `BEGIN` - will start a transaction.
* `COMMIT TRANSACTION` or `COMMIT WORK` or `COMMIT` - will complete a transaction and persist the changes in the database.
* `ROLLBACK TRANSACTION` or `ROLLBACK WORK` or `ROLLBACK` - Rollsback the changes made in the current transaction so far.

```Sql
BEGIN TRANSACTION;

-- transfer 1000 from account with id 1 to 2
UPDATE accounts
SET balance = balance - 1000
WHERE id = 1;

UPDATE accounts
SET balance = balance + 1000
WHERE id = 2;

COMMIT TRANSACTION;

-- if you want to rollback the previous operations
-- because the current operation failed
-- use the rollback command
```

**NOTE**: You cannot roll back a transaction once it has commited. You will need to restore the data from backups, or use point-in-time recovery, which must have been set up before the accident happened - [Rollback a commit](https://stackoverflow.com/questions/12472318/can-i-rollback-a-transaction-ive-already-committed-data-loss).

---

## References

* [Postgresql Transactions](https://www.postgresqltutorial.com/)
