ALTER TABLE emp
  ADD CONSTRAINT emp_chks CHECK (sal > 0);

ALTER TABLE emp DROP CHECK emp_chks;

ALTER TABLE emp
  MODIFY COLUMN created DATE DEFAULT (CURDATE()),
  ADD CONSTRAINT emp_chks CHECK (hiredate >= created AND sal > 0);

ALTER TABLE emp
  ADD COLUMN created DATE DEFAULT (hiredate);

ALTER TABLE emp
  DROP COLUMN created,
  DROP CHECK emp_chks;

select * from emp;

INSERT INTO emp
  (empno, ename, job, mgr, hiredate, sal, created)
VALUES
  (9999, 'MULDER', 'INVESTIG.', 7839, '2019-04-25', 4242, CURDATE());

ALTER TABLE emp
  ADD COLUMN retdate DATE NULL AFTER hiredate,
  ADD CONSTRAINT ret_after_hire CHECK (retdate > hiredate);

ALTER TABLE emp
  DROP COLUMN retdate,
  DROP CHECK ret_after_hire;

UPDATE emp SET retdate = STR_TO_DATE('1919-04-25', '%Y-%m-%d') WHERE empno = 7369;

SELECT * FROM emp WHERE retdate <= hiredate;

select * from INFORMATION_SCHEMA.CHECK_CONSTRAINTS;
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'CHECK';