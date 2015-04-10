package Mojo::Snoo::Comment;
use Moo;

extends 'Mojo::Snoo::Base';

has id => (
    is  => 'ro',
    isa => sub {
        die "Comment needs ID!" unless $_[0];
    },
    required => 1
);

has [qw( author body )] => (is => 'ro');

use Mojo::Util qw(dumper);

has replies => (
    is      => 'rw',
    trigger => sub { warn dumper($_) for @_ },
);

# let the user call the constructor using new($sub) or new(name => $sub)
sub BUILDARGS {
    my ($class, @args) = @_;
    @args > 1 ? { @args } : { id => shift @args };
};

1;

__END__

=head1 NAME

Mojo::Snoo::Comment - Interact with comments via the Reddit API

=head1 SYNOPSIS

=head1 DESCRIPTION
