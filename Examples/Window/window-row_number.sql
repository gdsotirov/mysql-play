/* ROW_NUMBER() works per partition ! */

SELECT ROW_NUMBER() OVER() AS rnum,
       dname
  FROM dept
 LIMIT 2;

SELECT ROW_NUMBER() OVER() AS rnum,
       dname
  FROM dept
 LIMIT 2 OFFSET 2;
