CREATE FUNCTION getPassReqStr() RETURNS VARCHAR(512)
  READS SQL DATA
BEGIN
  DECLARE not_found   BOOLEAN      DEFAULT FALSE;
  DECLARE var_name    VARCHAR(128) DEFAULT NULL;
  DECLARE var_value   VARCHAR(128) DEFAULT NULL;
  DECLARE pw_chk_un   BOOLEAN      DEFAULT FALSE;
  DECLARE pw_dict     BOOLEAN      DEFAULT FALSE;
  DECLARE pw_len      INTEGER      DEFAULT 8;
  DECLARE pw_mixc_cnt INTEGER      DEFAULT 1;
  DECLARE pw_num_cnt  INTEGER      DEFAULT 1;
  DECLARE pw_policy   VARCHAR(6)   DEFAULT '';
  DECLARE pw_spch_cnt INTEGER      DEFAULT 1;
  DECLARE msg         VARCHAR(512) DEFAULT 'The password of MySQL users must:\n';
  DECLARE vp_opts CURSOR FOR
  SELECT variable_name, variable_value
    FROM performance_schema.global_variables
   WHERE variable_name IN ('validate_password_check_user_name',
                           'validate_password_dictionary_file',
                           'validate_password_length',
                           'validate_password_mixed_case_count',
                           'validate_password_number_count',
                           'validate_password_policy',
                           'validate_password_special_char_count');
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET not_found = TRUE;

  OPEN vp_opts;

  opts_loop: LOOP
    FETCH vp_opts INTO var_name, var_value;

    IF not_found THEN
      LEAVE opts_loop;
    END IF;

    CASE
      WHEN var_name = 'validate_password_check_user_name' AND var_value = 'ON' THEN
        SET pw_chk_un = TRUE;
      WHEN var_name = 'validate_password_dictionary_file' AND var_value != '' THEN
        SET pw_dict = TRUE;
      WHEN var_name = 'validate_password_length' THEN
        SET pw_len = var_value;
      WHEN var_name = 'validate_password_mixed_case_count' THEN
        SET pw_mixc_cnt = var_value;
      WHEN var_name = 'validate_password_number_count' THEN
        SET pw_num_cnt = var_value;
      WHEN var_name = 'validate_password_policy' THEN
        SET pw_policy = var_value;
      WHEN var_name = 'validate_password_special_char_count' THEN
        SET pw_spch_cnt = var_value;
    END CASE;
  END LOOP;

  CLOSE vp_opts;

  SET msg = CONCAT(msg, ' - be at least ', pw_len, ' characters long;\n');

  IF pw_mixc_cnt > 0 THEN
    SET msg = CONCAT(msg, ' - have at least ', pw_mixc_cnt, ' mixed case');

    IF pw_mixc_cnt > 1 THEN
      SET msg = CONCAT(msg, ' letters;\n');
    ELSE
      SET msg = CONCAT(msg, ' letter;\n');
    END IF;
  END IF;

  IF pw_num_cnt > 0 THEN
    SET msg = CONCAT(msg, ' - have at least ', pw_num_cnt);

    IF pw_num_cnt > 1 THEN
      SET msg = CONCAT(msg, ' numbers;\n');
    ELSE
      SET msg = CONCAT(msg, ' number;\n');
    END IF;
  END IF;

  IF pw_spch_cnt > 0 THEN
    SET msg = CONCAT(msg, ' - have at least ', pw_spch_cnt, ' punctuation');

    IF pw_spch_cnt > 1 THEN
      SET msg = CONCAT(msg, ' marks;\n');
    ELSE
      SET msg = CONCAT(msg, ' mark;\n');
    END IF;
  END IF;

  IF pw_dict THEN
    SET msg = CONCAT(msg, ' - not be a dictionary word;\n');
  END IF;

  IF pw_chk_un THEN
    SET msg = CONCAT(msg, ' - not match user name;\n');
  END IF;

  SET msg = CONCAT(msg, 'Current password policy is ''', pw_policy, '''.');

  RETURN msg;
END