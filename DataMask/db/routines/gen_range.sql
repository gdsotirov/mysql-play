DELIMITER //

CREATE FUNCTION gen_range(range_from INTEGER, range_to INTEGER)
    RETURNS INT(11)
    NO SQL
BEGIN
  DECLARE res INTEGER DEFAULT 0;

  /* See https://dev.mysql.com/doc/refman/8.0/en/mathematical-functions.html#function_rand */
  IF range_from = range_to THEN
    SET res := range_from;
  ELSEIF range_from < range_to THEN
    SET res := FLOOR(range_from + RAND() * (range_to - range_from));
  ELSE
    SET res := NULL;
  END IF;

  RETURN res;
END //

DELIMITER ;
