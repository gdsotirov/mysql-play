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
  * `gen_rnd_pan` - Generation of a random payment account number
  * `gen_rnd_ssn` - Generation of a random Social Security Number of US citizens
  * `gen_rnd_string` - A utility function for generation of a random string with given length
  * `gen_rnd_us_phone` - Generation of a random US phone number in the 555 area

## TODO

Implement functions for generation of random data based on dictionaries `gen_dictionary_load`, `gen_dictionary` and `gen_blacklist`.