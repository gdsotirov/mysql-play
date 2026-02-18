/* MySQL 9.4.0: MySQL now supports JSON duality views, which provide a way
 * to expose data stored in relational tables as multi-level JSON documents.
 * See https://dev.mysql.com/doc/relnotes/mysql/9.4/en/news-9-4-0.html#mysqld-9-4-0-json-views
 * See https://dev.mysql.com/doc/refman/9.6/en/json-creation-functions.html#function_json-duality-object
 */

CREATE OR REPLACE JSON RELATIONAL DUALITY VIEW dept_emp_dv AS
SELECT JSON_DUALITY_OBJECT(
         '_id'  : deptno, /* must be _id */
         'dname': dname,
         'loc'  : loc,
         'emps' : (SELECT JSON_ARRAYAGG(JSON_DUALITY_OBJECT(
                     'id'       : empno,
                     'ename'    : ename,
                     'job'      : job,
                     'hiredate' : hiredate ))
                     FROM emp E
                    WHERE E.deptno = D.deptno
                  )
       )
  FROM dept D;

/* Get deta for a given department and all its exmployees */
SELECT JSON_PRETTY(data)
  FROM dept_emp_dv
 WHERE JSON_EXTRACT(data, '$._id') = (SELECT deptno
                                        FROM dept
                                       WHERE dname = 'ACCOUNTING');

