package Mojo::Snoo::Multireddit;

use Mojo::Base 'Mojo::Snoo::Base';

use Mojo::Collection;
use Mojo::Snoo::Subreddit;

has 'name';
has subreddits => \&_build_things;

# fetch things
# create new thing objects
# TODO pass params
sub _build_subreddits {
}

1;
