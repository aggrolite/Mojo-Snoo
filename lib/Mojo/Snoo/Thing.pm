package Mojo::Snoo::Thing;
use Moo;

extends 'Mojo::Snoo::Base';

use Mojo::Collection;
use Mojo::Snoo::Comment;

use constant FIELD => 'name';

has [qw( id name title subreddit )] => (is => 'ro');

sub BUILDARGS { shift->SUPER::BUILDARGS(@_ == 1 ? (name => shift) : @_) }

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
sub comments { shift->_get_comments(@_) }

sub upvote   { shift->_vote(1)  }
sub downvote { shift->_vote(-1) }
sub unvote   { shift->_vote(0)  }

# TODO support category (gold accounts only)
sub save {
    my $self = shift;
    $self->_do_request('POST', '/api/save', id => $self->name);
}

# TODO support category (gold accounts only)
sub unsave {
    my $self = shift;
    $self->_do_request('POST', '/api/unsave', id => $self->name);
}

1;

__END__

=head1 NAME

Mojo::Snoo::Thing - Mojo wrapper for Reddit Things

=head1 SYNOPSIS

    use Mojo::Snoo::Thing;

    # OAuth ONLY. Reddit is deprecating cookie auth soon.
    my $thing = Mojo::Snoo::Thing->new(
        name          => 't3_36x619',
        username      => 'foobar',
        password      => 'very_secret',
        client_id     => 'oauth_client_id',
        client_secret => 'very_secret_oauth',
    );

    # save this listing (or "thing")
    $thing->save();

=head1 ATTRIBUTES

=head2 id

The name of the thing. This is required for object
instantiation. The constructor can accept a single
string value or key/value pairs. Examples:

    Mojo::Snoo::Thing->new('t3_36x619')->name;
    Mojo::Snoo::Thing->new(name => 't3_36x619')->name;

=head1 METHODS

=head2 comments

Returns a L<Mojo::Collection> object containing a list of
L<Mojo::Snoo::Comment> objects.

    GET /r/$subreddit/comments/article

=head1 API DOCUMENTATION

Please see the official L<Reddit API documentation|http://www.reddit.com/dev/api>
for more details regarding the usage of endpoints. For a better idea of how
OAuth works, see the L<Quick Start|https://github.com/reddit/reddit/wiki/OAuth2-Quick-Start-Example>
and the L<full documentation|https://github.com/reddit/reddit/wiki/OAuth2>. There is
also a lot of useful information of the L<redditdev subreddit|http://www.reddit.com/r/redditdev>.

=head1 LICENSE

The (two-clause) FreeBSD License. See LICENSE for details.
