/* MySQL 8.0.27: Support for multi-factor authentication (MFA) on users,
 * such that accounts can have up to three authentication methods.
 * See https://dev.mysql.com/doc/refman/8.0/en/create-user.html#create-user-multifactor-authentication
 * See https://dev.mysql.com/doc/refman/8.0/en/multifactor-authentication.html
 * See https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_authentication_policy
 */

/* List available authentication methods (plugins) */

SELECT plugin_name, plugin_version, plugin_status,
       plugin_type_version, plugin_description
  FROM information_schema.`plugins`
 WHERE plugin_type = 'AUTHENTICATION';

/* Typical output on 8.0.x community server:
 * +-----------------------+----------------+---------------+---------------------+--------------------------------+
 * | plugin_name           | plugin_version | plugin_status | plugin_type_version | plugin_description             |
 * +-----------------------+----------------+---------------+---------------------+--------------------------------+
 * | mysql_native_password | 1.1            | ACTIVE        | 2.1                 | Native MySQL authentication    |
 * | sha256_password       | 1.1            | ACTIVE        | 2.1                 | SHA256 password authentication |
 * | caching_sha2_password | 1.0            | ACTIVE        | 2.1                 | Caching sha2 authentication    |
 * +-----------------------+----------------+---------------+---------------------+--------------------------------+
 * 3 rows in set (0.01 sec)
 */

/* Default authentication policy permits creating or altering accounts with
 * one, two, or three factors. */

SHOW GLOBAL VARIABLES LIKE '%auth%';

/* +-------------------------------+-----------------------+
 * | Variable_name                 | Value                 |
 * +-------------------------------+-----------------------+
 * | authentication_policy         | *,,                   |
 * | default_authentication_plugin | caching_sha2_password |
 * +-------------------------------+-----------------------+
 * 2 rows in set (0.00 sec)
 */

CREATE USER 'myuser'@'localhost'
  IDENTIFIED WITH mysql_native_password BY 'mypassword'
  AND IDENTIFIED WITH sha256_password BY 'mypassword'
  AND IDENTIFIED WITH caching_sha2_password BY 'mypassword';

/* Error Code: 4052. Invalid plugin "sha256_password" specified as 2 factor during "CREATE USER". */

/* Authentication plugins that use internal credentials storage can be
 * specified for the first element only, and cannot repeat. So practically
 * in the vanilla MySQL community server unless you install additional
 * authentication plugins you can NOT use MFA. I would have been nice if
 * at least the LDAP authentication was available.
 */

CREATE USER 'myuser'@'localhost'
  IDENTIFIED WITH caching_sha2_password BY 'mypassword' /* 1st factor: Something you know (e.g. password) */
  AND IDENTIFIED WITH authentication_ldap_sasl          /* 2nd factor: Something you have (e.g. security key or smart card) */
    AS 'uid=myuser,ou=People,dc=example,dc=com'
  AND IDENTIFIED WITH authentication_fido;              /* 3rd factor: Something you are  (e.g. biometrics) */

ALTER USER 'myuser'@'localhost' DROP 2 FACTOR 3 FACTOR;
