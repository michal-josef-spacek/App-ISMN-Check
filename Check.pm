package App::ISMN::Check;

use strict;
use warnings;

use Business::ISMN qw(ean_to_ismn);
use Class::Utils qw(set_params);
use Error::Pure qw(err);
use Getopt::Std;
use Perl6::Slurp qw(slurp);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	# Process parameters.
	set_params($self, @params);

	# Object.
	return $self;
}

# Run.
sub run {
	my $self = shift;

	# Process arguments.
	$self->{'_opts'} = {
		'h' => 0,
	};
	if (! getopts('h', $self->{'_opts'}) || @ARGV < 1
		|| $self->{'_opts'}->{'h'}) {

		print STDERR "Usage: $0 [-h] [--version] file_with_ismns\n";
		print STDERR "\t-h\t\tPrint help.\n";
		print STDERR "\t--version\tPrint version.\n";
		print STDERR "\tfile_with_ismns\tFile with ISMN strings, one per line.\n";
		return 1;
	}
	$self->{'_file'} = shift @ARGV;

	my @ismns = slurp($self->{'_file'}, { chomp => 1 });

	foreach my $ismn (@ismns) {
		if (! defined $ismn) {
			print STDERR "ISMN not defined.\n";
			next;
		}
		if ($ismn =~ m/^979/ms) {
			$ismn = ean_to_ismn($ismn);
		}
		my $ismn_obj = Business::ISMN->new($ismn);
		if (! $ismn_obj) {
			print STDERR $ismn.": Cannot parse.\n";
			next;
		}
		if (! $ismn_obj->is_valid) {
			$ismn_obj->fix_checksum;
		}
		if (! $ismn_obj->is_valid) {
			print STDERR $ismn.": Not valid.\n";
			next;
		}
		if ($ismn ne $ismn_obj->as_string) {
			print STDERR $ismn.": Different after format (".$ismn_obj->as_string.").\n";
		}
	}

	return 0;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

App::ISMN::Check - Base class for isbn-check script.

=head1 SYNOPSIS

 use App::ISMN::Check;

 my $app = App::ISMN::Check->new;
 my $exit_code = $app->run;

=head1 METHODS

=head2 C<new>

 my $app = App::ISMN::Check->new;

Constructor.

=head2 C<run>

 my $exit_code = $app->run;

Run.

Returns 1 for error, 0 for success.

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.

=head1 EXAMPLE1

=for comment filename=check_example_isbns.pl

 use strict;
 use warnings;

 use App::ISMN::Check;
 use File::Temp;
 use IO::Barf qw(barf);

 # ISMNs for test.
 my $isbns = <<'END';
 978-80-253-4336-4
 9788025343363
 9788025343364
 978802534336
 9656123456
 END

 # Temporary file.
 my $temp_file = File::Temp->new->filename;

 # Barf out.
 barf($temp_file, $isbns);

 # Arguments.
 @ARGV = (
         $temp_file,
 );

 # Run.
 exit App::ISMN::Check->new->run;

 # Output:
 # 9788025343363: Different after format (978-80-253-4336-4).
 # 9788025343364: Different after format (978-80-253-4336-4).
 # 978802534336: Cannot parse.
 # 9656123456: Not valid.

=head1 EXAMPLE2

=for comment filename=print_help.pl

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
 # Usage: ./print_help.pl [-h] [--version] file_with_isbns
 #         -h              Print help.
 #         --version       Print version.
 #         file_with_isbns File with ISMN strings, one per line.

=head1 DEPENDENCIES

L<Business::ISMN>,
L<Class::Utils>,
L<Error::Pure>,
L<Getopt::Std>,
L<Perl6::Slurp>.

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/App-ISMN-Check>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2024 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
