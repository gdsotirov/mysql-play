/* TEST QUERIES FOR DATA MASKING FUNCTIONS */

/* 1. General purpose masking functions */

/* 1.1 mask_inner - A general-purpose function for masking inner parts of a string */
/* 1.1.1 mask_inner - Either margin is negative - return NULL */

SELECT '41111' str, LENGTH('41111') str_len,
       dept_emp.mask_inner('41111', -2, 4) mask_str,
       LENGTH(dept_emp.mask_inner('41111', -2, 4)) mask_str_len;

SELECT '41111' str, LENGTH('41111') str_len,
       dept_emp.mask_inner('41111', 2, -4) mask_str,
       LENGTH(dept_emp.mask_inner('41111', 2, -4)) mask_str_len;

SELECT '41111' str, LENGTH('41111') str_len,
       dept_emp.mask_inner('41111', -2, -4) mask_str,
       LENGTH(dept_emp.mask_inner('41111', -2, -4)) mask_str_len;

/* Result:
 *
 * +-------+---------+----------+--------------+
 * | str   | str_len | mask_str | mask_str_len |
 * +-------+---------+----------+--------------+
 * | 41111 |       5 | NULL     |         NULL |
 * +-------+---------+----------+--------------+
 */

/* 1.1.2 mask_inner - Length of the string (5) lower than length of the mask (6) - return same string */

SELECT '41111' str, LENGTH('41111') str_len,
       dept_emp.mask_inner('41111', 2, 4) mask_str,
       LENGTH(dept_emp.mask_inner('41111', 2, 4)) mask_str_len;

/* Result:
 *
 * +-------+---------+----------+--------------+
 * | str   | str_len | mask_str | mask_str_len |
 * +-------+---------+----------+--------------+
 * | 41111 |       5 | 41111    |            5 |
 * +-------+---------+----------+--------------+
 */

/* 1.1.3 mask_inner - normal usage with a test Visa number */

SELECT '4111111111111111' str, LENGTH('4111111111111111') str_len,
       dept_emp.mask_inner('4111111111111111', 2, 4) mask_str,
       LENGTH(dept_emp.mask_inner('4111111111111111', 2, 4)) mask_str_len;

/* Result:
 *
 * +------------------+---------+------------------+--------------+
 * | str              | str_len | mask_str         | mask_str_len |
 * +------------------+---------+------------------+--------------+
 * | 4111111111111111 |      16 | 41XXXXXXXXXX1111 |           16 |
 * +------------------+---------+------------------+--------------+
 */

/* 1.1.4 mask_inner - with specific masking character - star (*) */

SET @mask_character := '*';
SELECT '4111111111111111' str, LENGTH('4111111111111111') str_len,
       dept_emp.mask_inner('4111111111111111', 2, 4) mask_str,
       LENGTH(dept_emp.mask_inner('4111111111111111', 2, 4)) mask_str_len;
SET @mask_character := NULL;

/* Result:
 *
 * +------------------+---------+------------------+--------------+
 * | str              | str_len | mask_str         | mask_str_len |
 * +------------------+---------+------------------+--------------+
 * | 4111111111111111 |      16 | 41**********1111 |           16 |
 * +------------------+---------+------------------+--------------+
 */

/* 1.2 mask_outer - A general-purpose function for masking outer parts of a string */
/* 1.2.1 mask_outer - Either margin is negative - return NULL */

SELECT '41111' str, LENGTH('41111') str_len,
       dept_emp.mask_outer('41111', -2, 4) mask_str,
       LENGTH(dept_emp.mask_outer('41111', -2, 4)) mask_str_len;

SELECT '41111' str, LENGTH('41111') str_len,
       dept_emp.mask_outer('41111', 2, -4) mask_str,
       LENGTH(dept_emp.mask_outer('41111', 2, -4)) mask_str_len;

SELECT '41111' str, LENGTH('41111') str_len,
       dept_emp.mask_outer('41111', -2, -4) mask_str,
       LENGTH(dept_emp.mask_outer('41111', -2, -4)) mask_str_len;

/* Result:
 *
 * +-------+---------+----------+--------------+
 * | str   | str_len | mask_str | mask_str_len |
 * +-------+---------+----------+--------------+
 * | 41111 |       5 | NULL     |         NULL |
 * +-------+---------+----------+--------------+
 */

