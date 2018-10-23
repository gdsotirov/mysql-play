/* Functions or expressions as default values as of MySQL 8.0.13 */

CREATE TABLE def_expr (
  id        INT           NOT NULL AUTO_INCREMENT,
  uuid_def  BINARY(16)    DEFAULT (uuid_to_bin(uuid())),
  geo_def   POINT         DEFAULT (Point(0,0)),
  geo_def2  GEOMETRY      DEFAULT (ST_PointFromText('POINT(42.69751 23.32415)', 4326)),
  json_def  JSON          DEFAULT (JSON_ARRAY()),
  json_def2 JSON          DEFAULT ('[]') /* this works too */,
  tomorrow  DATE          DEFAULT (CURDATE() + INTERVAL 1 DAY),
  radius    INT           DEFAULT (FLOOR(1 + (RAND() * 10))),
  area      DECIMAL(10,3) DEFAULT (ROUND(PI() * POW(radius, 2), 3)),

  PRIMARY KEY (id),
  UNIQUE INDEX id_UNIQUE (id ASC) VISIBLE
);

INSERT INTO def_expr VALUES ();

SELECT id,
       bin_to_uuid(uuid_def) uuid_def,
       ST_AsText(geo_def)    geo_def,
       ST_AsText(geo_def2)   geo_def2,
       json_def, json_def2,
       tomorrow, radius, area
  FROM def_expr;