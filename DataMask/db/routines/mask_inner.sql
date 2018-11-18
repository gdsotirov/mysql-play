DELIMITER //

CREATE FUNCTION mask_inner(str VARCHAR(128), margin_left INTEGER, margin_right INTEGER)
    RETURNS VARCHAR(128) CHARSET utf8
    NO SQL
    DETERMINISTIC
BEGIN
  DECLARE str_len INTEGER DEFAULT LENGTH(str);
  DECLARE res_str VARCHAR(128) DEFAULT '';

  IF @mask_character IS NULL THEN
    SET @mask_character := 'X';
  END IF;

  IF margin_left < 0 OR margin_right < 0 THEN
    SET res_str := NULL;
  ELSEIF str_len < margin_left + margin_right THEN
    SET res_str := str;
  ELSE
    SET res_str := CONCAT(SUBSTR(str, 1, margin_left),
                          REPEAT(@mask_character, str_len - margin_left - margin_right),
                          REVERSE(SUBSTR(REVERSE(str), 1, margin_right))
                         );
  END IF;

  RETURN res_str;
END //

DELIMITER ;