/* 1.2.2 mask_outer - Length of the string (5) lower than length of the mask (6) - return same string */

SELECT '41111' str, LENGTH('41111') str_len,
       dept_emp.mask_outer('41111', 2, 4) mask_str,
       LENGTH(dept_emp.mask_outer('41111', 2, 4)) mask_str_len;

/* Result:
 *
 * +-------+---------+----------+--------------+
 * | str   | str_len | mask_str | mask_str_len |
 * +-------+---------+----------+--------------+
 * | 41111 |       5 | 41111    |            5 |
 * +-------+---------+----------+--------------+
 */

/* 1.2.3 mask_outer - normal usage with a test Visa number */

SELECT '4111111111111111' str, LENGTH('4111111111111111') str_len,
       dept_emp.mask_outer('4111111111111111', 2, 4) mask_str,
       LENGTH(dept_emp.mask_outer('4111111111111111', 2, 4)) mask_str_len;

/* Result:
 *
 * +------------------+---------+------------------+--------------+
 * | str              | str_len | mask_str         | mask_str_len |
 * +------------------+---------+------------------+--------------+
 * | 4111111111111111 |      16 | XX1111111111XXXX |           16 |
 * +------------------+---------+------------------+--------------+
 */

/* 1.2.4 mask_outer - with specific masking character - star (*) */

SET @mask_character := '*';
SELECT '4111111111111111' str, LENGTH('4111111111111111') str_len,
       dept_emp.mask_outer('4111111111111111', 2, 4) mask_str,
       LENGTH(dept_emp.mask_outer('4111111111111111', 2, 4)) mask_str_len;
SET @mask_character := NULL;

/* Result:
 *
 * +------------------+---------+------------------+--------------+
 * | str              | str_len | mask_str         | mask_str_len |
 * +------------------+---------+------------------+--------------+
 * | 4111111111111111 |      16 | **1111111111**** |           16 |
 * +------------------+---------+------------------+--------------+
 */

/* 2. Special purpose masking functions */

/* 2.1 mask_pan - Masks all but the last four digits of a PAN */
/* 2.1.1 mask_pan - if not sutable length return unchanged */

SELECT '4111111' pan, LENGTH('4111111') pan_len,
       mask_pan('4111111') mask_pan, LENGTH(mask_pan('4111111')) mask_pan_len;

/* Result:
 *
 * +---------+---------+----------+--------------+
 * | pan     | pan_len | mask_pan | mask_pan_len |
 * +---------+---------+----------+--------------+
 * | 4111111 |       7 | 4111111  |            7 |
 * +---------+---------+----------+--------------+
 */

/* 2.1.2 mask_pan - normal usage */

SELECT '4111111111111111' pan, LENGTH('4111111111111111') pan_len,
       mask_pan('4111111111111111') mask_pan,
       LENGTH(mask_pan('4111111111111111')) mask_pan_len;

/* Result:
 *
 * +------------------+---------+------------------+--------------+
 * | pan              | pan_len | mask_pan         | mask_pan_len |
 * +------------------+---------+------------------+--------------+
 * | 4111111111111111 |      16 | XXXXXXXXXXXX1111 |           16 |
 * +------------------+---------+------------------+--------------+
 */

/* 2.1.3 mask_pan - if pan 20 or more characters */

SELECT '41111111111111111111' pan, LENGTH('41111111111111111111') pan_len,
       mask_pan('41111111111111111111') mask_pan,
       LENGTH(mask_pan('41111111111111111111')) mask_pan_len;

/* Result: ERROR 1406 (22001): Data too long for column 'pan' at row 1 */

/* 2.2 mask_pan_relaxed - Masks all but the first six and last four digits of a PAN */
/* 2.2.1 mask_pan_relaxed - if not sutable length return unchanged */

SELECT '4111111' pan, LENGTH('4111111') pan_len,
       mask_pan_relaxed('4111111') mask_pan,
       LENGTH(mask_pan_relaxed('4111111')) mask_pan_len;

/* Result:
 *
 * +---------+---------+----------+--------------+
 * | pan     | pan_len | mask_pan | mask_pan_len |
 * +---------+---------+----------+--------------+
 * | 4111111 |       7 | 4111111  |            7 |
 * +---------+---------+----------+--------------+
 */

