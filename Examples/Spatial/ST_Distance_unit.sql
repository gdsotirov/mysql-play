/* MySQL 8.0.14: A new optional argument of ST_Distance for unit of the result */

SELECT * FROM INFORMATION_SCHEMA.ST_UNITS_OF_MEASURE;

SELECT ST_Distance(ST_PointFromText('POINT( 42.69751 23.32415)', 4326),
                   ST_PointFromText('POINT(-33.86667 151.20000)', 4326)) / 1000 dist_km;

SELECT ST_Distance(ST_PointFromText('POINT( 42.69751 23.32415)', 4326),
                   ST_PointFromText('POINT(-33.86667 151.20000)', 4326), 'nautical mile') dist_nm;
