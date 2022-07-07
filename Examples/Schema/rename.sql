/* RENAME {DATABASE | SCHEMA} statement was added in MySQL 5.1.17, but
 * was removed in 5.1.23 due to “serious problems”.
 * The workaround is
 */

CREATE DATABASE new_db_name;
RENAME TABLE db_name.table1 TO new_db_name.table1,
             db_name.table2 TO new_db_name.table2;
DROP DATABASE db_name;
