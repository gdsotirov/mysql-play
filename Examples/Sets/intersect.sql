/* Still not possible

SELECT id, name FROM a
INTERSECT
SELECT id, name FROM b;

but possible with INNER JOIN

*/

SELECT a.id, a.name
  FROM a INNER JOIN b USING (id, name);
