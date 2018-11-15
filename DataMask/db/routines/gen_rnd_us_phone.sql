DELIMITER //

CREATE FUNCTION gen_rnd_us_phone()
    RETURNS CHAR(14) CHARSET utf8
    NO SQL
BEGIN
  DECLARE res_pn VARCHAR(16) DEFAULT '';

  /* See https://en.wikipedia.org/wiki/Social_Security_number */
  SET @gen_rnd_string_characters := '0123456789';
  SET res_pn := CONCAT('1-555-', gen_rnd_string(3), '-', gen_rnd_string(4));
  SET @gen_rnd_string_characters := NULL;

  RETURN res_pn;
END //

DELIMITER ;
