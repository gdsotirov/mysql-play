DELIMITER //

CREATE FUNCTION mask_ssn(ssn VARCHAR(12))
    RETURNS VARCHAR(12) CHARSET utf8
    NO SQL
    DETERMINISTIC
BEGIN
  DECLARE ssn_len INTEGER DEFAULT LENGTH(ssn);
  DECLARE res_str VARCHAR(12) DEFAULT '';

  IF ssn RLIKE '^[0-9]+$' THEN /* if passed as number */
    SET res_str := mask_inner(ssn, 0, 4);
  ELSEIF ssn RLIKE '^[0-9]{3}-[0-9]{2}-[0-9]{4}$' THEN /* if passed as ###-##-#### */
    SET res_str := mask_outer(mask_inner(ssn, 4, 5), 3, 0);
  ELSE /* not recognized SSN */
    SET res_str := '???-??-????';
  END IF;

  RETURN res_str;
END //

DELIMITER ;
