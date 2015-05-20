package Mojo::Snoo::Comment;
use Moo;

extends 'Mojo::Snoo::Base';

use constant FIELD => 'id';

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

# let the user call the constructor using new($comment) or new(id => $comment)
sub BUILDARGS { shift->SUPER::BUILDARGS(@_ == 1 ? (id => shift) : @_) }

1;

__END__

=head1 NAME

Mojo::Snoo::Comment - Interact with comments via the Reddit API

=head1 SYNOPSIS

=head1 DESCRIPTION
