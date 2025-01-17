/* MySQL 8.0.30: The REVOKE statement has IF EXISTS and IGNORE UNKNOWN
 * USER options.
 * See https://dev.mysql.com/doc/refman/8.0/en/revoke.html
 */

/* Create a user without any permissions */

CREATE USER myuser@localhost;

REVOKE SELECT ON *.* FROM myuser@localhost;

/* No error or warning at all */

REVOKE SELECT ON mysql.`user` FROM myuser@localhost;

/* ERROR 1147 (42000): There is no such grant defined for user 'myuser' on host 'localhost' on table 'user' */

REVOKE IF EXISTS SELECT ON mysql.`user` FROM myuser@localhost;

/* SHOW WARNINGS;
 * +---------+------+--------------------------------------------------------------------------------------+
 * | Level   | Code | Message                                                                              |
 * +---------+------+--------------------------------------------------------------------------------------+
 * | Warning | 1147 | There is no such grant defined for user 'myuser' on host 'localhost' on table 'user' |
 * +---------+------+--------------------------------------------------------------------------------------+
 * 1 row in set (0.00 sec)
 */

DROP USER IF EXISTS myuser@localhost;

REVOKE SELECT ON mysql.`user` FROM myuser@localhost;

/* ERROR 1147 (42000): There is no such grant defined for user 'myuser' on host 'localhost' on table 'user' */

/* After user is dropped even IF EXISTS fails */

REVOKE IF EXISTS SELECT ON mysql.`user` FROM myuser@localhost;

/* ERROR 1147 (42000): There is no such grant defined for user 'myuser' on host 'localhost' on table 'user' */

REVOKE SELECT ON mysql.`user` FROM myuser@localhost IGNORE UNKNOWN USER;
/* or */
REVOKE IF EXISTS SELECT ON mysql.`user` FROM myuser@localhost IGNORE UNKNOWN USER;

/* SHOW WARNINGS;
 * show warnings;
 * +---------+------+-----------------------------------------+
 * | Level   | Code | Message                                 |
 * +---------+------+-----------------------------------------+
 * | Warning | 3162 | Authorization ID myuser does not exist. |
 * +---------+------+-----------------------------------------+
 * 1 row in set (0.00 sec)
 */

