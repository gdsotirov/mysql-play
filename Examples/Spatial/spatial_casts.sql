/* MySQL 8.0.24: CAST() and CONVERT() functions support casting geometry
 * values from one spatial type to another, for certain combinations of
 * spatial types.
 * See https://dev.mysql.com/doc/refman/8.0/en/cast-functions.html#cast-spatial-types
 */

/*** From Point */

SELECT ST_AsText(CAST(Point(1,1) AS MultiPoint)) AS result;

/* result is MULTIPOINT((1 1)) */

SELECT ST_AsText(CAST(Point(1,1) AS GeometryCollection)) AS result;

/* result is GEOMETRYCOLLECTION(POINT(1 1)) */

/*** From LineString */

SELECT ST_AsText(CAST(LineString(Point(1,1), Point(2,2)) AS Polygon)) AS result;

/* Error Code: 4032. Invalid cast from LINESTRING to POLYGON. */

SELECT ST_AsText(CAST(LineString(Point(1,1), Point(2,2)) AS MultiPoint)) AS result;

/* result is MULTIPOINT((1 1),(2 2)) */

SELECT ST_AsText(CAST(LineString(Point(1,1), Point(2,2)) AS MultiLineString)) AS result;

/* result is MULTILINESTRING((1 1, 2 2)) */

SELECT ST_AsText(CAST(LineString(Point(1,1), Point(2,2)) AS GeometryCollection)) AS result;

/* result is GEOMETRYCOLLECTION(LINESTRING(1 1, 2 2)) */

/*** From Polygon */

SELECT ST_AsText(CAST(Polygon(LineString(Point(0,0),Point(0,3),Point(3,0),Point(0,0)),
                              LineString(Point(1,1),Point(1,2),Point(2,1),Point(1,1)))
                      AS LineString)) AS result;

/* Error Code: 4032. Invalid cast from POLYGON to LINESTRING. */

SELECT ST_AsText(CAST(Polygon(LineString(Point(0,0),Point(0,3),Point(3,0),Point(0,0)),
                              LineString(Point(1,1),Point(1,2),Point(2,1),Point(1,1)))
                      AS MultiLineString)) AS result;

/* result is MULTILINESTRING((0 0,3 0,0 3,0 0),(1 1,1 2,2 1,1 1)) */

SELECT ST_AsText(CAST(Polygon(LineString(Point(0,0),Point(0,3),Point(3,0),Point(0,0)),
                              LineString(Point(1,1),Point(1,2),Point(2,1),Point(1,1)))
                      AS MultiPolygon)) AS result;

/* result is MULTIPOLYGON(((0 0,3 0,0 3,0 0),(1 1,1 2,2 1,1 1))) */

SELECT ST_AsText(CAST(Polygon(LineString(Point(0,0),Point(0,3),Point(3,0),Point(0,0)),
                              LineString(Point(1,1),Point(1,2),Point(2,1),Point(1,1)))
                      AS GeometryCollection)) AS result;

/* result is GEOMETRYCOLLECTION(POLYGON((0 0,3 0,0 3,0 0),(1 1,1 2,2 1,1 1))) */

/*** From MultiPoint */

SELECT ST_AsText(CAST(MultiPoint(Point(1,1),Point(2,2)) AS Point)) AS result;

/* Error Code: 4032. Invalid cast from MULTIPOINT to POINT. */

SELECT ST_AsText(CAST(MultiPoint(Point(1,1),Point(2,2)) AS LineString)) AS result;

/* result is LINESTRING(1 1,2 2) */

SELECT ST_AsText(CAST(MultiPoint(Point(1,1),Point(2,2)) AS GeometryCollection)) AS result;

/* result is GEOMETRYCOLLECTION(POINT(1 1),POINT(2 2)) */

/*** From MultiLineString */

SELECT ST_AsText(CAST(MultiLineString(LineString(Point(0,0),Point(3,0),Point(0,3),Point(0,0)),
                                      LineString(Point(1,1),Point(1,2),Point(2,1),Point(1,1)))
                      AS LineString)) AS result;

/* Error Code: 4032. Invalid cast from MULTILINESTRING to LINESTRING. */

SELECT ST_AsText(CAST(MultiLineString(LineString(Point(0,0),Point(3,0),Point(0,3),Point(0,0)),
                                      LineString(Point(1,1),Point(1,2),Point(2,1),Point(1,1)))
                      AS Polygon)) AS result;

/* result is POLYGON((0 0,3 0,0 3,0 0),(1 1,1 2,2 1,1 1)) */

SELECT ST_AsText(CAST(MultiLineString(LineString(Point(0,0),Point(3,0),Point(0,3),Point(0,0)),
                                      LineString(Point(1,1),Point(1,2),Point(2,1),Point(1,1)))
                      AS MultiPolygon)) AS result;

/* Error Code: 4033. Invalid cast from MULTILINESTRING to MULTIPOLYGON. A polygon ring is in the wrong direction. */

SELECT ST_AsText(CAST(MultiLineString(LineString(Point(0,0),Point(3,0),Point(0,3),Point(0,0)),
                                      LineString(Point(1,1),Point(1,2),Point(2,1),Point(1,1)))
                      AS GeometryCollection)) AS result;

/* result is GEOMETRYCOLLECTION(LINESTRING(0 0,3 0,0 3,0 0),LINESTRING(1 1,1 2,2 1,1 1)) */

/*** From MultiPolygon */

SELECT ST_AsText(CAST(MultiPolygon(Polygon(LineString(Point(0,0),Point(0,3),Point(3,0),Point(0,0)),
                                           LineString(Point(1,1),Point(1,2),Point(2,1),Point(1,1))),
                                   Polygon(LineString(Point(0,0),Point(9,0),Point(9,9),Point(0,9),Point(0,0)),
                                           LineString(Point(5,5),Point(7,5),Point(7,7),Point(5,7),Point(5,5))))
                     AS Polygon)) AS result;

/* Error Code: 4032. Invalid cast from MULTIPOLYGON to POLYGON. */

SELECT ST_AsText(CAST(MultiPolygon(Polygon(LineString(Point(0,0),Point(0,3),Point(3,0),Point(0,0)),
                                           LineString(Point(1,1),Point(1,2),Point(2,1),Point(1,1))),
                                   Polygon(LineString(Point(0,0),Point(9,0),Point(9,9),Point(0,9),Point(0,0)),
                                           LineString(Point(5,5),Point(7,5),Point(7,7),Point(5,7),Point(5,5))))
                     AS MultiLineString)) AS result;

/* Error Code: 4032. Invalid cast from MULTIPOLYGON to MULTILINESTRING. */

SELECT ST_AsText(CAST(MultiPolygon(Polygon(LineString(Point(0,0),Point(0,3),Point(3,0),Point(0,0)),
                                           LineString(Point(1,1),Point(1,2),Point(2,1),Point(1,1))),
                                   Polygon(LineString(Point(0,0),Point(9,0),Point(9,9),Point(0,9),Point(0,0)),
                                           LineString(Point(5,5),Point(7,5),Point(7,7),Point(5,7),Point(5,5))))
                     AS GeometryCollection)) AS result;

/* result is GEOMETRYCOLLECTION(POLYGON((0 0,3 0,0 3,0 0),(1 1,1 2,2 1,1 1)),POLYGON((0 0,10 0,10 10,0 10,0 0),(5 5,5 7,7 7,7 5,5 5))) */

/*** From GeometryCollection */

SELECT ST_AsText(CAST(GeometryCollection(Point(1,1), Point(2,2)) AS MULTIPOINT)) AS result;

/* result is MULTIPOINT((1 1), (2 2)) */

