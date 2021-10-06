/* Q: When des Daylight Saving Time (DST) starts and ends per year and what
 *    is its duration in days and weeks?
 * A: In Bulgaria DST starts on the last Sunday of March and ends on the last
 *    Sunday of October (see [1]), so it is first necessary to determine
 *    the dates and then calculate the duration using MySQL date and time
 *    functions (see [2]).
 *
 * [1] See https://www.timeanddate.com/time/change/bulgaria/sofia
 * [2] See https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html
 */

SELECT yr AS `year`,
       last_sun_mar AS dst_starts,
       last_sun_oct AS dst_ends,
       WEEKOFYEAR(last_sun_mar) dst_starts_wk,
       WEEKOFYEAR(last_sun_oct) dst_ends_wk,
       DATEDIFF(last_sun_oct, last_sun_mar) dst_days,
       WEEKOFYEAR(last_sun_oct) - WEEKOFYEAR(last_sun_mar) dst_weeks
  FROM (WITH RECURSIVE years (yr) AS
        (SELECT 1999 AS yr
         UNION ALL
         SELECT yr + 1 AS yr
           FROM years
          WHERE yr < YEAR(CURDATE())
        )
        SELECT yr,
               ADDDATE(LAST_DAY(CONCAT(yr, '-03-01')),
                INTERVAL - MOD(WEEKDAY(ADDDATE(LAST_DAY(CONCAT(yr, '-03-01')),1)),7) DAY) last_sun_mar,
               ADDDATE(LAST_DAY(CONCAT(yr, '-10-01')),
               INTERVAL - MOD(WEEKDAY(ADDDATE(LAST_DAY(CONCAT(yr, '-10-01')),1)),7) DAY) last_sun_oct
          FROM years
       ) dst_dates;

