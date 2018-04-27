/* Emulate check constraint with trigger and SIGNAL */

USE dept_emp;

DELIMITER /

CREATE TRIGGER check_sal
BEFORE INSERT ON emp
FOR EACH ROW
BEGIN
  IF COALESCE(NEW.sal, 0) <= 0 THEN
    SET @errmsg = 'Salary should be higher!';
    SIGNAL SQLSTATE '12345'
      SET MESSAGE_TEXT = @errmsg;
  END IF;
END /
