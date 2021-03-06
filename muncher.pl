#!/usr/bin/perl -w

# muncher.pl: search for email addresses in files
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
my $outfile = "/tmp/found_emails.txt";

# Perl Modules
# ------------
package Email::Find::Loose;
use base qw(Email::Find);
use Email::Valid::Loose;

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

# Override the built in module subs
# ---------------------------------
# should return regex, which Email::Find will use in finding
# strings which are "thought to be" email addresses
sub addr_regex {
  return $Email::Valid::Loose::Addr_spec_re;
}

# should validate $addr is a valid email or not.
# if so, return the address as a string.
# else, return undef
sub do_validate {
  my($self, $addr) = @_;
  return Email::Valid::Loose->address($addr);
}

# Simply print out all the addresses found leaving the text undisturbed.
my $finder = Email::Find::Loose->new(sub {
  my($email, $orig_email) = @_;
  print OUT $email->format."\n";
});

# Main program loop
# -----------------
# specify file on script invocation, replaced in favor of pipe "|"
# my $file = shift @ARGV;
# open (IN, "<$file") || die "$!";

while (<>) {
  # yep it's that easy
  $finder->find(\$_);
}

# Close filehandels
# -----------------
# close (IN) || die "$!";
close (OUT) || die "$!";
