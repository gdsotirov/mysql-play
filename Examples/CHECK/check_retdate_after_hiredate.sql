ALTER TABLE emp
  ADD COLUMN retdate DATE NULL AFTER hiredate,
  ADD CONSTRAINT ret_after_hire CHECK (retdate > hiredate);

ALTER TABLE emp
  DROP COLUMN retdate,
  DROP CHECK ret_after_hire;

UPDATE emp SET retdate = STR_TO_DATE('1919-04-25', '%Y-%m-%d') WHERE empno = 7369;

SELECT * FROM emp WHERE retdate <= hiredate;