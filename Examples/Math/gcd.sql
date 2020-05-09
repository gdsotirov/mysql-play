/* Find greatest common divisor (GCD) of two integers by Euclid's algorithm
 * original version
 * See https://en.wikipedia.org/wiki/Euclidean_algorithm
 */
DELIMITER //

CREATE FUNCTION gcd(a INT, b INT) RETURNS INT
    NO SQL
    DETERMINISTIC
BEGIN
  DECLARE ai INTEGER DEFAULT a;
  DECLARE bi INTEGER DEFAULT b;

  WHILE ( ai <> bi ) DO
    IF ai > bi THEN
      SET ai := ai - bi;
    ELSE
      SET bi := bi - ai;
    END IF;
  END WHILE;

  RETURN ai;
END //

DELIMITER ;

