DROP PROCEDURE IF EXISTS rename_users_host;

DELIMITER //

CREATE PROCEDURE rename_users_host(IN old_host VARCHAR(64),
                                   IN new_host VARCHAR(64))
BEGIN
  /* Procedure for renaming users' host using cursor to select the affected
   * users, loops it and executes a prepared RENAME USER statement to rename
   * each user.
   * If only MySQL had anonymous code blocks and supported arguments in DDL
   * statements... ah, dreams...
   *
   * See https://dev.mysql.com/doc/refman/8.0/en/account-names.html
   * See https://dev.mysql.com/doc/refman/8.0/en/condition-handling.html
   * See https://dev.mysql.com/doc/refman/8.0/en/cursors.html
   * See https://dev.mysql.com/doc/refman/8.0/en/rename-user.html
   * See https://dev.mysql.com/doc/refman/8.0/en/sql-prepared-statements.html
   * See https://dev.mysql.com/doc/refman/8.0/en/string-literals.html
   */
  DECLARE usr_nm VARCHAR(32) DEFAULT '';
  DECLARE hst_nm VARCHAR(64) DEFAULT '';
  DECLARE done INT DEFAULT FALSE;
  DECLARE usrs_crsr CURSOR FOR
  SELECT `user`, `host`
    FROM mysql.`user`
   WHERE `host` = old_host;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN usrs_crsr;

  SET @nw_hst = new_host;

  ren_loop: LOOP
    FETCH usrs_crsr INTO usr_nm, hst_nm;

    IF done THEN
      LEAVE ren_loop;
    END IF;

    SET @sttmnt = CONCAT('RENAME USER ''', usr_nm, '''@''', hst_nm,
                               ''' TO ''', usr_nm, '''@''', @nw_hst, '''');

    PREPARE ren_usr_sttmnt FROM @sttmnt;

    EXECUTE ren_usr_sttmnt;

    DEALLOCATE PREPARE ren_usr_sttmnt;
  END LOOP;

  CLOSE usrs_crsr;
END //

DELIMITER ;

