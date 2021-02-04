SELECT JSON_PRETTY(
         JSON_ARRAYAGG(
           JSON_OBJECT("id"   , deptno,
                       "dname", dname,
                       "loc"  , loc
                      )
         )
       ) jsn
  FROM dept;

