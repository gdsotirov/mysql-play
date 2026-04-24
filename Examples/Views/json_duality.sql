/* MySQL 9.4.0: MySQL now supports JSON duality views, which provide a way
 * to expose data stored in relational tables as multi-level JSON documents.
 * See https://dev.mysql.com/doc/relnotes/mysql/9.4/en/news-9-4-0.html#mysqld-9-4-0-json-views
 * See https://dev.mysql.com/doc/refman/9.6/en/json-creation-functions.html#function_json-duality-object
 * MySQL 9.7.0: MySQL Community Server now supports DML operations on JSON
 * Duality Views, enabling users to perform insert, update, and delete
 * operations on these views.
 * See https://dev.mysql.com/doc/relnotes/mysql/9.7/en/news-9-7-0.html#mysqld-9-7-0-json
 */

CREATE OR REPLACE JSON RELATIONAL DUALITY VIEW dept_emp_dv AS
SELECT JSON_DUALITY_OBJECT( WITH(INSERT,UPDATE,DELETE) /* DML */
         '_id'  : deptno, /* must be _id */
         'dname': dname,
         'loc'  : loc,
         'emps' : (SELECT JSON_ARRAYAGG(JSON_DUALITY_OBJECT( WITH(INSERT,UPDATE,DELETE) /* DML */
                     'id'       : empno,
                     'ename'    : ename,
                     'job'      : job,
                     'mgr'      : mgr,
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

/* Create a new department */

INSERT INTO dept_emp_dv
VALUES (JSON_OBJECT("_id", 99, "dname", "REPAIRS", "loc", "Sofia"));

/* Create a new department with employees */

INSERT INTO dept_emp_dv
/* No SELECT with duality views */
VALUES (JSON_OBJECT('_id', 99, 'dname', 'REPAIRS', 'loc', 'Sofia',
        'emps', JSON_ARRAY(
          JSON_OBJECT('id', 9991, 'ename', 'ME' , 'job', 'MANAGER' , 'mgr', 7839, 'hiredate', '2006-12-01'),
          JSON_OBJECT('id', 9992, 'ename', 'YOU', 'job', 'REPAIRER', 'mgr', 9991, 'hiredate', '2007-07-01'),
          JSON_OBJECT('id', 9993, 'ename', 'WE' , 'job', 'REPAIRER', 'mgr', 9991, 'hiredate', '2008-01-01') )));

/* Check new data */

SELECT * FROM dept WHERE deptno = 99;
SELECT * FROM emp WHERE deptno = 99;

