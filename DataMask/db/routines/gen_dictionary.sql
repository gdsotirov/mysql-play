DELIMITER //

CREATE PROCEDURE gen_dictionary_proc(dictionary_name VARCHAR(32))
BEGIN
  /* 1. Get maximum identifier from the dictionary table */
  SET @get_max_id_sttmnt_str := CONCAT('SELECT MAX(id) INTO @gen_dictionary_maxid FROM gen_dictionary_', dictionary_name);

  PREPARE get_max_id_sttmnt FROM @get_max_id_sttmnt_str;

  EXECUTE get_max_id_sttmnt;

  DEALLOCATE PREPARE get_max_id_sttmnt;

  /* 2. Raad a random value from the dictionary */
  IF @gen_dictionary_maxid IS NOT NULL THEN
    SET @rnd_id := gen_range(1, @gen_dictionary_maxid);

    SET @gen_dict_rnd_sttmnt_str := CONCAT('SELECT val INTO @gen_dictionary_value FROM gen_dictionary_', dictionary_name);
    SET @gen_dict_rnd_sttmnt_str := CONCAT(@gen_dict_rnd_sttmnt_str, ' WHERE id = ?');

     PREPARE gen_dict_rnd_sttmnt FROM @gen_dict_rnd_sttmnt_str;

     EXECUTE gen_dict_rnd_sttmnt USING @rnd_id;

     DEALLOCATE PREPARE gen_dict_rnd_sttmnt;
  END IF;
END //

DELIMITER ;
