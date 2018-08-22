DELIMITER //

CREATE PROCEDURE my_debug(dbg_msg VARCHAR(1024))
BEGIN
  IF my_debug_enabled THEN
    SELECT CONCAT('DEBUG: ', dbg_msg);
  END IF;
END //

DELIMITER ;
