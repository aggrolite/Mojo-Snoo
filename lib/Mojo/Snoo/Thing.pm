package Mojo::Snoo::Thing;
use Moo;

extends 'Mojo::Snoo::Base';

use Mojo::Collection;
use Mojo::Snoo::Comment;

has [qw( id title subreddit )] => (is => 'ro');
#has subreddit => (is => 'ro');

# TODO buildargs for user direct call

#use Data::Dumper;
#sub BUILD { shift->_struct(shift) }

# if object created with more args than:
# $id
# id => $id
# then build comments
sub BUILDARGS {
    my ($class, @args) = @_;
    @args > 1 ? { @args } : { id => shift @args };
};

#has comments => \&_build_comments;

#sub new {
#    my ($class, $id) = @_;
#
#    my $self = bless({}, $class);
#    $self->SUPER::new() if caller =~ /^Mojo::Snoo::Subreddit/;
#
#    Carp::croak 'Thing ID must be provided!' unless defined $id;
#
#    my $json = $self->_get('/comments/' . $id);
#
#    my ($post) =
#      map { $_->{kind} eq 't3' ? $_->{data} : () }    #
#      map { @{$_->{data}{children}} } @$json;
#
#    $self->SUPER::new(%$post);
#}

sub _get_comments {
    my ( $self, $sort ) = @_;

    my $path = '/r/' . $self->subreddit . '/comments/' . $self->id;
    #$path .= "/$sort" if $sort;

    my %params;
    $params{sort} = $sort if $sort;

    my $json = $self->_get( $path, %params );

    my @children =
      map { $_->{kind} eq 't1' ? $_->{data} : () }
      map { @{$_->{data}{children}} }
      @$json;

    my @things = map Mojo::Snoo::Comment->new(%$_), @children;
    Mojo::Collection->new(@things);
}

# comments_hot
# comments_new
# comments_top('
# $thing->comments($sort);
# defaults to comments_hot?
# TODO pass params:
# http://www.reddit.com/dev/api#GET_comments_{article}
sub comments { shift->_get_comments };

sub save {};

1;
