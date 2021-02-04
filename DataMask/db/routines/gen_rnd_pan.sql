DELIMITER //

CREATE FUNCTION gen_rnd_pan()
    RETURNS VARCHAR(19) CHARSET utf8
    NO SQL
BEGIN
  DECLARE res_pan VARCHAR(19) DEFAULT NULL;
  DECLARE idx INTEGER DEFAULT 0;
  DECLARE sum_digits INTEGER DEFAULT 1;

  IF @gen_rnd_pan_len IS NULL THEN
    SET @gen_rnd_pan_len := 16;
  ELSEIF @gen_rnd_pan_len < 12 THEN
    Set res_pan := NULL;
  END IF;

  /*
   * See https://en.wikipedia.org/wiki/Payment_card_number
   * See https://en.wikipedia.org/wiki/ISO/IEC_7812#Major_industry_identifier
   */
  SET @gen_rnd_string_characters := '0123456789';
  SET res_pan := gen_rnd_string(@gen_rnd_pan_len - 1);
  SET @gen_rnd_string_characters := NULL;

  SET res_pan := CONCAT(res_pan, calc_luhn(res_pan));

  RETURN res_pan;
END //

DELIMITER ;
