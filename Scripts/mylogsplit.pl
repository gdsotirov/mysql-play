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
my $logmsg = "";
my $prlogmsg = "";
my $dupes = 0;
my $similar = 0;
my $istsmsg = 0;
my $prlogln = "";

while ( <LOGFILE> ) {
  if ( $_ =~ /^(0[789])\d{4} /                  ||
       $_ =~ /^(1[0123456789])\d{4}/            ||
       $_ =~ /^20(\d{2})\-\d{2}\-\d{2}[ T]/
     )
  {
    $year=$1;
    $logmsg = $_;
    $logmsg =~ s/^\d{4}\-\d{2}\-\d{2}[ T]\d{2}:\d{2}:\d{2}(\.\d{6}Z)?\s+//;
    $istsmsg = 1;
  }
  else {
    $istsmsg = 0;
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

  if ( $istsmsg ) { # only timestamped lines
    # Handle similar messages
    if ( $logmsg =~ /InnoDB: Table [_a-zA-Z0-9\/]+ has length mismatch/ ||
         $logmsg =~ /Aborted connection \d+ to db: \'cacti\'/ )
    {
      if ( $prlogmsg !~ /InnoDB: Table [_a-zA-Z0-9\/]+ has length mismatch/ &&
           $prlogmsg !~ /Aborted connection \d+ to db: \'cacti\'/ )
      {
        print LGYR $_;
      }
      $similar++;
    }
    # Dump similar log messages
    elsif ( $logmsg !~ /InnoDB: Table [_a-zA-Z0-9\/]+ has length mismatch/ &&
            $logmsg !~ /Aborted connection \d+ to db: \'cacti\'/ &&
            $similar > 0 )
    {
      if ( $similar == 2 ) {
        print LGYR $prlogmsg;
      }
      elsif ( $similar > 2 ) {
        $similar -= 2;
        print LGYR " skipped $similar similar log messages\n";
        print LGYR $prlogln;
      }
      $similar = 0;
      print LGYR $_;
    }
    # Handle duplicate messages
    elsif ( $logmsg ne $prlogmsg )
    {
      # if only one duplicate copy back previous and current lines and continue
      if ( $dupes == 1 ) {
        print LGYR $prlogln;
        print LGYR $_;
        $dupes = 0;
      }
      elsif ( $dupes > 1 ) { # print just number of repetitions
        print LGYR " last message repeated $dupes times\n";
        print LGYR $_;
        $dupes = 0;
      }
      else {
        print LGYR $_;
      }
    }
    else {
      # skip duplicate messages
      $dupes++;
    }
    $prlogmsg = $logmsg;
    $prlogln = $_;
  }
  else { # just copy lines without timestamp
    print LGYR $_;
  }
}

close(LGYR);
close(LOGFILE);

