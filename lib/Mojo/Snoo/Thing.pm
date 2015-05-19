package Mojo::Snoo::Thing;
use Moo;

extends 'Mojo::Snoo::Base';

use Mojo::Collection;
use Mojo::Snoo::Comment;

has [qw( id name title subreddit )] => (is => 'ro');

#has subreddit => (is => 'ro');

# TODO buildargs for user direct call

#use Data::Dumper;
#sub BUILD { shift->_struct(shift) }

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
    my ($self, $sort) = @_;

    my $path = '/r/' . $self->subreddit . '/comments/' . $self->id;

    #$path .= "/$sort" if $sort;

    my %params;
    $params{sort} = $sort if $sort;

    my $json = $self->_do_request('GET', $path, %params);

    my @children =
      map { $_->{kind} eq 't1' ? $_->{data} : () }
      map { @{$_->{data}{children}} } @$json;

    my %args = map { $_ => $self->$_ } (qw(
        username
        password
        client_id
        client_secret
    ));
    my @things = map Mojo::Snoo::Comment->new(%args, %$_), @children;
    Mojo::Collection->new(@things);
}

sub _vote {
    my ($self, $direction) = @_;

    my %params = (
        dir => $direction,
	id => $self->name,
    );

    $self->_do_request('POST', '/api/vote', %params);
}

# comments_hot
# comments_new
# comments_top('
# $thing->comments($sort);
# defaults to comments_hot?
# TODO pass params:
# http://www.reddit.com/dev/api#GET_comments_{article}
sub comments { shift->_get_comments }

sub upvote   { shift->_vote(1)  }
sub downvote { shift->_vote(-1) }
sub unvote   { shift->_vote(0)  }

sub save { }

1;
