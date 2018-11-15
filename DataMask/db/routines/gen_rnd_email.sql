DELIMITER //

CREATE FUNCTION gen_rnd_email()
    RETURNS VARCHAR(32) CHARSET utf8
    NO SQL
BEGIN
  RETURN CONCAT(gen_rnd_string(5), '.', gen_rnd_string(7), '@example.com');
END //

DELIMITER ;
