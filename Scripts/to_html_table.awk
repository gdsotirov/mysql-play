#!/usr/bin/awk -f
# Converts text to HTML table, e.g. TSV (Tab-separated values) or
# CSV (Comma-separated values) output from mysql or another utility.
# Usage:
#   mysql -u root -p < script.sql | awk -F'\t' -f to_html_table.awk
# or
#   cat result.csv | awk -F',' -f to_html_table.awk
#
# You could also make the script runnable and call it as any binary.
#

BEGIN {
  print "<table>"
}

NR == 1 {
  tag="th"
}

NR != 1 {
  tag="td"
}

{
  print "<tr>"
  for (i=1;i<=NF;++i) {
    gsub(/</, "\\&lt;", $i)
    gsub(/>/, "\\&gt;", $i)

    print "<" tag ">" $i "</" tag ">"
  }
  print "</tr>"
}

END {
  print "</table>"
}

