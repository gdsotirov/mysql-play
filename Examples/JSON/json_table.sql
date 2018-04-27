SELECT *
  FROM JSON_TABLE('[{"id": 10,"loc": "NEW YORK","dname": "ACCOUNTING"},...',
         "$[*]" COLUMNS (
           id    INT         PATH "$.id",
           dname VARCHAR(32) PATH "$.dname",
           loc   VARCHAR(32) PATH "$.loc"
         )
       ) AS json_dept
 WHERE id > 10
;
