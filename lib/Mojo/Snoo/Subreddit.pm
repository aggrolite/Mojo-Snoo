package Mojo::Snoo::Subreddit;
#use Mojo::Base 'Mojo::Snoo::Base';
use Moo;

extends 'Mojo::Snoo::Base';

use Mojo::Collection;
use Mojo::Snoo::Thing;

has name => (
    is  => 'ro',
    isa => sub {
        die "Subreddit needs a name!" unless $_[0];
    },
    required => 1
);

has about => (is => 'ro', lazy => 1, builder => '_build_about');
has mods  => (is => 'ro', lazy => 1, builder => '_build_mods');

# let the user call the constructor using new($sub) or new(name => $sub)
sub BUILDARGS {
    my ($class, @args) = @_;
    @args > 1 ? { @args } : { name => shift @args };
};

sub _build_mods {
    my $self = shift;
    my $json = $self->_get('/r/'.$self->name.'/about/moderators');

    my @mods = @{ $json->{data}{children} };

    my @collection;
    for my $child (@mods) {
        my $pkg =
          'Mojo::Snoo::Subreddit::Mods::' . $self->name . '::' . $child->{name};
        push @collection, $self->_monkey_patch( $pkg, $child );
    }
    Mojo::Collection->new(@collection);
}

sub _build_about {
    my $self = shift;
    my $json = $self->_get( '/r/' . $self->name . '/about' );

    my $pkg = 'Mojo::Snoo::Subreddit::About::' . $self->name;
    $self->_monkey_patch( $pkg, $json->{data} );
}

sub _get_things {
    my ( $self, $limit, $sort, $time ) = @_;
    my $path = '/r/' . $self->name;
    $path .= "/$sort" if $sort;

    my %params;

    $params{t}     = $time  if $time;
    $params{limit} = $limit if $limit;

    my $json = $self->_get( $path, %params );

    my @children =
      map { $_->{kind} eq 't3' ? $_->{data} : () }    #
      @{ $json->{data}{children} };

    my @things = map Mojo::Snoo::Thing->new(%$_), @children;
    Mojo::Collection->new(@things);
}

sub things              { shift->_get_things(shift) }
sub things_new          { shift->_get_things( shift, 'new' ) }
sub things_rising       { shift->_get_things( shift, 'rising' ) }
sub things_contro       { shift->_get_things( shift, 'controversial' ) }
sub things_contro_week  { shift->_get_things( shift, 'controversial', 'week' ) }
sub things_contro_month { shift->_get_things( shift, 'controversial', 'month' ) }
sub things_contro_year  { shift->_get_things( shift, 'controversial', 'year' ) }
sub things_contro_all   { shift->_get_things( shift, 'controversial', 'all' ) }
sub things_top          { shift->_get_things( shift, 'top' ) }
sub things_top_week     { shift->_get_things( shift, 'top',           'week' ) }
sub things_top_month    { shift->_get_things( shift, 'top',           'month' ) }
sub things_top_year     { shift->_get_things( shift, 'top',           'year' ) }
sub things_top_all      { shift->_get_things( shift, 'top',           'all' ) }

1;

__END__

=head1 NAME

Mojo::Snoo::Subreddit - Interact with subreddits via the Reddit API

=head1 SYNOPSIS

=head1 DESCRIPTION
