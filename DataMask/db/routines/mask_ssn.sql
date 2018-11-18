DELIMITER //

CREATE FUNCTION mask_ssn(ssn VARCHAR(11))
    RETURNS VARCHAR(11) CHARSET utf8
    NO SQL
    DETERMINISTIC
BEGIN
  DECLARE ssn_len INTEGER DEFAULT LENGTH(ssn);
  DECLARE res_str VARCHAR(11) DEFAULT '';

  IF ssn_len = 9 AND ssn RLIKE '^[0-9]+$' THEN /* if passed as number */
    SET res_str := mask_inner(ssn, 0, 4);
  ELSEIF ssn_len = 11 AND ssn RLIKE '^[0-9]{3}-[0-9]{2}-[0-9]{4}$' THEN /* if passed as NNN-NN-NNNN */
    SET res_str := mask_outer(mask_inner(ssn, 4, 5), 3, 0);
  ELSE /* not recognized SSN */
    SET res_str := NULL;
  END IF;

  RETURN res_str;
END //

DELIMITER ;
