#!/usr/bin/perl -w
# Split MySQL error log files by years
# Written by Georgi D. Sotirov <gdsotirov@gmail.com>
#

use strict;
use warnings;

(@ARGV == 1) or die "Usage: $0 <log file>\n";
  
my $logfile = $ARGV[0];
my $LOGFILE;

open(LOGFILE, $logfile) or die "Error: Can not open file '$logfile': $!\n";

my $year = "";
my $pryr = "";
my $lgyr_fname = "";
my $LGYR;

while ( <LOGFILE> ) {
  if ( $_ =~ /^(0[789])\d{4} /                  ||
       $_ =~ /^(1[0123456789])\d{4}/            ||
       $_ =~ /^20(1[123456789])\-\d{2}\-\d{2}[ T]/
     )
  {
    $year=$1;
  }
  if ( $year ne $pryr ) {
    if ( fileno(LGYR) ) {
      close(LGYR);
    }
    $year ne "" or die "Error: Year is empty!";
    $lgyr_fname = "$logfile.20$year";
    open(LGYR, '>', $lgyr_fname) or die "Error: Could not open file '$lgyr_fname': $!\n";
    print "Info: Starting new log file '$lgyr_fname'.\n";
    $pryr = $year;
  }
  print LGYR $_;
}

close(LGYR);
close(LOGFILE);

