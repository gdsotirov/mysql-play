﻿SELECT SEQ.Year
  FROM (SELECT (THOUSANDS.SeqValue + HUNDREDS.SeqValue
                + TENS.SeqValue + ONES.SeqValue) Year
          FROM (SELECT 0 SeqValue
                 UNION ALL SELECT 1 SeqValue UNION ALL SELECT 2 SeqValue
                 UNION ALL SELECT 3 SeqValue UNION ALL SELECT 4 SeqValue
                 UNION ALL SELECT 5 SeqValue UNION ALL SELECT 6 SeqValue
                 UNION ALL SELECT 7 SeqValue UNION ALL SELECT 8 SeqValue
                 UNION ALL SELECT 9 SeqValue) ONES CROSS JOIN
               (SELECT 0 SeqValue
                 UNION ALL SELECT 10 SeqValue UNION ALL SELECT 20 SeqValue
                 UNION ALL SELECT 30 SeqValue UNION ALL SELECT 40 SeqValue
                 UNION ALL SELECT 50 SeqValue UNION ALL SELECT 60 SeqValue
                 UNION ALL SELECT 70 SeqValue UNION ALL SELECT 80 SeqValue
                 UNION ALL SELECT 90 SeqValue) TENS CROSS JOIN
               (SELECT 0 SeqValue
                 UNION ALL SELECT 100 SeqValue UNION ALL SELECT 200 SeqValue
                 UNION ALL SELECT 300 SeqValue UNION ALL SELECT 400 SeqValue
                 UNION ALL SELECT 500 SeqValue UNION ALL SELECT 600 SeqValue
                 UNION ALL SELECT 700 SeqValue UNION ALL SELECT 800 SeqValue
                 UNION ALL SELECT 900 SeqValue) HUNDREDS CROSS JOIN
               (SELECT 0 SeqValue
                 UNION ALL SELECT 1000 SeqValue
                 UNION ALL SELECT 2000 SeqValue) THOUSANDS
       ) SEQ
 WHERE SEQ.Year BETWEEN 1989 AND YEAR(NOW())
 ORDER BY SEQ.Year;

