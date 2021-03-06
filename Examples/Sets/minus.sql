﻿/* Still not possible

SELECT id, name FROM a
MINUS
SELECT id, name FROM b;

but possible with NOT IN

*/

SELECT DISTINCT id, name
  FROM a
 WHERE (id, name) NOT IN
       (SELECT id, name FROM b);

/* or LEFT JOIN */

SELECT DISTINCT a.id, a.name
  FROM a LEFT JOIN b USING (id, name)
WHERE b.id IS NULL

