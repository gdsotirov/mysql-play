# Data Mask

A simple data masking implementation with stored routines for MySQL.

Provides the functions:

* mask_inner - A general-purpose function for masking inner parts of a string
* mask_outer - A general-purpose function for masking outer parts of a string
* mask_pan - Masks all but the last four digits of a PAN (Payment Account Number)
* mask_pan_relaxed - Masks all but the first six and last four digits of a PAN
* mask)ssn - Masks all but the last four digits of an SSN (Social Security Number) of US citizens
