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
   expand_string
);

my $s;

$s = expand_string( "hello world", {} );
is( $s, "hello world", 'Plain string' );

$s = expand_string( "value of \$FOO", { FOO => 'expansion' } );
is( $s, "value of expansion", 'String with $FOO' );

$s = expand_string( "All the leaves are \${A_LONG_VAR_NAME_HERE}", { A_LONG_VAR_NAME_HERE => "brown" } );
is( $s, "All the leaves are brown", 'String with $A_LONG_VAR_NAME_HERE' );

$s = expand_string( "Some \${delimited}_text", { delimited => "delimited" } );
is( $s, "Some delimited_text", 'String with ${delimited}_text' );

eval { expand_string( "\${someunknownvariable}", {} ) };
ok( $@, 'Undefined variable raises exception' );

$s = expand_string( "Some literal text \\\$here", {} );
is( $s, "Some literal text \$here", 'Variable with literal \$dollar' );

$s = expand_string( "This has \\\\literal \\\$escapes and \$EXPANSION", { EXPANSION => "text expansion" } );
is( $s, "This has \\literal \$escapes and text expansion", 'Variable with literals and expansions' );
