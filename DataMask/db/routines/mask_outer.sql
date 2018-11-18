DELIMITER //

CREATE FUNCTION mask_outer(str VARCHAR(128), from_left INTEGER, from_right INTEGER)
    RETURNS VARCHAR(128) CHARSET utf8
    NO SQL
    DETERMINISTIC
BEGIN
  DECLARE str_len INTEGER DEFAULT LENGTH(str);
  DECLARE res_str VARCHAR(128) DEFAULT '';

  IF @mask_character IS NULL THEN
    SET @mask_character := 'X';
  END IF;

  IF str_len <= from_left + from_right THEN
    SET res_str := REPEAT(@mask_character, str_len);
  ELSE
    SET res_str := CONCAT(REPEAT(@mask_character, from_left),
                          SUBSTR(str, from_left + 1, str_len - from_left - from_right),
                          REPEAT(@mask_character, from_right)
                         );
  END IF;

  RETURN res_str;
END //

DELIMITER ;
