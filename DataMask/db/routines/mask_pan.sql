DELIMITER //

CREATE FUNCTION mask_pan(pan VARCHAR(20))
    RETURNS VARCHAR(20) CHARSET utf8
    NO SQL
    DETERMINISTIC
BEGIN
  /* Payment account numbers are betweeen 8 and 19 digits
   * See https://en.wikipedia.org/wiki/Payment_card_number
   */
  RETURN mask_inner(pan, 0, 4);
END //

DELIMITER ;
