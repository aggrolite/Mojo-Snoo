package Mojo::Snoo::User;
use Moo;

extends 'Mojo::Snoo::Base';

use Mojo::Collection;

has name => (
    is  => 'ro',
    isa => sub {
        die "User needs a name!" unless $_[0];
    },
    required => 1
);

# let the user call the constructor using new($user) or new(name => $user)
sub BUILDARGS {
    my ($class, @args) = @_;
    @args > 1 ? $class->SUPER::BUILDARGS(@args) : {name => shift @args};
}

1;
