DELIMITER //

CREATE PROCEDURE gen_dictionary_drop(dictionary_name VARCHAR(32))
BEGIN
  /* Note: Requires CREATE TEMPORARY TABLES privilege
   * See https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html#priv_create-temporary-tables
   */

  IF dictionary_name NOT RLIKE '^[_a-zA-Z]+$' THEN
    SIGNAL SQLSTATE '99002'
      SET MESSAGE_TEXT = 'Dictionary removal error (name not only alpha)';
  END IF;

  SET @drop_tmp_table_sttmnt_str := CONCAT('DROP TEMPORARY TABLE gen_dictionary_', dictionary_name);

  PREPARE drop_tmp_table_sttmnt
     FROM @drop_tmp_table_sttmnt_str;

  EXECUTE drop_tmp_table_sttmnt;

  DEALLOCATE PREPARE drop_tmp_table_sttmnt;

  SELECT 'Dictionary removed';
END //

DELIMITER ;
