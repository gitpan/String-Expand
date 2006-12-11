#!/usr/bin/perl -w
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Library General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
#  (C) Paul Evans, 2006 -- leonerd@leonerd.org.uk

use strict;

use Test::More tests => 7;

use String::Expand qw(
   expand_strings
);

my %s;

%s = ( foo => 'one', bar => 'two' );
expand_strings( \%s, {} );
is_deeply( \%s, { foo => 'one', bar => 'two' }, 'Plain strings' );

%s = ( foo => 'one is $ONE', bar => 'two is $TWO' );
expand_strings( \%s, { ONE => 1, TWO => 2 } );
is_deeply( \%s, { foo => 'one is 1', bar => 'two is 2' }, 'Independent strings' );

%s = ( dollar => '\$', slash => '\\\\', combination => 'dollar is \$, slash is \\\\' );
expand_strings( \%s, {} );
is_deeply( \%s, { dollar => '$', slash => '\\', combination => 'dollar is $, slash is \\' },
           'Strings with literals' );

%s = ( foo => 'bar is ${bar}', bar => 'quux' );
expand_strings( \%s, {} );
is_deeply( \%s, { foo => 'bar is quux', bar => 'quux' }, 'Chain of strings (no overlay)' );

%s = ( foo => 'bar is ${bar}', bar => 'quux is ${quux}' );
expand_strings( \%s, { quux => 'splot' } );
is_deeply( \%s, { foo => 'bar is quux is splot', bar => 'quux is splot' }, 'Chain of strings (with overlay)' );

%s = ( foo => '${foo}' );
eval { expand_strings( \%s, {} ) };
ok( $@, 'Exception (loop) throws exception' );

%s = ( foo => 'bar is ${bar}', bar => 'quux' );
expand_strings( \%s, { bar => 'splot' } );
is_deeply( \%s, { foo => 'bar is quux', bar => 'quux' }, 'Chain with overlay' );
