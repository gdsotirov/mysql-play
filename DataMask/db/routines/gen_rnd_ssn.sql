DELIMITER //

CREATE FUNCTION get_rnd_ssn()
    RETURNS CHAR(11) CHARSET utf8
    NO SQL
BEGIN
  DECLARE res_ssn VARCHAR(16) DEFAULT '';

  /* See https://en.wikipedia.org/wiki/Social_Security_number */
  SET @gen_rnd_string_characters := '0123456789';
  SET res_ssn := CONCAT(GREATEST(gen_range(1, 665), gen_range(667, 899)), '-',
                        gen_range(1, 99), '-',
                        gen_range(1, 9999));
  SET @gen_rnd_string_characters := NULL;

  RETURN res_ssn;
END //

DELIMITER ;
