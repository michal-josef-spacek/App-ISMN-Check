#!/usr/bin/env perl

use strict;
use warnings;

use App::ISMN::Check;
use File::Temp;
use IO::Barf qw(barf);

# ISMNs for test.
my $ismns = <<'END';
979-0-66055-648-1
M-2600-0233-3
END

# Temporary file.
my $temp_file = File::Temp->new->filename;

# Barf out.
barf($temp_file, $ismns);

# Arguments.
@ARGV = (
        $temp_file,
);

# Run.
exit App::ISMN::Check->new->run;

# Output:
# TODO