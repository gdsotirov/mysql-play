DELIMITER //

CREATE FUNCTION mask_outer(str VARCHAR(128), from_left INTEGER, from_right INTEGER)
    RETURNS VARCHAR(128) CHARSET utf8
    NO SQL
    DETERMINISTIC
BEGIN
  DECLARE str_len INTEGER DEFAULT LENGTH(str);
  DECLARE res_str VARCHAR(128) DEFAULT '';

  IF str_len <= from_left + from_right THEN
    SET res_str := REPEAT('X', str_len);
  ELSE
    SET res_str := CONCAT(REPEAT('X', from_left),
                          SUBSTR(str, from_left + 1, str_len - from_left - from_right),
                          REPEAT('X', from_right)
                         );
  END IF;

  RETURN res_str;
END //

DELIMITER ;
