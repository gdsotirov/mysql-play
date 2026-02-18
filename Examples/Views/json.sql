/* MySQL 5.7.22 added JSON_ARRAYAGG and JSON_OBJECTAGG functions, which
 * allows creation of views returning JSON data from a particular table.
 * See https://dev.mysql.com/doc/relnotes/mysql/5.7/en/news-5-7-22.html#mysqld-5-7-22-feature
 * See https://dev.mysql.com/doc/refman/5.7/en/aggregate-functions.html#function_json-arrayagg
 * See https://dev.mysql.com/doc/refman/5.7/en/aggregate-functions.html#function_json-objectagg
 */

CREATE OR REPLACE VIEW dept_v AS
SELECT JSON_ARRAYAGG(JSON_OBJECT(
        'id'    , deptno,
        'dname' , dname,
        'loc'   , loc
       )) AS `data`
  FROM dept;

CREATE OR REPLACE VIEW emp_v AS
SELECT JSON_ARRAYAGG(JSON_OBJECT(
        'id'      , empno,
        'ename'   , ename,
        'job'     , job,
        'mgr'     , mgr,
        'hiredate', hiredate,
        'sal'     , sal,
        'comm'    , comm,
        'deptno'  , deptno
       )) AS `data`
  FROM emp;

SELECT JSON_PRETTY(`data`) FROM dept_v;
SELECT JSON_PRETTY(`data`) FROM emp_v;

