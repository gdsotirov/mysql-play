/* MySQL 8.0.29: An IF NOT EXISTS option is now supported for the statements
 * CREATE FUNCTION, CREATE PROCEDURE, and CREATE TRIGGER.
 * See https://dev.mysql.com/doc/refman/8.0/en/create-procedure.html
 * See https://dev.mysql.com/doc/refman/8.0/en/create-trigger.html
 */

DELIMITER |

CREATE FUNCTION gsum(a INTEGER, b INTEGER) RETURNS INTEGER NO SQL DETERMINISTIC
BEGIN
  RETURN a + b;
END |

DELIMITER ;

/* 2nd time:
 * ERROR 1304 (42000): FUNCTION gsum already exists
 */

DELIMITER |

CREATE FUNCTION IF NOT EXISTS gsum(a INTEGER, b INTEGER) RETURNS INTEGER NO SQL DETERMINISTIC
BEGIN
  RETURN a + b;
END |

DELIMITER ;

/* 2nd time:
 * SHOW WARNINGS;
 * +-------+------+------------------------------+
 * | Level | Code | Message                      |
 * +-------+------+------------------------------+
 * | Note  | 1304 | FUNCTION gsum already exists |
 * +-------+------+------------------------------+
 * 1 row in set (0.00 sec)
 */

