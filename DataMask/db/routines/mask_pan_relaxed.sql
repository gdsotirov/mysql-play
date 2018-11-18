DELIMITER //

CREATE FUNCTION mask_pan_relaxed(pan VARCHAR(19))
    RETURNS VARCHAR(19) CHARSET utf8
    NO SQL
    DETERMINISTIC
BEGIN
  /* Payment account numbers are betweeen 8 and 19 digits
   * See https://en.wikipedia.org/wiki/Payment_card_number
   */
  IF LENGTH(pan) >= 8 AND LENGTH(pan) <= 19 THEN
    RETURN mask_inner(pan, 6, 4);
  ELSE
    RETURN pan;
  END IF;
END //

DELIMITER ;