/* 2.2.2 mask_pan_relaxed - normal usage */

SELECT '4111111111111111' pan, LENGTH('4111111111111111') pan_len,
       mask_pan_relaxed('4111111111111111') mask_pan_relaxed,
       LENGTH(mask_pan('4111111111111111')) mask_pan_relaxed_len;

/* Result:
 *
 * +------------------+---------+------------------+----------------------+
 * | pan              | pan_len | mask_pan_relaxed | mask_pan_relaxed_len |
 * +------------------+---------+------------------+----------------------+
 * | 4111111111111111 |      16 | 411111XXXXXX1111 |                   16 |
 * +------------------+---------+------------------+----------------------+
 */

/* 2.2.3 mask_pan_relaxed - if pan 20 or more characters */

SELECT '41111111111111111111' pan, LENGTH('41111111111111111111') pan_len,
       mask_pan_relaxed('41111111111111111111') mask_pan,
       LENGTH(mask_pan_relaxed('41111111111111111111')) mask_pan_len;

/* Result: ERROR 1406 (22001): Data too long for column 'pan' at row 1 */

/* 2.3 mask_ssn - Masks all but the last four digits of an SSN (Social Security Number) of US citizens */
/* 2.3.1 mask_ssn - SSN as number (9 digits) */

SELECT '909636922' ssn, LENGTH('909636922') ssn_len,
       mask_ssn('909636922') mask_ssn, LENGTH(mask_ssn('909636922')) mask_ssn_len;

/* Result:
 * +-----------+---------+-----------+--------------+
 * | ssn       | ssn_len | mask_ssn  | mask_ssn_len |
 * +-----------+---------+-----------+--------------+
 * | 909636922 |       9 | XXXXX6922 |            9 |
 * +-----------+---------+-----------+--------------+
 */

/* 2.3.2 mask_ssn - SSN as string (11 digits formatted NNN-NN-NNNN) */

SELECT '909-63-6922' ssn, LENGTH('909-63-6922') ssn_len,
       mask_ssn('909-63-6922') mask_ssn, LENGTH(mask_ssn('909-63-6922')) mask_ssn_len;

/* Result:
 *
 * +-------------+---------+-------------+--------------+
 * | ssn         | ssn_len | mask_ssn    | mask_ssn_len |
 * +-------------+---------+-------------+--------------+
 * | 909-63-6922 |      11 | XXX-XX-6922 |           11 |
 * +-------------+---------+-------------+--------------+
 */

/* 2.3.3 mask_ssn - wrong length */

SELECT '909' ssn, LENGTH('909') ssn_len,
       mask_ssn('909') mask_ssn, LENGTH(mask_ssn('909')) mask_ssn_len;

/* Result:
 * +-----+---------+----------+--------------+
 * | ssn | ssn_len | mask_ssn | mask_ssn_len |
 * +-----+---------+----------+--------------+
 * | 909 |       3 | NULL     |         NULL |
 * +-----+---------+----------+--------------+
 */

/* 3. Generation of random data */

/* 3.1 gen_range - generate random integer within given range */

SELECT gen_range(1, 10), gen_range(-1000, -200), gen_range(1, 0);

/* Result:
 *
 * +------------------+------------------------+-----------------+
 * | gen_range(1, 10) | gen_range(-1000, -200) | gen_range(1, 0) |
 * +------------------+------------------------+-----------------+
 * |                5 |                   -249 |            NULL |
 * +------------------+------------------------+-----------------+
 */

/* 3.2 gen_rnd_string - generate random string with given length */

SELECT gen_rnd_string(0), gen_rnd_string(8), gen_rnd_string(32);

/* Result:
 *
 * +-------------------+-------------------+----------------------------------+
 * | gen_rnd_string(0) | gen_rnd_string(8) | gen_rnd_string(32)               |
 * +-------------------+-------------------+----------------------------------+
 * | NULL              | fdcdhcoo          | gnxcqacmbxkimihjcgcretkrioujkwhs |
 * +-------------------+-------------------+----------------------------------+
 */

 SELECT gen_rnd_string(129);

/* Result: ERROR 1406 (22001): Data too long for column 'res_str' at row 1 */

/* 3.3 gen_rnd_email - generate random e-mail address in example.com domain */

SELECT gen_rnd_email(), gen_rnd_email(), gen_rnd_email();

