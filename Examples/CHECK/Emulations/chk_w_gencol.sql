/* Emulate CHECK constraint with generated column (since MySQL 5.7.6)
 * See http://dasini.net/blog/2019/05/14/check-constraints-in-mysql/ ,
 *     http://mablomy.blogspot.com/2016/04/check-constraint-for-mysql-not-null-on.html , and
 *     https://yoku0825.blogspot.com/2015/08/an-idea-for-using-mysql-57s-generated.html by
 *     the order I found the articles, otherwise they were published in exactly reverse order
 */

CREATE TABLE chk_w_gencol (
  id  INT AUTO_INCREMENT,
  val INT,
  val_check INT GENERATED ALWAYS AS
    (IF(val > 0, val, NULL)) VIRTUAL NOT NULL,
  CONSTRAINT PRIMARY KEY (id)
);
/* Query OK, 0 rows affected */

INSERT INTO chk_w_gencol (val) VALUES (10);
/* Query OK, 1 row affected */

INSERT INTO chk_w_gencol (val) VALUES (-1);
/* ERROR: 1048: Column 'val_check' cannot be null */
