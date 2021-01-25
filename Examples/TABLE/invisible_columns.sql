/* Invisible columns are available since MySQL 8.0.23
 * See https://dev.mysql.com/doc/refman/8.0/en/invisible-columns.html
 */

DROP TABLE IF EXISTS party;

CREATE TABLE party (
  fname VARCHAR(16),
  lname VARCHAR(32)
);

SELECT * FROM party;

/* selects columns fname and lname */

ALTER TABLE party
  ADD COLUMN id INT NOT NULL AUTO_INCREMENT INVISIBLE FIRST,
  ADD CONSTRAINT pk_party PRIMARY KEY (id);

SELECT * FROM party;

/* still selects only columns fname and lname */

DESC party;

SELECT ORDINAL_POSITION, COLUMN_NAME, EXTRA
  FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA = DATABASE()
   AND TABLE_NAME   = 'party';

/* shows INVISIBLE in Extra/EXTRA column for id */

SELECT id, fname, lname
  FROM party;

/* selects id (invisible), fname and lname (visible) columns */

ALTER TABLE party
  ADD COLUMN bdate DATE NOT NULL INVISIBLE AFTER lname;

INSERT INTO party (fname, lname)
VALUES ('John', 'Smith');

/* an invisible column that is NOT NULL would reveal itself even if not
 * referenced epplicitly in INSERT with
 * Error Code: 1364. Field 'bdate' doesn't have a default value
 */

