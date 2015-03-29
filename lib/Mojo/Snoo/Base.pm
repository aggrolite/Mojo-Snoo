package Mojo::Snoo::Base;
use Mojo::Base -base;

use Mojo::UserAgent;
use Mojo::Util ();

has base_url => 'http://www.reddit.com';

sub _get {
    my ($self, $path) = @_;
    my $url = join('', $self->base_url, $path, '.json');
    Mojo::UserAgent->new->get($url)->res->json;
}

sub _create_object {
    my ($self, $class) = @_;
    $class->new(@_);
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

=head NAME

Mojo::Snoo::Base - Reddit API base class for Mojo::Snoo modules

=head DESCRIPTION

Mojo::Snoo modules inherit from Mojo::Snoo::Base.

=head AUTHOR

Curtis Brandt <curtis@cpan.org>

=head LICENSE

???
