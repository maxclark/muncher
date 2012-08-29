#!/usr/bin/perl -w

my $logfile = "found_emails";

package Email::Find::Loose;
use base qw(Email::Find);
use Email::Valid::Loose;

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

open (LOG, ">>$logfile") || die "cannot appent: $!";

# Simply print out all the addresses found leaving the text undisturbed.
my $finder = Email::Find::Loose->new(sub {
        my($email, $orig_email) = @_;
        print LOG $email->format."\n";
});

while (<>) {
        $finder->find(\$_);
}

close (LOG) || die "$!";
