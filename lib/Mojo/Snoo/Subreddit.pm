package Mojo::Snoo::Subreddit;
use Mojo::Base 'Mojo::Snoo::Base';

use Mojo::Collection;
use Mojo::Snoo::Thing;
use Mojo::Util qw(monkey_patch);

has 'name';
has about => \&_build_about;
has things => \&_build_things;
has mods => \&_build_mods;

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
    my $json = $self->_get('/r/'.$self->name.'/about');

    my $pkg = 'Mojo::Snoo::Subreddit::About::' . $self->name;
    $self->_monkey_patch( $pkg, $json->{data} );
}

# fetch things
# create new thing objects
# TODO pass params
sub _build_things {
    my $self = shift;
    my $json = $self->_get('/r/'.$self->name);

    my @children =
      map { $_->{kind} eq 't3' ? $_->{data} : () }    #
      @{ $json->{data}{children} };

    my @things;
    for my $child (@children) {
        my %thing;
        $thing{author} = $child->{author};
        $thing{url}    = $child->{url};
        $thing{title}  = $child->{title};

	push @things, Mojo::Snoo::Thing->new(%thing);
    }
    use Data::Dumper 'Dumper';
    #say Dumper \@things;
    Mojo::Collection->new(@things);
}

1;
