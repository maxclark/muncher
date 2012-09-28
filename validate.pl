#!/usr/bin/perl -w

# validate.pl: validate a provided email address
#
#    Copyright (C) 2012 Max Clark
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

# Default Configuration
# ---------------------
my $outfile = "/tmp/valid_emails.txt";

# Perl Modules
# ------------
use GetOpt::Long;
use Email::Valid;

my $VERSION = "0.1";

# Usage and Help
# -----
sub usage {
  print "\n";
  print "usage: muncher.pl [*options*]\n";
  print "  -h, --help           display this help and exit\n";
  print "      --version        output version information and exit\n";
  print "  -v, --verbose        display debug messages\n";
  print "  -f, --file           where to write the output\n";
  print "\n";
  exit;
}

my %opt = ();
GetOptions(\%opt,
  'debug|d', 'help|h', 'verbose|v', 'version', 'file|f=s'
  ) or exit(1);
usage if $opt{help};

if ($opt{version}) {
  print "report $VERSION by max\@clarksys.com\n";
  exit;
}

$DEBUG = "1" if defined $opt{debug};
$VERBOSE = "1" if defined $opt{verbose};

if (defined $opt{file}) {
  $outfile = $opt{file};
}

# Open the output file handle
# ---------------------------
open (OUT, ">>$outfile") || die "cannot append: $!";

# Main program loop
# -----------------
# specify file on script invocation, replaced in favor of pipe "|"
# my $file = shift @ARGV;
# open (IN, "<$file") || die "$!";

while (<>) {
  # yep it's that easy
  chomp;
  $addr = $_;
  if (Email::Valid->address( -address => $addr, -mxcheck => 1 ) ) {
    print OUT "$addr\n";
  }
}

# Close filehandels
# -----------------
# close (IN) || die "$!";
close (OUT) || die "$!";
