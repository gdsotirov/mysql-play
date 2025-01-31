/* Maximum memory MySQL could allocate could be calculated by
 * summarizing all global buffers and multiplying the summary of
 * session level buffers times the maximum number of connections.
 * See https://dev.mysql.com/doc/refman/8.0/en/sys-format-bytes.html
 * Or in other words using the formula below:
 */

SELECT /*Use sys.format_bytes before MySQL 8.0.16 */
       FORMAT_BYTES(
        @@GLOBAL.innodb_buffer_pool_size +
        @@GLOBAL.innodb_log_buffer_size +
        @@GLOBAL.key_buffer_size +
      /*@@GLOBAL.query_cache_size + / Uncomment for MySQL 4.0 to 5.7 */
        @@GLOBAL.max_connections * (
          @@GLOBAL.join_buffer_size +
          @@GLOBAL.read_buffer_size +
          @@GLOBAL.read_rnd_buffer_size +
          @@GLOBAL.sort_buffer_size +
          @@GLOBAL.thread_stack +
          @@GLOBAL.tmp_table_size)
       ) AS max_alloc_mem;
