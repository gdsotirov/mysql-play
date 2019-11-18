DELIMITER //

CREATE PROCEDURE gen_dictionary_load(dictionary_path VARCHAR(256), dictionary_name VARCHAR(32))
BEGIN
  /* Note: Requires CREATE TEMPORARY TABLES and FILE privileges
   * See https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html#priv_create-temporary-tables
   * See https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html#priv_file
   */

  IF dictionary_name NOT RLIKE '^[_a-zA-Z]+$' THEN
    SIGNAL SQLSTATE '99001'
      SET MESSAGE_TEXT = 'Dictionary load error (name not only alpha)';
  END IF;

  SET @create_tmp_table_sttmnt_str := CONCAT('CREATE TEMPORARY TABLE gen_dictionary_', dictionary_name, ' (id INT AUTO_INCREMENT, val VARCHAR(128), PRIMARY KEY (`id`));');

  /* 1. Create a temporary table for the dictionary */
  PREPARE create_tmp_table_sttmnt FROM @create_tmp_table_sttmnt_str;

  EXECUTE create_tmp_table_sttmnt;

  DEALLOCATE PREPARE create_tmp_table_sttmnt;

  /* 2. Load the dictionary file into the temporary table
   * Not possible!
   * Error Code: 1295. This command is not supported in the prepared statement protocol yet
   */
  /*
  SET @load_table_sttmnt_str := CONCAT('LOAD DATA INFILE \'', dictionary_path, '\' ');
  SET @load_table_sttmnt_str := CONCAT(@load_table_sttmnt_str, 'INTO TABLE gen_dictionary_', dictionary_name, ' ');
  SET @load_table_sttmnt_str := CONCAT(@load_table_sttmnt_str, 'LINES TERMINATED BY \'\n\' (val);');

  PREPARE load_table_sttmnt FROM @load_table_sttmnt_str;

  EXECUTE load_table_sttmnt;

  DEALLOCATE PREPARE load_table_sttmnt;*/

  SELECT 'Dictionary load success';
END //

DELIMITER ;
