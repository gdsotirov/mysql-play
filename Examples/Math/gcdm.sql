/* Find greatest common divisor (GCD) of two integers by Euclid's algorithm
 * with modulo division
 * See https://en.wikipedia.org/wiki/Euclidean_algorithm
 */
DELIMITER //

CREATE FUNCTION gcdm(a INT, b INT) RETURNS INT
    NO SQL
    DETERMINISTIC
BEGIN
  DECLARE ai INTEGER DEFAULT a;
  DECLARE bi INTEGER DEFAULT b;
  DECLARE t  INTEGER;

  WHILE ( bi <> 0 ) DO
    SET t := bi;
    SET bi := ai % bi;
    SET ai := t;
  END WHILE;

  RETURN ai;
END //

DELIMITER ;

