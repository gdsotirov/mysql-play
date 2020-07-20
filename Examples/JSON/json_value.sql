/* Added in MySQL 8.0.21
 * See https://dev.mysql.com/doc/refman/8.0/en/json-search-functions.html#function_json-value
 * JSON_VALUE(json_doc, path RETURNING type) is equivalent to
 * CAST(JSON_UNQUOTE(JSON_EXTRACT(json_doc, path)) AS type)
 */

SELECT JSON_VALUE('{"id": "1", "name": "Item 1", "price": "12.34"}',
                  '$.name'  RETURNING CHAR)         AS jv_name,
       CAST(
         JSON_UNQUOTE(
           JSON_EXTRACT('{"id": "1", "name": "Item 1", "price": "12.34"}',
                        '$.name')
         )
         AS CHAR
       )                                            AS cast_name,
       JSON_VALUE('{"id": "1", "name": "Item 1", "price": "12.34"}',
                  '$.price' RETURNING DECIMAL(5,2)) AS jv_price,
       CAST(
         JSON_UNQUOTE(
           JSON_EXTRACT('{"id": "1", "name": "Item 1", "price": "12.34"}',
                        '$.price')
         )
         AS DECIMAL(5,2)
       )                                            AS cast_prince;

/* JSON_VALUE simplifies index creation, because it removes the need for
 * adding a generated column and then an index on it.
 */

CREATE TABLE docs1 (
  doc_data  JSON,
  doc_id    INT GENERATED ALWAYS AS (JSON_UNQUOTE(JSON_EXTRACT(doc_data, '$.id'))),
  INDEX pk_docs (doc_id)
);

/* And with JSON_VALUE and functional index the previous becomes */

CREATE TABLE docs2 (
  doc_data  JSON,
  INDEX pk_docs ( (JSON_VALUE(doc_data, '$.id' RETURNING UNSIGNED)) )
);

/* Load some data */

INSERT INTO docs1 (doc_data)
VALUES ('{"id": "1", "name": "Item 1", "price": "12.34"}'),
       ('{"id": "2", "name": "Item 2", "price": "56.78"}');

INSERT INTO docs2 SELECT doc_data FROM docs1;

/* To use the index with generated column ... */

SELECT * FROM docs1 WHERE doc_id = 1;

/* and without generated column as functional index */

SELECT * FROM docs2 WHERE JSON_VALUE(doc_data, '$.id' RETURNING UNSIGNED) = 2;

