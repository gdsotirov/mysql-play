/* Multi-valued arrays example */
/* See https://dev.mysql.com/doc/refman/8.0/en/create-index.html#create-index-multi-valued */

CREATE TABLE translators (
  id INT AUTO_INCREMENT,
  jdata JSON,

  PRIMARY KEY(id)
);

/* Variant 1 - array of strings */

INSERT INTO translators (jdata)
VALUES ('{"name": "T1", "langs": ["English", "French", "Spanish"]}'),
       ('{"name": "T2", "langs": ["English", "Spanish"]}'),
       ('{"name": "T3", "langs": ["French", "Spanish"]}');

/* Search translators that speak English */
SELECT id, jdata->>'$.name', jdata->'$.langs'
  FROM translators
 WHERE JSON_OVERLAPS(jdata->'$.langs', '["English"]');

SELECT id, jdata->>'$.name', jdata->'$.langs'
  FROM translators
 WHERE 'English' MEMBER OF (jdata->'$.langs');

/* Full table scan */

ALTER TABLE translators
  ADD INDEX idx_langs_arr ((CAST(jdata->'$.langs' AS CHAR(8) ARRAY)));

/* Now the prevoius query has non-unique index lookup */

/* Clean up */

TRUNCATE TABLE translators;
ALTER TABLE translators AUTO_INCREMENT = 1;
ALTER TABLE translators DROP INDEX idx_langs_arr;

/* Variant 2 - array of objects */

INSERT INTO translators (jdata)
VALUES ('{"name": "T1", "langs": [{"lang": "English"}, {"lang": "French"}, {"lang": "Spanish"}]}'),
       ('{"name": "T2", "langs": [{"lang": "English"}, {"lang": "Spanish"}]}'),
       ('{"name": "T3", "langs": [{"lang": "French"}, {"lang": "Spanish"}]}');

SELECT id, jdata->>'$.name', jdata->'$.langs[*].lang'
  FROM translators
 WHERE JSON_OVERLAPS(jdata->'$.langs[*].lang', '["English"]');

SELECT id, jdata->>'$.name', jdata->'$.langs[*].lang'
  FROM translators
 WHERE 'English' MEMBER OF (jdata->'$.langs[*].lang');

ALTER TABLE translators
  ADD INDEX idx_langs_obj ((CAST(jdata->'$.langs[*].lang' AS CHAR(8) ARRAY)));

/* Clean up */

TRUNCATE TABLE translators;
ALTER TABLE translators AUTO_INCREMENT = 1;
ALTER TABLE translators DROP INDEX idx_langs_arr;
