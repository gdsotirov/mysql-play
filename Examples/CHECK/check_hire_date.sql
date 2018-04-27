/* Emulate check constraint with trigger and SIGNAL */

USE dept_emp;

DELIMITER /

CREATE TRIGGER check_hire_date
BEFORE INSERT ON emp
FOR EACH ROW
BEGIN
  IF NEW.hiredate < CURDATE() THEN
    SET @errmsg = 'Hire date in the past!';
    SIGNAL SQLSTATE '99999'
      SET MESSAGE_TEXT = @errmsg;
  END IF;
END /
