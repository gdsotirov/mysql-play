/* MySQL 8.0.23 adds support for writing host part of account names in
 * CIDR notation.
 * See https://dev.mysql.com/doc/refman/8.0/en/account-names.html
 */

/* To create a user that could connect from a specific network */

CREATE USER 'test1'@'192.168.100.0/255.255.255.0';

/* Hey, this should also work properly in MySQL 8.0.23 and later */

CREATE user 'test2'@'192.168.100.0/24';

/* TODO: Test with different network masks */

