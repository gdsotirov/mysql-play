# Data Mask

A simple data masking and de-identification implementation with stored routines for MySQL.

## API

Provides the following functions:

* General purpose masking functions:
  * `mask_inner` - A general-purpose function for masking inner parts of a string. Uses X as masking character by default, but could use @mask_character for specific masking character
  * `mask_outer` - A general-purpose function for masking outer parts of a string. Uses X as masking character by default, but could use @mask_character for specific masking character
* Special purpose masking functions:
  * `mask_pan` - Masks all but the last four digits of a PAN (Primary Account Number)
  * `mask_pan_relaxed` - Masks all but the first six and last four digits of a PAN
  * `mask_ssn` - Masks all but the last four digits of an SSN (Social Security Number) of US citizens
* Generation of random data:
  * `gen_range` - A function that returns a random integer within given range
  * `gen_rnd_email` - Generation of a random email address in the example.com domain
  * `gen_rnd_pan` - Generation of a random Primary Account Number (PAN). Uses @gen_rnd_pan_len for the length of generated PAN. The default is 16
  * `gen_rnd_ssn` - Generation of a random Social Security Number of US citizens
  * `gen_rnd_string` - A utility function for generation of a random string with given length
  * `gen_rnd_us_phone` - Generation of a random US phone number in the 555 area
* Random Data Dictionary-Based procedures:
  * `gen_dictionary` - Generates a random term from given dictionary. The result goes to @gen_dictionary_value
  * `gen_dictionary_drop` - Removes the temporary table for the dictionary
  * `gen_dictionary_load` - Creates temporary table for the dictionary
* Utility functions:
  * `calc_luhn` - calculates Lunh number

## TODO

Due to restrictions in MySQL it's impossible to implement `gen_dictionary`, `gen_dictionary_drop` and `gen_dictionary_load` as functions, because only procedures could use prepared statements. The procedure `gen_dictionary_load` cannot load it's dictionary into the temporary table, because of restrictions on allowed SQL in prepared statements (see [SQL Syntax Allowed in Prepared Statements](https://dev.mysql.com/doc/refman/8.0/en/sql-syntax-prepared-statements.html#idm140124000651504)). Functions `mask_inner`, `mask_outer` and `gen_rnd_pan` do not have optional argument, because this is still impossible in MySQL. The implementation could be completed if eventually MySQL removes these restrictions with future releases. Fingers crossed :-)

The function `gen_blacklist` is not implemented.
