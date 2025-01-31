/* Calculate maximum memory that MySQL would allocate for different
 * configurations by physical memory size and maximum number of connections
 * using default session buffers.
 */

WITH glob AS (
  WITH cfg AS (VALUES ROW(4, 64) /* mem GB, connections */,
               ROW(8, 128), ROW(12, 180), ROW(16, 256), ROW(32, 320), ROW(64, 512))
  SELECT c.column_0                      AS size,
         c.column_1                      AS conns,
         c.column_0 * 0.25               AS buf_pool,
         round(0.25 * c.column_0) * 0.25 AS redo_log,
         c.column_0 * 0.25               AS key_buf,
         c.column_0 * 0.25 + round(0.25 * c.column_0) * 0.25 + c.column_0 * 0.25
                                         AS total_GB
    FROM cfg AS c),
ses AS (
  WITH mem AS (
  SELECT 262144   AS join_buf,
         131072   AS read_buf,
         262144   AS rrnd_buf,
         262144   AS sort_buf,
         1048576  AS thr_stck,
         16777216 AS tmp_tbl
  )
  SELECT (mem.join_buf + mem.read_buf + mem.rrnd_buf + mem.sort_buf + mem.thr_stck + mem.tmp_tbl) / 1024 / 1024         AS total_MB,
         (mem.join_buf + mem.read_buf + mem.rrnd_buf + mem.sort_buf + mem.thr_stck + mem.tmp_tbl) / 1024 / 1024 / 1024  AS total_GB
    FROM mem
)
SELECT glob.size              AS size_GB,
       glob.buf_pool          AS buf_pool,
       glob.redo_log          AS redo_log,
       glob.key_buf           AS key_buf,
       glob.conns             AS conns,
       ROUND(ses.total_MB, 2) AS ses_aloc_MB,
       glob.total_GB          AS total_gob,
       ROUND(glob.total_GB + glob.conns * ses.total_GB, 2)
                              AS total_aloc,
       ROUND(glob.total_GB / glob.size * 100, 2)
                              AS perc_glob,
       ROUND((glob.total_GB + glob.conns * ses.total_GB) / glob.size * 100, 2)
                              AS perc_alloc
  FROM glob, ses;

