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

# let the user call the constructor using new($name) or new(name => $name)
sub BUILDARGS {
    my ($class, @args) = @_;
    @args > 1 ? { @args } : { name => shift @args };
};

1;
