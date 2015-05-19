package Mojo::Snoo::Base;
use Moo;

use Mojo::UserAgent;
use Mojo::URL;
use Mojo::Util ();

use Carp ();

has base_url => (is => 'rw', default => 'http://www.reddit.com');

sub BUILDARGS {
    my ($class, %args) = @_;

    # if the user wants oauth, make sure we have all required fields
    my @oauth_required = (qw(username password client_id client_secret));
    my @oauth_given = grep defined($args{$_}), @oauth_required;

    if (@oauth_given and @oauth_given < 4) {
        Carp::croak(    #
            'OAuth requires the following fields to be defined: '
              . join(', ', @oauth_required) . "\n"
              . 'Fields defined: '
              . join(', ', @oauth_given)
        );
    }

    \%args;
}

sub _do_request {
    my ($self, $method, $path, %params) = @_;

    my $agent = Mojo::UserAgent->new();
    my $url   = Mojo::URL->new($self->base_url);

    if ($method eq 'GET') {
        $url->path("$path.json");
        $url->query(%params) if %params;
        return $agent->get($url)->res->json;
    }

    return $agent->post($url, form => \%params)->res->body;
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
