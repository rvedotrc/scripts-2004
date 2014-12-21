#!/usr/bin/perl -w
# vi: set ts=4 sw=4 :

use strict;

for (@ARGV)
{
	my $n = $_;
	$n =~ s/\b(\w)/uc $1/eg;
	$n =~ s/(['-])(\w)/$1 . lc $2/eg;
	$n =~ s/Mp3$/mp3/;
	next if $_ eq $n;

	print "rename $_ => $n\n";
	my $t = "_tmp_$n";
	rename $_, $t or warn $!;
	rename $t, $n or warn $!;
}

# eof TitleCaseFiles.pl
