﻿WITH RECURSIVE sales (dat, amt) AS
(SELECT CAST('2018-01-01' AS DATE) AS dat,
        CAST(100 AS DECIMAL(10,2)) AS amt
 UNION ALL
 SELECT DATE_ADD(dat, INTERVAL 15 DAY), amt + 100
   FROM sales
  WHERE MONTH(DATE_ADD(dat, INTERVAL 15 DAY)) < 6
)
SELECT MONTH(dat) mnth, SUM(amt) tot_mnth,
       SUM(SUM(amt))
         OVER(ORDER BY MONTH(dat)) tot_cum,
       ROUND(AVG(SUM(amt))
               OVER(ORDER BY MONTH(dat)
                    RANGE BETWEEN 1 PRECEDING
                              AND 1 FOLLOWING
                   ),
             2) sliding_avg
  FROM sales
 GROUP BY MONTH(dat);
