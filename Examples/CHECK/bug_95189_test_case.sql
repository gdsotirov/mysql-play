/* CHECK constraint comparing columns is not always enforced with UPDATE queries
 * See https://bugs.mysql.com/bug.php?id=95189
 */

CREATE TABLE tst (
  id INT,
  start_date DATE,
  end_date DATE,
  PRIMARY KEY (id),
  CONSTRAINT chk_dat CHECK (start_date < end_date)
);

INSERT INTO tst (id, start_date, end_date) VALUES (1, '2019-04-25', '2019-04-30');
INSERT INTO tst (id, start_date, end_date) VALUES (2, '2019-04-30', '2019-04-25');

SELECT * FROM tst;

UPDATE tst SET end_date = '2019-04-20' WHERE id = 1;
