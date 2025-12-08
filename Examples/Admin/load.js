/* See  Dump Loading Utility at https://dev.mysql.com/doc/mysql-shell/8.0/en/mysql-shell-utilities-load-dump.html */

/* Prerequisites:
 * SET GLOBAL local_infile=ON;
 * SET GLOBAL partial_revokes=ON;
 * For speedup:
 * SET FOREIGN_KEY_CHECKS=0;
 * SET UNIQUE_CHECKS=0;
 * ALTER INSTANCE DISABLE INNODB REDO_LOG;
 */

var params = {
    deferTableIndexes: 'all',
    dryRun: false,
    loadData: true,
    loadDdl: true,
    loadIndexes: true,
    loadUsers: true,
    resetProgress: false,
    showProgress: true,
    skipBinlog: true,
    threads: 32,
    updateGtidSet: 'replace'
};
util.loadDump("/mnt/dump", params);
