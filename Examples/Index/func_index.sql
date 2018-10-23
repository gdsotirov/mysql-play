CREATE TABLE func_index (
  id        INT        NOT NULL AUTO_INCREMENT,
  ipaddr4   INT UNSIGNED /* 4 bytes */,

  PRIMARY KEY (id),
  UNIQUE INDEX id_UNIQUE (id ASC) VISIBLE,
  INDEX func_idx ((INET_NTOA(ipaddr4)))
);

INSERT INTO func_index (ipaddr4) VALUES (INET_ATON('192.168.1.1'));

SELECT * FROM func_index WHERE ipaddr4 = INET_ATON('192.168.1.1');  /* Full Table Scan */
SELECT * FROM func_index WHERE INET_NTOA(ipaddr4) = '192.168.1.1';  /* Non-Unique Key Lookup func_idx */
