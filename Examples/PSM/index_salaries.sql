DELIMITER //

CREATE PROCEDURE index_salaries(percent DECIMAL(5,2))
BEGIN
  DECLARE emp_id INTEGER;
  DECLARE emp_sal DECIMAL(10,2);
  DECLARE new_sal DECIMAL(10,2);
  DECLARE done BOOLEAN DEFAULT FALSE;
  DECLARE emps CURSOR FOR
  SELECT empno, sal
    FROM emp;
  DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET done := TRUE;

  OPEN emps;

  emps_loop: LOOP
    FETCH emps INTO emp_id, emp_sal;
    IF done THEN
      LEAVE emps_loop;
    END IF;
    SET new_sal := emp_sal
                   + (emp_sal*percent/100);
    UPDATE emp
       SET sal = new_sal
     WHERE empno = emp_id;
    /* Log the increase */
    INSERT INTO sal_changes (empno, sal, since)
    VALUES (emp_id, new_sal, CURDATE());
  END LOOP;

  CLOSE emps;
END //

DELIMITER ;
