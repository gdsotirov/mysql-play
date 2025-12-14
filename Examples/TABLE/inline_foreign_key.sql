/* MySQL 9.0.0: MySQL now accepts and enforces inline foreign key
 * specifications just like for primary keys. These were previously accepted
 * by the parser, but silently ignored. And it also accepts implicit
 * references to parent table primary key columns if column is omitted.
 * See https://dev.mysql.com/doc/refman/9.0/en/create-table-foreign-keys.html
 */

/* Taking as example the schema from Examples/Schema/dept_emp.sql,
 * we modify the emp table definition to use inline foreign key syntax.
 */

CREATE TABLE emp (
  empno    INTEGER PRIMARY KEY,
  ename    VARCHAR(10),
  job      VARCHAR(9),
  mgr      INTEGER,
  hiredate DATE,
  sal      DECIMAL(7,2),
  comm     DECIMAL(7,2),
  deptno   INTEGER REFERENCES dept (deptno) /* inline foreign key */
);

/* And the column name in the REFERENCES clause can be omitted
 * when it references the parent table primary key.
 */

CREATE TABLE emp (
  empno    INTEGER PRIMARY KEY,
  ename    VARCHAR(10),
  job      VARCHAR(9),
  mgr      INTEGER,
  hiredate DATE,
  sal      DECIMAL(7,2),
  comm     DECIMAL(7,2),
  deptno   INTEGER REFERENCES dept /* ... to the parent table's primary key */
);

