DELIMITER //

CREATE PROCEDURE my_test_debug(IN a INTEGER, IN b INTEGER, OUT res INTEGER)
BEGIN
  CALL my_debug(CONCAT('enter my_test_debug(', a, ', ', b, ')'));

  SET res := a + b;

  CALL my_debug(CONCAT('exit my_test_debug(), res = ', res));
END //

DELIMITER ;

