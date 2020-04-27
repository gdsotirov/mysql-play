/* Description: Sequence calendar dates
 * Requires: MySQL 8.0.1 or later
 */

/* Sequence dates from today till end of year */

WITH RECURSIVE dates(dat) AS
(SELECT CURDATE() AS dat
 UNION ALL
 SELECT DATE_ADD(dat, INTERVAL 1 DAY)
   FROM dates
  WHERE dat < LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 12-MONTH(CURDATE()) MONTH))
)
SELECT dat FROM dates;

/* Sequence dates from today till end of year excluding weekends */

WITH RECURSIVE dates(dat) AS
(SELECT CURDATE() AS dat
 UNION ALL
 SELECT DATE_ADD(dat, INTERVAL 1 DAY)
   FROM dates
  WHERE dat < LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 12-MONTH(CURDATE()) MONTH))
)
SELECT dat
  FROM dates
 WHERE WEEKDAY(dat) NOT IN (5, 6);

/* Sequence dates from day to day */

WITH RECURSIVE
start_dat(dat) AS (SELECT STR_TO_DATE('2020-05-14', '%Y-%m-%d')),
end_dat(dat)   AS (SELECT STR_TO_DATE('2020-12-31', '%Y-%m-%d')),
dates(dat) AS
(SELECT dat FROM start_dat AS dat
 UNION ALL
 SELECT DATE_ADD(dat, INTERVAL 1 DAY)
   FROM dates
  WHERE dat < (SELECT dat FROM end_dat)
)
SELECT dat
  FROM dates
 WHERE WEEKDAY(dat) NOT IN (5, 6);

/* Sequence working days for the year */

WITH RECURSIVE dates(dat) AS(
  SELECT STR_TO_DATE('2020-01-01', '%Y-%m-%d') AS dat
  UNION ALL
  SELECT DATE_ADD(dat, INTERVAL 1 DAY)
    FROM dates
   WHERE dat < STR_TO_DATE('2020-12-31', '%Y-%m-%d')
)
SELECT dat
  FROM dates
 WHERE /* exclude weekends */
       WEEKDAY(dat) NOT IN (5, 6)
       /* exclude public holidays for 2020 */
   AND dat NOT IN (STR_TO_DATE('2020-01-01', '%Y-%m-%d'),
                   STR_TO_DATE('2020-03-03', '%Y-%m-%d'),
                   STR_TO_DATE('2020-04-17', '%Y-%m-%d'),
                   STR_TO_DATE('2020-04-20', '%Y-%m-%d'),
                   STR_TO_DATE('2020-05-01', '%Y-%m-%d'),
                   STR_TO_DATE('2020-05-06', '%Y-%m-%d'),
                   STR_TO_DATE('2020-05-25', '%Y-%m-%d'),
                   STR_TO_DATE('2020-09-07', '%Y-%m-%d'),
                   STR_TO_DATE('2020-09-22', '%Y-%m-%d'),
                   STR_TO_DATE('2020-12-24', '%Y-%m-%d'),
                   STR_TO_DATE('2020-12-25', '%Y-%m-%d'),
                   STR_TO_DATE('2020-12-28', '%Y-%m-%d'));

