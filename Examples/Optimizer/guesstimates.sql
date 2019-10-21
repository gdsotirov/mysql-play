/* Optimizer guestimates for different predicates
 * See "Access Path Selection in a Relational Database Management System" by Selinger et al., 1979
 * https://www2.cs.duke.edu/courses/compsci516/cps216/spring03/papers/selinger-etal-1979.pdf
 * See also https://dev.mysql.com/worklog/task/?id=6635
 */

SELECT E.ename, E.job, D.dname
  FROM dept D,
       emp  E
 WHERE E.deptno = D.deptno;

/* filtered is 100.00% for both D and E */

/* 1. Equality (=): 0.1 or 10.00% */
SELECT E.ename, E.job, D.dname
  FROM dept D,
       emp  E
 WHERE E.deptno = D.deptno
   AND E.job    = 'CLERK';

/* filtered is 10.00% for E */

/* 2. Greater/Less than or equal to (>, <, >=, <= ): 0.33 or 33.33% */
SELECT E.ename, E.job, D.dname
  FROM dept D,
       emp  E
 WHERE E.deptno   = D.deptno
   AND E.hiredate < '1981-09-01';

/* filtered is 33.33% for E */

/* 3. BETWEEN ... AND ... : 0.11 or 11.11% */
/* Note: By Selinger it's 1/4 or 0.25 or 25% */
SELECT E.ename, E.job, D.dname
  FROM dept D,
       emp  E
 WHERE E.deptno = D.deptno
   AND E.hiredate BETWEEN '1981-09-01' AND '1981-11-30';

/* filtered is 11.11% for E */

/* 4. NOT <expr>: 1 - SEL(<expr>) */
SELECT E.ename, E.job, D.dname
  FROM dept D,
       emp  E
 WHERE E.deptno  = D.deptno
   AND NOT E.job = 'CLERK';

/* filtered is 90.00% for E */

/* 5. <exprA> AND <exprB> : P(<exprA>) * P(<exprB>) */
SELECT E.ename, E.job, D.dname
  FROM dept D,
       emp  E
 WHERE E.deptno   = D.deptno
   AND E.job      = 'CLERK'
   AND E.hiredate > '1981-01-01';

/* filtered is 7.14% =  */

/* 5. <exprA> OR <exprB> : P(A) + P(B) - P(A and B) */

SELECT E.ename, E.job, D.dname
  FROM dept D,
       emp  E
 WHERE E.deptno = D.deptno
   AND E.job = 'CLERK'
    OR E.job = 'ANALYST';

/* filtered is 19.00% =  */

