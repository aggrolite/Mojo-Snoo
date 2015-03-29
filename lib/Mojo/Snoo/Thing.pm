package Mojo::Snoo::Thing;
use Mojo::Base 'Mojo::Snoo::Base';
use Mojo::Collection;

has [qw(id author url title)];

has comments => \&_build_comments;

sub _build_comments {};

1;
