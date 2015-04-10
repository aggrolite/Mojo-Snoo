package Mojo::Snoo::Multireddit;
use Moo;

extends 'Mojo::Snoo::Base';

use Mojo::Collection;
use Mojo::Snoo::Subreddit;

has name => (
    is  => 'ro',
    isa => sub {
        die "Multireddit needs a name!" unless $_[0];
    },
    required => 1
);

# let the user call the constructor using new($multi) or new(name => $multi)
sub BUILDARGS {
    my ($class, @args) = @_;
    @args > 1 ? { @args } : { name => shift @args };
};

# fetch things
# create new thing objects
# TODO pass params
sub _build_subreddits {
}

1;
