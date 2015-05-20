package Mojo::Snoo::Subreddit;
use Moo;

extends 'Mojo::Snoo::Base';

use Mojo::Collection;
use Mojo::Snoo::Thing;

use constant FIELD => 'name';

has name => (
    is  => 'ro',
    isa => sub {
        die "Subreddit needs a name!" unless $_[0];
    },
    required => 1
);

has about => (is => 'ro', lazy => 1, builder => '_build_about');
has mods  => (is => 'ro', lazy => 1, builder => '_build_mods');

sub BUILDARGS { shift->SUPER::BUILDARGS(@_ == 1 ? (name => shift) : @_) }

sub _build_mods {
    my $self = shift;
    my $path = '/r/' . $self->name . '/about/moderators';
    my $json = $self->_do_request('GET', $path);

    my @mods = @{$json->{data}{children}};

    # FIXME should we return User objects instead? or combined?
    my @collection;
    for my $child (@mods) {
        my $pkg = 'Mojo::Snoo::Subreddit::Mods::' . $self->name . '::' . $child->{name};
        push @collection, $self->_monkey_patch($pkg, $child);
    }
    Mojo::Collection->new(@collection);
}

sub _build_about {
    my $self = shift;
    my $path = '/r/' . $self->name . '/about';
    my $json = $self->_do_request('GET', $path);

    my $pkg = 'Mojo::Snoo::Subreddit::About::' . $self->name;
    $self->_monkey_patch($pkg, $json->{data});
}

sub _get_things {
    my ($self, $limit, $sort, $time) = @_;
    my $path = '/r/' . $self->name;
    $path .= "/$sort" if $sort;

    my %params;

    $params{t}     = $time  if $time;
    $params{limit} = $limit if $limit;

    my $json = $self->_do_request('GET', $path, %params);

    my @children =
      map { $_->{kind} eq 't3' ? $_->{data} : () }    #
      @{$json->{data}{children}};

    my %args = map { $_ => $self->$_ } (qw(
        username
        password
        client_id
        client_secret
    ));
    my @things = map Mojo::Snoo::Thing->new(%args, %$_), @children;
    Mojo::Collection->new(@things);
}

sub things              { shift->_get_things(shift) }
sub things_new          { shift->_get_things(shift, 'new') }
sub things_rising       { shift->_get_things(shift, 'rising') }
sub things_contro       { shift->_get_things(shift, 'controversial') }
sub things_contro_week  { shift->_get_things(shift, 'controversial', 'week') }
sub things_contro_month { shift->_get_things(shift, 'controversial', 'month') }
sub things_contro_year  { shift->_get_things(shift, 'controversial', 'year') }
sub things_contro_all   { shift->_get_things(shift, 'controversial', 'all') }
sub things_top          { shift->_get_things(shift, 'top') }
sub things_top_week     { shift->_get_things(shift, 'top', 'week') }
sub things_top_month    { shift->_get_things(shift, 'top', 'month') }
sub things_top_year     { shift->_get_things(shift, 'top', 'year') }
sub things_top_all      { shift->_get_things(shift, 'top', 'all') }

1;

__END__

=head1 NAME

Mojo::Snoo::Subreddit - Mojo wrapper for Reddit Subreddits

=head1 SYNOPSIS

    use Mojo::Snoo::Subreddit;

    # OAuth ONLY. Reddit is deprecating cookie auth soon.
    my $snoo = Mojo::Snoo::Subreddit->new(
        username      => 'foobar',
        password      => 'very_secret',
        client_id     => 'oauth_client_id',
        client_secret => 'very_secret_oauth',
    );

    # send message to /u/foobar
    $snoo->send_message(
        title => 'this is not spam',
        body  => q@Hi, how ya doin'?@,
    );

=head1 ATTRIBUTES

=head2 name

The name of the user. This is required for object
instantiation. The constructor can accept a single
string value or key/value pairs. Examples:

    Mojo::Snoo::Subreddit->new('perl')->name;
    Mojo::Snoo::Subreddit->new(name => 'perl')->name;

=head2 about

Returns the About section of a subreddit.

    GET /r/$subreddit/about

Returns a monkey-patched object containing all of the
keys under the JSON's "data" key. Example:

    my $about = Mojo::Snoo::Subreddit->new('perl')->about;

    say $about-title;
    say $about->description;
    say $about->description_html;

=head2 mods

Returns a list of the subreddit's moderators.

    GET /r/$subreddit/about/moderators

Returns a L<Mojo::Collection> object containing a list of
monkey-patched objects. Example:

    Mojo::Snoo::Subreddit->new('perl')->mods->each(
        sub {
            say $_->id;
            say $_->name;
            say $_->date;
            say $_->mod_permissions;
        }
    );

=head1 METHODS

=head2 things

Returns a L<Mojo::Collection> object containing a list of
L<Mojo::Snoo::Thing> objects.

    GET /r/$subreddit

Accepts one argument which indicates the maximum number of
Things (reddit API's limit parameter). Default is 25, max
is 100.

=head2 things_new

Like L</things> but sorted by new.

    GET /r/$subreddit/new

=head2 things_rising

Like L</things> but sorted by rising.

    GET /r/$subreddit/rising

=head2 things_top

Like L</things> but sorted by top (most upvoted).

    GET /r/$subreddit/top

=head2 things_top_week

Like L</things_top> but from the past week.

    GET /r/$subreddit/top?t=week

=head2 things_top_month

Like L</things_top> but from the past month.

    GET /r/$subreddit/top?t=month

=head2 things_top_year

Like L</things_top> but from the past year.

    GET /r/$subreddit/top?t=year

=head2 things_top_all

Like L</things_top> but from all time.

    GET /r/$subreddit/top?t=all

=head2 things_contro

Like L</things> but sorted by controversial.

    GET /r/$subreddit/controversial

=head2 things_contro_week

Like L</things_contro> but from the past week.

    GET /r/$subreddit/controversial?t=week

=head2 things_contro_month

Like L</things_contro> but from the past month.

    GET /r/$subreddit/controversial?t=month

=head2 things_contro_year

Like L</things_contro> but from the past year.

    GET /r/$subreddit/controversial?t=year

=head2 things_contro_all

Like L</things_contro> but from all time.

    GET /r/$subreddit/controversial?t=all

=head1 API DOCUMENTATION

Please see the official L<Reddit API documentation|http://www.reddit.com/dev/api>
for more details regarding the usage of endpoints. For a better idea of how
OAuth works, see the L<Quick Start|https://github.com/reddit/reddit/wiki/OAuth2-Quick-Start-Example>
and the L<full documentation|https://github.com/reddit/reddit/wiki/OAuth2>. There is
also a lot of useful information of the L<redditdev subreddit|http://www.reddit.com/r/redditdev>.

=head1 LICENSE

The (two-clause) FreeBSD License. See LICENSE for details.
