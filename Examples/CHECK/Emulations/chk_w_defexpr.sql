/* Emulate CHECK constraint with default expression (since MySQL 8.0.13) */

CREATE TABLE chk_w_defexpr (
  id INT AUTO_INCREMENT,
  val INT,
  val_check INT DEFAULT (IF(val > 0, val, NULL)) NOT NULL,
  CONSTRAINT PRIMARY KEY (id)
);
/* Query OK, 0 rows affected */

INSERT INTO chk_w_defexpr (val) VALUES (10);
/* Query OK, 1 row affected */

INSERT INTo chk_w_defexpr (val) VALUES (-1);
/* ERROR: 1048: Column 'val_check' cannot be null */