/* Result:
 *
 * +---------------------------+---------------------------+---------------------------+
 * | gen_rnd_email()           | gen_rnd_email()           | gen_rnd_email()           |
 * +---------------------------+---------------------------+---------------------------+
 * | prsmg.uigfhxs@example.com | uwais.rfctqvj@example.com | iligi.vhwqoxx@example.com |
 * +---------------------------+---------------------------+---------------------------+
 */

/* 3.4 gen_rnd_pan - generate random PAN */

SELECT mask_pan_relaxed(gen_rnd_pan());

/* Result:
 *
 * +---------------------------------+
 * | mask_pan_relaxed(gen_rnd_pan()) |
 * +---------------------------------+
 * | 433468XXXXXX7825                |
 * +---------------------------------+
 */

SET @gen_rnd_pan_len := 19;
SELECT mask_pan_relaxed(gen_rnd_pan());
SET @gen_rnd_pan_len := NULL;

/* Result:
 * +---------------------------------+
 * | mask_pan_relaxed(gen_rnd_pan()) |
 * +---------------------------------+
 * | 474077XXXXXXXXX2647             |
 * +---------------------------------+
 */

/* 3.5 gen_rnd_ssn - generate random PAN */

SELECT gen_rnd_ssn();

/* Result:
 *
 * +---------------+
 * | gen_rnd_ssn() |
 * +---------------+
 * | 710-27-8034   |
 * +---------------+
 */

/* 3.6 gen_rnd_us_phone - generate random US phone */

SELECT gen_rnd_us_phone();

/* Result:
 *
 * +--------------------+
 * | gen_rnd_us_phone() |
 * +--------------------+
 * | 1-555-153-0362     |
 * +--------------------+
 */

/* 4. Random Data Dictionary-Based procedures */

/* 4.1 gen_dictionary_load - create temporary table for the dictionary */

CALL gen_dictionary_load('/var/mysql/files/us_cities.lst', 'us_cities');

/* Result:
 *
 * +-------------------------+
 * | Dictionary load success |
 * +-------------------------+
 * | Dictionary load success |
 * +-------------------------+
 */

LOAD DATA INFILE '/var/mysql/files/us_cities.lst' INTO TABLE gen_dictionary_us_cities LINES TERMINATED BY '\n' (val);

/* Result:
 *
 * Query OK, 311 rows affected (0.01 sec)
 * Records: 311  Deleted: 0  Skipped: 0  Warnings: 0
 */

/* 4.2 gen_dictionary - generates a random term from given dictionary */

CALL gen_dictionary('us_cities');
SELECT @gen_dictionary_value;

/* Result:
 *
 * +-----------------------+
 * | @gen_dictionary_value |
 * +-----------------------+
 * | Hartford              |
 * +-----------------------+
 */

/* 4.3 gen_dictionary_drop - drop temporary table of the dictionary */

CALL gen_dictionary_drop('us_cities');

/* Result:
 *
 * +--------------------+
 * | Dictionary removed |
 * +--------------------+
 * | Dictionary removed |
 * +--------------------+
 */

/* 5. Utility functions */

/* 5.1 calc_luhn - calculate Luhn number for the given string

SELECT '7992739871' pan, LENGTH('7992739871') pan_len, calc_luhn('7992739871') luhn_nbr;

/* Result:
 * +------------+---------+----------+
 * | pan        | pan_len | luhn_nbr |
 * +------------+---------+----------+
 * | 7992739871 |      10 |        3 |
 * +------------+---------+----------+
 */

SELECT '411111111111111' pan, LENGTH('411111111111111') pan_len, calc_luhn('411111111111111') luhn_nbr;

/* Result:
 * +-----------------+---------+----------+
 * | pan             | pan_len | luhn_nbr |
 * +-----------------+---------+----------+
 * | 411111111111111 |      15 |        1 |
 * +-----------------+---------+----------+
 */

SELECT '600452020066870207' pan, LENGTH('600452020066870207') pan_len, calc_luhn('600452020066870207') luhn_nbr;

/* Result:
 *
 * +--------------------+---------+----------+
 * | pan                | pan_len | luhn_nbr |
 * +--------------------+---------+----------+
 * | 600452020066870207 |      18 |        2 |
 * +--------------------+---------+----------+
 */
