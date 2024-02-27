#!/usr/bin/env perl

use strict;
use warnings;

use App::ISMN::Check;

# Arguments.
@ARGV = (
        -h,
);

# Run.
exit App::ISMN::Check->new->run;

# Output:
# Usage: ./print_help.pl [-h] [--version] file_with_ismns
#         -h              Print help.
#         --version       Print version.
#         file_with_ismns File with ISMN strings, one per line.