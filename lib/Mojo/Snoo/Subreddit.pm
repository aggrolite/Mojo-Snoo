package Mojo::Snoo::Subreddit;
use Mojo::Base 'Mojo::Snoo::Base';

use Mojo::Collection;
use Mojo::Snoo::Thing;

has 'name';
has about               => \&_build_about;
has mods                => \&_build_mods;
has things              => \&_build_things;
has things_hot          => \&_build_things;
has things_new          => \&_build_things_new;
has things_rising       => \&_build_things_rising;
has things_contro       => \&_build_things_contro;
has things_contro_today => \&_build_things_contro;
has things_contro_week  => \&_build_things_contro_week;
has things_contro_month => \&_build_things_contro_month;
has things_contro_all   => \&_build_things_contro_all;

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
    my ( $self, $sort, $time ) = @_;
    my $path = '/r/' . $self->name;
    $path .= "/$sort" if $sort;

    my $json = $self->_get( $path, ( $time ? ( t => $time ) : () ) );

    my @children =
      map { $_->{kind} eq 't3' ? $_->{data} : () }    #
      @{ $json->{data}{children} };

    my @things = map Mojo::Snoo::Thing->new(%$_), @children;
    Mojo::Collection->new(@things);
}

sub _build_things              { shift->_get_things() }
sub _build_things_new          { shift->_get_things('new') }
sub _build_things_rising       { shift->_get_things('rising') }
sub _build_things_contro       { shift->_get_things('controversial') }
sub _build_things_contro_week  { shift->_get_things( 'controversial', 'week' ) }
sub _build_things_contro_month { shift->_get_things( 'controversial', 'month' ) }
sub _build_things_contro_all   { shift->_get_things( 'controversial', 'all' ) }

1;

__END__

=head NAME

Mojo::Snoo::Subreddit - Interact with subreddits via the Reddit API

=head SYNOPSIS

=head DESCRIPTION
