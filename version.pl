#!/usr/bin/env -S perl -w
#
# Usage: $0 [VERSION=XXXXX]
#
# version.pl creates/updates doc/version.texinfo and src/version.h
# with the specified version or the version define from the top level
# makefile.

use strict;
$| = 1;             

my $version;
if ( ! defined $ARGV[0] || $ARGV[0] !~ m/^VERSION=(.+)/ )
	{
		if ( open MAKEFILE, "makefile" )
			{
				while (<MAKEFILE>)
					{
						if ( m/^\s*VERSION\s*=\s*([^\s]+)/ )
							{
								$version = $1;
								print "$0: setting version to '$version' from top level makefile.\n";
								last;
							}
					}
				close MAKEFILE;
			}
	}
else
	{
		$version = $1;
	}
unless ( $version )
	{
		print "$0: could not determine version.\n";
		exit 0;
	}
my $year  = 1900 + (localtime(time()))[5];
my $month = substr("00" . (1+(localtime(time()))[4]), -2);
my $date  = substr("00" . (  (localtime(time()))[3]), -2);

open  NE_VERSION_TEXINFO, ">doc/version.texinfo";
print NE_VERSION_TEXINFO qq[\@ignore

		This file was automatically generated by $0.

\@end ignore

\@set VERSION $version
\@set RELEASE_YEAR $year
\@set RELEASE_MONTH $month
\@set RELEASE_DATE $date
\@set DATE (\@value{RELEASE_YEAR}-\@value{RELEASE_MONTH}-\@value{RELEASE_DATE})
\@set PROGRAM_NAME ne, the nice editor
\@set ABOUT_MSG \@value{PROGRAM_NAME} \@value{VERSION}. \@value{DATE}
];
close NE_VERSION_TEXINFO;

open  NE_VERSION_H, ">src/version.h";
print NE_VERSION_H qq[/* This file was automatically generated by $0. */

/* String definitions for version and 'About...' messages.

	Copyright (C) 1993-1998 Sebastiano Vigna
	Copyright (C) 1999-$year Todd M. Lewis and Sebastiano Vigna

	This file is part of ne, the nice editor.

	This library is free software; you can redistribute it and/or modify it
	under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 3 of the License, or (at your
	option) any later version.

	This library is distributed in the hope that it will be useful, but
	WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
	or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
	for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, see <http://www.gnu.org/licenses/>.  */


#define DATE "($year-$month-$date)"
#define VERSION "$version"
#define PROGRAM_NAME "ne, the nice editor"
#define ABOUT_MSG PROGRAM_NAME " " VERSION " " DATE "."

#define VERSION_STRING "@(#)"ABOUT_MSG

];
close NE_VERSION_H;

