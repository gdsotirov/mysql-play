var cloudsql_users = [
    'cloudsqlapplier',
    'cloudsqlexport',
    'cloudsqlimport',
    'cloudsqlobservabilityadmin',
    'cloudsqloneshot',
    'cloudsqlreplica',
    'cloudsqlsuperuser'
];
var params = {
    consistent: true,
    dryRun: false,
    events: true,
    /* Cloud SQL users cannot be imported as they have custom grants, exclude also root */
    excludeUsers: cloudsql_users.concat(['root']),
    routines: true,
    showProgress: true,
    threads: 4,
    triggers: true,
    users: true
};
util.dumpInstance("/mnt/dump", params);
