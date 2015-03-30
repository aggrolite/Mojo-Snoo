package Mojo::Snoo::User;
use Mojo::Base 'Mojo::Snoo::Base';

use Mojo::Collection;

has 'name';
has subreddits => \&_build_things;

# fetch things
# create new thing objects
# TODO pass params
sub _build_subreddits {
}

1;
