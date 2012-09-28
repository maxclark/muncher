#!/usr/bin/perl -w

# unique.pl: find and display unique lines
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

use locale;

%seen = ();

foreach (<>) {

	# Change all letters to lowercase
	# --
	s/([^\W0-9_])/\l$1/g;

	# Parse for unique names
	# --
	print $_ unless $seen{$_}++;

}
