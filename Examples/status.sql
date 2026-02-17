/* Emulation of MySQL client's status command */

WITH
  global_variables  AS (SELECT * FROM performance_schema.global_variables),
  global_status     AS (SELECT * FROM performance_schema.global_status),
  session_status    AS (SELECT * FROM performance_schema.session_status),
  session_variables AS (SELECT * FROM performance_schema.session_variables),
  thread_info       AS (SELECT * FROM performance_schema.threads WHERE PROCESSLIST_ID = CONNECTION_ID()),
  smin  AS (SELECT 60 AS secs), /* seconds in a minute */
  shour AS (SELECT smin.secs * 60 AS secs FROM smin), /* seconds in an hour */
  sday  AS (SELECT shour.secs * 24 AS secs FROM shour), /* seconds in a day */
  gs    AS (SELECT VARIABLE_VALUE AS uptime FROM global_status WHERE VARIABLE_NAME = 'Uptime'),
  days  AS (SELECT FLOOR(gs.uptime / sday.secs) AS d, /* number of days */
                   FLOOR(gs.uptime / sday.secs) * sday.secs AS dsec /* number of days as seconds */
              FROM gs, sday),
  hours AS (SELECT FLOOR((gs.uptime - days.dsec) / shour.secs) AS h, /* number of hours */
                   FLOOR((gs.uptime - days.dsec) / shour.secs) * shour.secs AS hsec /* number of hours as seconds */
              FROM shour, sday, gs, days),
  mins  AS (SELECT FLOOR((gs.uptime - days.dsec - hours.hsec) / smin.secs) AS m,
                   FLOOR((gs.uptime - days.dsec - hours.hsec) / smin.secs) * smin.secs AS msec
              FROM smin, shour, sday, gs, days, hours),
  secs  AS (SELECT gs.uptime - days.dsec - hours.hsec - mins.msec AS s
              FROM gs, days, hours, mins)
SELECT CONCAT('Connection id:', REPEAT(' ', 10), CONNECTION_ID()) AS "status"
UNION
SELECT CONCAT('Current database:', REPEAT(' ', 7),
  CASE WHEN DATABASE() IS NULL THEN '' ELSE DATABASE() END)
UNION
SELECT CONCAT('Current user:', REPEAT(' ', 11), USER())
UNION
SELECT CONCAT('SSL:', REPEAT(' ', 20),
       CASE IFNULL(VARIABLE_VALUE, '')
         WHEN '' THEN 'Not in use'
         ELSE CONCAT('Cipher in use is ', VARIABLE_VALUE)
       END)
  FROM session_status
 WHERE VARIABLE_NAME = 'Ssl_cipher'
UNION
SELECT CONCAT('Server version:', REPEAT(' ', 9), VERSION(), ' ', VARIABLE_VALUE)
  FROM global_variables
 WHERE VARIABLE_NAME = 'version_comment'
UNION
SELECT CONCAT('Protocol version:', REPEAT(' ', 7), VARIABLE_VALUE)
  FROM session_variables
 WHERE VARIABLE_NAME = 'protocol_version'
UNION
SELECT CONCAT('Connection:', REPEAT(' ', 13),
       CASE CONNECTION_TYPE
         WHEN 'Socket' THEN 'Localhost via UNIX socket'
         ELSE CONCAT(PROCESSLIST_HOST, ' via TCP/IP')
       END)
  FROM thread_info
UNION
SELECT CONCAT('Server characterset:', REPEAT(' ', 4), VARIABLE_VALUE)
  FROM global_variables
 WHERE VARIABLE_NAME = 'character_set_server'
UNION
SELECT CONCAT('Db     characterset:', REPEAT(' ', 4), VARIABLE_VALUE)
  FROM global_variables
 WHERE VARIABLE_NAME = 'character_set_database'
UNION
SELECT CONCAT('Client characterset:', REPEAT(' ', 4), VARIABLE_VALUE)
  FROM session_variables
 WHERE VARIABLE_NAME = 'character_set_client'
UNION
SELECT CONCAT('Conn.  characterset:', REPEAT(' ', 4), VARIABLE_VALUE)
  FROM session_variables
 WHERE VARIABLE_NAME = 'character_set_connection'
UNION
SELECT CONCAT(CASE CONNECTION_TYPE
         WHEN 'Socket'
           THEN CONCAT('UNIX socket: ', REPEAT(' ' , 11))
         ELSE CONCAT('TCP port: ', REPEAT(' ', 14))
       END,
       VARIABLE_VALUE)
  FROM performance_schema.session_variables,
       thread_info
 WHERE VARIABLE_NAME = CASE CONNECTION_TYPE
         WHEN 'Socket' THEN 'socket'
         ELSE 'port'
       END
UNION
SELECT CONCAT('Uptime:', REPEAT(' ', 17), days.d, ' days ', hours.h, ' hours ', mins.m, ' min ', secs.s, ' sec ')
  FROM days, hours, mins, secs
UNION
SELECT CONCAT(
         'Threads: ', SUM(CASE
           WHEN VARIABLE_NAME = 'Threads_connected' THEN VARIABLE_VALUE ELSE 0 END), ' ',
         'Questions: ', SUM(CASE
           WHEN VARIABLE_NAME = 'Questions' THEN VARIABLE_VALUE ELSE 0 END), ' ',
         'Slow queries: ', SUM(CASE
           WHEN VARIABLE_NAME = 'Slow_queries' THEN VARIABLE_VALUE ELSE 0 END), ' ',
         'Opens: ', SUM(CASE
           WHEN VARIABLE_NAME = 'Opened_tables' THEN VARIABLE_VALUE ELSE 0 END), ' ',
         'Flush tables: ', SUM(CASE
           WHEN VARIABLE_NAME = 'Flush_commands' THEN VARIABLE_VALUE ELSE 0 END), ' ',
         'Open tables: ', SUM(CASE
           WHEN VARIABLE_NAME = 'Open_tables' THEN VARIABLE_VALUE ELSE 0 END ), ' ',
         'Queries per second avg: ', ROUND(SUM(CASE
           WHEN VARIABLE_NAME = 'Queries' THEN VARIABLE_VALUE ELSE 0 END) / gs.uptime, 3))
  FROM global_status, gs
 WHERE VARIABLE_NAME IN ('Flush_commands', 'Open_tables', 'Opened_tables', 'Queries',
                         'Questions', 'Slow_queries', 'Threads_connected');