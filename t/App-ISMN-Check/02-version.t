use strict;
use warnings;

use App::ISMN::Check;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($App::ISMN::Check::VERSION, 0.01, 'Version.');
