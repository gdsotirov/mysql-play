DELIMITER //

CREATE FUNCTION gen_rnd_string(len INTEGER)
    RETURNS VARCHAR(128) CHARSET utf8
    NO SQL
BEGIN
  /* Based on examples from https://stackoverflow.com/questions/16737910/generating-a-random-unique-8-character-string-using-mysql */
  DECLARE res_str VARCHAR(128) DEFAULT '';
  DECLARE idx INTEGER DEFAULT 1;
  DECLARE chrs_len INTEGER DEFAULT 0;

  IF @gen_rnd_string_characters IS NULL THEN
    SET @gen_rnd_string_characters := 'abcdefghijklmnopqrstuvwxyz';
  END IF;

  SET chrs_len := LENGTH(@gen_rnd_string_characters);

  WHILE ( idx <= len ) DO
    SET res_str := CONCAT(res_str, SUBSTR(@gen_rnd_string_characters, gen_range(1, chrs_len), 1));
    SET idx := idx + 1;
  END WHILE;

  RETURN res_str;
END //

DELIMITER ;
