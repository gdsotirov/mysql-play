/* MariaDB 10.3.4 introduced support for system-versioned temporal tables
 * See https://mariadb.com/docs/server/reference/sql-structure/temporal-tables/system-versioned-tables
 */

CREATE TABLE emp_sal_syshist (
  empno     INTEGER PRIMARY KEY,
  salary    DOUBLE,
  start_ts  TIMESTAMP(6) GENERATED ALWAYS AS ROW START INVISIBLE,
  end_ts    TIMESTAMP(6) GENERATED ALWAYS AS ROW END   INVISIBLE,

  CONSTRAINT fk_emp FOREIGN KEY (empno) REFERENCES emp(empno),
  PERIOD FOR SYSTEM_TIME(start_ts, end_ts)
) WITH SYSTEM VERSIONING;

SET @@timestamp = UNIX_TIMESTAMP('2024-11-17');
INSERT INTO emp_sal_syshist (empno, salary) VALUES (7839, 4000);
/* Query OK, 1 row affected (0.0037 sec) */
SET @@timestamp = UNIX_TIMESTAMP('2025-03-01');
UPDATE emp_sal_syshist SET salary = 5000 WHERE empno = 7839;
/* Query OK, 1 row affected (0.0025 sec)
 * Rows matched: 1  Changed: 1  Inserted: 1  Warnings: 0
 */
SET @@timestamp = UNIX_TIMESTAMP('2026-02-01');
UPDATE emp_sal_syshist SET salary = 6000 WHERE empno = 7839;
/* Query OK, 1 row affected (0.0025 sec)
 * Rows matched: 1  Changed: 1  Inserted: 1  Warnings: 0
 */
SET @@timestamp = DEFAULT;

/* Current salary */
SELECT salary
  FROM emp_sal_syshist
 WHERE empno = 7839;

/* +--------+
 * | salary |
 * +--------+
 * |   6000 |
 * +--------+
 * 1 row in set (0.0006 sec)
 */

SELECT salary, start_ts, end_ts
  FROM emp_sal_syshist
   FOR SYSTEM_TIME AS OF NOW()
  WHERE empno = 7839;

/* Same as previous query */

SELECT empno, salary, start_ts, end_ts
  FROM emp_sal_syshist FOR SYSTEM_TIME ALL
 WHERE empno = 7839;

/* +-------+--------+----------------------------+----------------------------+
 * | empno | salary | start_ts                   | end_ts                     |
 * +-------+--------+----------------------------+----------------------------+
 * |  7839 |   4000 | 2024-11-17 00:00:00.000000 | 2025-03-01 00:00:00.000000 |
 * |  7839 |   5000 | 2025-03-01 00:00:00.000000 | 2026-02-01 00:00:00.000000 |
 * |  7839 |   6000 | 2026-02-01 00:00:00.000000 | 2106-02-07 08:28:15.999999 |
 * +-------+--------+----------------------------+----------------------------+
 * 3 rows in set (0.0007 sec)
 */

SELECT salary, start_ts
  FROM emp_sal_syshist
   FOR SYSTEM_TIME AS OF TIMESTAMP'2025-02-01 00:00:00'
 WHERE empno = 7839;

/* +--------+----------------------------+
 * | salary | start_ts                   |
 * +--------+----------------------------+
 * |   4000 | 2024-11-17 00:00:00.000000 |
 * +--------+----------------------------+
 * 1 row in set (0.0008 sec)
 */

SELECT salary, start_ts, end_ts
  FROM emp_sal_syshist
   FOR SYSTEM_TIME FROM TIMESTAMP'2025-04-01 00:00:00' TO NOW()
 WHERE empno = 7839;

/* +--------+----------------------------+----------------------------+
 * | salary | start_ts                   | end_ts                     |
 * +--------+----------------------------+----------------------------+
 * |   5000 | 2025-03-01 00:00:00.000000 | 2026-02-01 00:00:00.000000 |
 * |   6000 | 2026-02-01 00:00:00.000000 | 2106-02-07 08:28:15.999999 |
 * +--------+----------------------------+----------------------------+
 * 2 rows in set (0.0015 sec)
 */

SELECT salary, start_ts, end_ts
  FROM emp_sal_syshist
   FOR SYSTEM_TIME BETWEEN TIMESTAMP'2025-04-01 00:00:00' AND NOW()
 WHERE empno = 7839;

/* +--------+----------------------------+----------------------------+
 * | salary | start_ts                   | end_ts                     |
 * +--------+----------------------------+----------------------------+
 * |   5000 | 2025-03-01 00:00:00.000000 | 2026-02-01 00:00:00.000000 |
 * |   6000 | 2026-02-01 00:00:00.000000 | 2106-02-07 08:28:15.999999 |
 * +--------+----------------------------+----------------------------+
 * 2 rows in set (0.0008 sec)
 */
