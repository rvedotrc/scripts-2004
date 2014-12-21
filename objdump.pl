#!/usr/bin/perl -w
# vi: set ts=4 sw=4 :

use strict;

my ($file) = @ARGV;

my %T;
for (`objdump -T $file`)
{
	chomp;
	my ($addr, $flags, $rest) = /^(\w{8}) (....) (.*)$/ or next;
	my ($f2, $section, $a2, $lib, $name) = split ' ', $rest;
	$name or next;
	$T{$addr} = $name;
	$addr =~ s/^0+(?!0)//;
	$T{$addr} = $name;
}

use Data::Dumper;
print Data::Dumper->Dump([ \%T ],[ '*T' ]);

open(PIPE, "objdump -d $file |") or die;
while (<PIPE>)
{
	if (/^ (\w{7})\b/)
	{
		my $name = $T{$1};
		print "; $name\n" if $name;
	}
	
	while (/0x(\w{7,8})/g)
	{
		my $name = $T{$1} or next;
		substr($_, $+[0], 0) = " ; $name";
		pos() = $+[0] + length($name);
	}
	print;
}
close PIPE;

__END__

Example "-T" output:


rotatelogs:     file format elf32-i386

DYNAMIC SYMBOL TABLE:
0804a020 g    DO *ABS*  00000000  Base        _DYNAMIC
08048704      DF *UND*  0000003c  GLIBC_2.0   write
08048714      DF *UND*  00000036  GLIBC_2.0   close
08048d60 g    DO .rodata        00000004  Base        _fp_hw
08048724      DF *UND*  00000213  GLIBC_2.0   perror
08048734      DF *UND*  00000023  GLIBC_2.0   fprintf
08048744      DF *UND*  00000018  GLIBC_2.0   __errno_location
...


