/* MariaDB 10.4.3 extended temporal tables support for application-time periods
 * See https://mariadb.com/docs/server/reference/sql-structure/temporal-tables/application-time-periods
 */

CREATE TABLE emp_sal_apphist (
  empno     INTEGER,
  salary    DOUBLE,
  start_dt  DATETIME NOT NULL DEFAULT NOW(),
  end_dt    DATETIME NOT NULL DEFAULT '9999-12-31 23:59:59',
  CONSTRAINT fk_emp FOREIGN KEY (empno) REFERENCES emp(empno),
  PERIOD FOR validity(start_dt, end_dt),
  PRIMARY KEY (empno, validity WITHOUT OVERLAPS)
);

INSERT INTO emp_sal_apphist
  (empno, salary, start_dt)
VALUES
  (7839, 4000, '2024-11-17');

/* Query OK, 1 row affected (0.0037 sec) */

SELECT * FROM emp_sal_apphist;

/* +-------+--------+---------------------+---------------------+
 * | empno | salary | start_dt            | end_dt              |
 * +-------+--------+---------------------+---------------------+
 * |  7839 |   4000 | 2024-11-17 00:00:00 | 9999-12-31 23:59:59 |
 * +-------+--------+---------------------+---------------------+
 * 1 row in set (0.0007 sec)
 */

UPDATE emp_sal_apphist
   FOR PORTION OF validity FROM '2025-03-01 00:00:00' TO '9999-12-31 23:59:59'
   SET salary = 5000
 WHERE empno = 7839;

/* Query OK, 1 row affected (0.0029 sec)
 * Rows matched: 1  Changed: 1  Inserted: 1  Warnings: 0
 */

SELECT * FROM emp_sal_apphist;

/* +-------+--------+---------------------+---------------------+
 * | empno | salary | start_dt            | end_dt              |
 * +-------+--------+---------------------+---------------------+
 * |  7839 |   4000 | 2024-11-17 00:00:00 | 2025-03-01 00:00:00 |
 * |  7839 |   5000 | 2025-03-01 00:00:00 | 9999-12-31 23:59:59 |
 * +-------+--------+---------------------+---------------------+
 * 2 rows in set (0.0006 sec)
 */

/* New period with matchin start date */

INSERT INTO emp_sal_apphist
  (empno, salary, start_dt)
VALUES
  (7839, 6000, '2025-03-01');

/* ERROR: 1062 (23000): Duplicate entry '7839-9999-12-31 23:59:59-2025-03-01 00:00:00' for key 'PRIMARY' */

/* New overlapping period */

INSERT INTO emp_sal_apphist
  (empno, salary, start_dt, end_dt)
VALUES
  (7839, 7000, '2024-11-18', '2025-02-28');

/* Error Code: 1062. Duplicate entry '7839-2025-02-28 00:00:00-2024-11-18 00:00:00' for key 'PRIMARY' */

/* Current salary */
SELECT salary
  FROM emp_sal_apphist
 WHERE empno = 7839
   AND start_dt <= NOW()
   AND end_dt > NOW();

/* or alternatively with BETWEEN operator */
SELECT salary
  FROM emp_sal_apphist
 WHERE empno = 7839
   AND NOW() BETWEEN start_dt AND end_dt;

/* +--------+
 * | salary |
 * +--------+
 * |   5000 |
 * +--------+
 * 1 row in set (0.0009 sec)
 */

