/* CHECK constraint comparing column with default value is not enforced
 * See https://bugs.mysql.com/bug.php?id=95192
 */

CREATE TABLE tst (
  id INT,
  start_date DATE,
  end_date DATE,
  created DATE DEFAULT (CURDATE()),
  PRIMARY KEY (id),
  CONSTRAINT chk_dat CHECK (start_date >= created)
);

INSERT INTO tst (id, start_date) VALUES (1, '2019-04-29'); /* Suceeds */
INSERT INTO tst (id, start_date) VALUES (2, '2019-04-25'); /* Should fail, but suceeds */

SELECT * FROM tst;
