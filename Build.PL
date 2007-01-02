use strict;
use warnings;

use Module::Build;

my $build = Module::Build->new
  (
   module_name => 'String::Expand',
   dist_version_from => 'lib/String/Expand.pm',
   build_requires => {
                 'Test::Exception' => 0,
               },
   license => 'perl',
  );
  
$build->create_build_script;
