DELIMITER //

CREATE FUNCTION calc_luhn(pan VARCHAR(18)) RETURNS INT
    NO SQL
    DETERMINISTIC
BEGIN
  DECLARE pan_len INTEGER DEFAULT LENGTH(pan);
  DECLARE idx INTEGER DEFAULT pan_len;
  DECLARE other_digit INTEGER DEFAULT 0;
  DECLARE sum_digits INTEGER DEFAULT 0;

  /* See https://en.wikipedia.org/wiki/Luhn_algorithm */

  /* 1. From the rightmost digit, which is the check digit, and moving left... */
  WHILE ( idx > 0 ) DO
    IF ( (pan_len - idx) % 2 = 0 ) THEN
      SET other_digit := SUBSTR(pan, idx, 1) * 2; /* ... double every other ... */

      /* ... If the result of this doubling operation is greater than 9 subtract 9 from the product */
      IF other_digit > 9 THEN
        SET other_digit := other_digit - 9;
      END IF;

      SET sum_digits := sum_digits + other_digit;
    ELSE
      SET sum_digits := sum_digits + SUBSTR(pan, idx, 1);
    END IF;

    SET idx := idx - 1;
  END WHILE;

  /* 2. Take the sum of all the digits multiply by 9 and modulo by 10 */
  RETURN ((sum_digits * 9) % 10);
END //

DELIMITER ;
