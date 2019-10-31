/* Create table with sales */

USE dept_emp;

CREATE TABLE sales (
  saleno    INT AUTO_INCREMENT,
  empno     INT,
  sale_date DATE,
  amount    DECIMAL(10,2),

  CONSTRAINT pk_sales PRIMARY KEY (saleno)
);

/* Generate random sales data */

INSERT INTO sales (empno, sale_date, amount)
WITH RECURSIVE sal (id, dat, amt) AS
(SELECT 1                          AS id,
        CAST('1989-01-01' AS DATE) AS dat,
        CAST(100 AS DECIMAL(10,2)) AS amt
 UNION ALL
 SELECT id + 1,
        DATE_ADD(dat, INTERVAL FLOOR(1 + RAND() * 5) DAY),
        FLOOR(100 + RAND() * (1000 + 1 - 100))
   FROM sal
  WHERE YEAR(DATE_ADD(dat, INTERVAL 1 DAY)) < 1990
)
SELECT E.empno, S.dat, S.amt
  FROM sal S,
       (SELECT ROW_NUMBER() OVER() id,
               empno
         FROM (SELECT empno
                 FROM emp
                ORDER BY RAND()
                LIMIT 10000) rnd_emps) E
 WHERE S.id = E.id;

