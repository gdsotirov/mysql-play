DELIMITER //

CREATE FUNCTION mask_inner(str VARCHAR(128), from_left INTEGER, from_right INTEGER)
    RETURNS VARCHAR(128) CHARSET utf8
    NO SQL
    DETERMINISTIC
BEGIN
  DECLARE str_len INTEGER DEFAULT LENGTH(str);
  DECLARE res_str VARCHAR(128) DEFAULT '';

  IF @mask_character IS NULL THEN
    SET @mask_character := 'X';
  END IF;

  IF from_left < 0 OR from_right < 0 THEN
    SET res_str := NULL;
  ELSEIF str_len < from_left + from_right THEN
    SET res_str := str;
  ELSE
    SET res_str := CONCAT(SUBSTR(str, 1, from_left),
                          REPEAT(@mask_character, str_len - from_left - from_right),
                          REVERSE(SUBSTR(REVERSE(str), 1, from_right))
                         );
  END IF;

  RETURN res_str;
END //

DELIMITER ;
