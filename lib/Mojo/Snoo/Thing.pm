package Mojo::Snoo::Thing;
use Moo;

extends 'Mojo::Snoo::Base';

use Mojo::Collection;

has id => (is => 'ro');

has title => (
    is      => 'rw',
    #handles => {
        #approved_by
        #  archived
        #  author
        #  author_flair_css_class
        #  author_flair_text
        #  banned_by
        #  clicked
        #  created
        #  created_utc
        #  distinguished
        #  domain
        #  downs
        #  edited
        #  gilded
        #  hidden
        #  is_self
        #  likes
        #  link_flair_css_class
        #  link_flair_text
        #  media
        #  media_embed
        #  mod_reports
        #  name
        #  num_comments
        #  num_reports
        #  over_18
        #  permalink
        #  report_reasons
        #  saved
        #  score
        #  secure_media
        #  secure_media_embed
        #  selftext
        #  selftext_html
        #  stickied
        #  subreddit
        #  subreddit_id
        #  thumbnail
        #title => 'title',
        #  ups
        #  url
        #  user_reports
        #  visited
        #},
);

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

    unless ($self->content) {
        warn 'no content, getting address';
        my $path = '/r/' . $self->id;
        $path .= "/$sort" if $sort;

        my %params;

        $params{sort} = $sort if $sort;

        $self->_get( $path, %params );
    }

    my @children =
      map { $_->{kind} eq 't3' ? $_->{data} : () }    #
      @{ $self->content->{data}{children} };

    my @things = map Mojo::Snoo::Thing->new(%$_), @children;
    Mojo::Collection->new(@things);
}

sub comments { shift->_get_comments(shift) };

sub save {};

1;
