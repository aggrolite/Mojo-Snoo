package Mojo::Snoo::Base;
use Moo;

use Mojo::UserAgent;
use Mojo::URL;
use Mojo::Util ();

use Carp ();

has base_url => (is => 'rw', default => 'http://www.reddit.com');

sub _get {
    my ( $self, $path, %params ) = @_;

    my $url = Mojo::URL->new( $self->base_url );
    $url->path("$path.json");
    $url->query(%params) if %params;

    Mojo::UserAgent->new->get($url)->res->json;
}

sub _create_object {
    my ($self, $class, @args) = @_;
    $class->new(@args);
}

sub _monkey_patch {
    my ($self, $class, $patch) = @_;

    Mojo::Util::monkey_patch(
        $class,
        map {
            my $key = $_;
            $key => sub { $patch->{$key} }
        } keys %$patch,
    );
    bless({}, $class);
}

1;

__END__

=head1 NAME

Mojo::Snoo::Base - Reddit API base class for Mojo::Snoo modules

=head1 DESCRIPTION

Mojo::Snoo modules inherit from Mojo::Snoo::Base.

=head1 AUTHOR

Curtis Brandt <curtis@cpan.org>
