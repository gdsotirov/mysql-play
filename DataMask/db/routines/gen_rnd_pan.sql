DELIMITER //

CREATE FUNCTION gen_rnd_pan()
    RETURNS CHAR(16) CHARSET utf8
    NO SQL
BEGIN
  DECLARE res_pan CHAR(16) DEFAULT '';

  /* TODO: This is just a string of 16 random numbers starting with a
   * digit different than 0. The PAN possibly won't pass any verification
   * See https://en.wikipedia.org/wiki/Payment_card_number
   */
  SET @gen_rnd_string_characters := '0123456789';
  SET res_pan := CONCAT(gen_range(1, 9), gen_rnd_string(15));
  SET @gen_rnd_string_characters := NULL;

  RETURN res_pan;
END //

DELIMITER ;
