#!/usr/bin/perl
# Written by Lucia Načinović on 2010-04-22 (with help of a Perl tutorial).

use File::Find;
use strict;

my $directory = "/home/vedran/bitbucket/beamer";
my $uncomment = 1;

find (\&process, $directory);

sub process
{
	my @outLines;
	my $line;


	if ( $File::Find::name =~ /\.cls$/ or $File::Find::name =~ /\.sty$/ or $File::Find::name =~ /\.tex$/ )
	{

		open (FILE, $File::Find::name ) or
		die "Cannot open file: $!";

		print "\n" . $File::Find::name . "\n";
		while ( $line = <FILE> )
		{
			if ( $uncomment == 0 ) {
				$line =~ s/\\ProvidesPackageRCS \$Header\$/\%\\ProvidesPackageRCS \$Header\$/i;
			} else {
				$line =~ s/\%\\ProvidesPackageRCS \$Header\$/\\ProvidesPackageRCS \$Header\$/i;
			}
			push(@outLines, $line);
		}
		close FILE;

		open ( OUTFILE, ">$File::Find::name" ) or
		die "Cannot open file: $!";

		print ( OUTFILE @outLines );
		close ( OUTFILE );

		undef( @outLines );
	}
}
