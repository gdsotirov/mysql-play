#!/bin/sh
# Strip data from MySQL dump flles
# Written by Georgi D. Sotirov <gdsotirov@gmail.com>
# See https://stackoverflow.com/a/37681075 for sed multiline delete example

if [ $# -ne 1 ]; then
  echo "Usage: $0 <file>"
fi

# The following expressions matches and deletes:
# - Dumping data for table comment banners
# - INSERT INTO statments
cat "$1" | sed -e '/^\-\-$/ {N;N; }; /Dumping data for table/d' \
               -e '/^INSERT INTO/ { :e;N;/;$/!be }; /^INSERT INTO/d' \
               -e 's/AUTO_INCREMENT=[0-9]\+ //g' > "${1}.nodata"

