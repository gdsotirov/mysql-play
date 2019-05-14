ALTER TABLE emp
  MODIFY COLUMN hiredate DATE CONSTRAINT hiredate_chk CHECK (hiredate >= STR_TO_DATE('1980-01-01', '%Y-%m-%d')),
  ADD CONSTRAINT sal_chk CHECK (sal > 0 AND (comm IS NULL OR comm >= 0));
