DELIMITER //

CREATE FUNCTION mask_pan_relaxed(pan VARCHAR(20))
    RETURNS VARCHAR(20) CHARSET utf8
    NO SQL
    DETERMINISTIC
BEGIN
  /* Payment account numbers are betweeen 8 and 19 digits
   * See https://en.wikipedia.org/wiki/Payment_card_number
   */
  RETURN mask_inner(pan, 6, 4);
END //

DELIMITER ;
