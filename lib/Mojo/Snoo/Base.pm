package Mojo::Snoo::Base;
use Moo;

use Mojo::UserAgent;
use Mojo::URL;
use Mojo::Util ();

use Carp ();

has base_url => (is => 'rw', default => 'http://www.reddit.com');

# TODO we will need to be able to "refresh" the token when authenticating users
has access_token => (is => 'rw', lazy => 1, builder => '_create_access_token');

my %TOKEN_REQUIRED = map $_ => 1,
  ( qw(
      /api/vote
      )
  );

sub _create_access_token {
    my $self = shift;
    # update base URL
    my %form = (
        grant_type => 'password',
        username => $self->username,
        password => $self->password,
    );
    my $access_url =
        'https://'
      . $self->client_id . ':'
      . $self->client_secret
      . '@www.reddit.com/api/v1/access_token';

    my $res = Mojo::UserAgent->new->post($access_url => form => \%form)->res->json;

    # if a problem arises, it is most likely due to given auth being incorrect
    # let the user know in this case
    if (exists($res->{error})) {
        my $msg =
          $res->{error} == 401
          ? '401 status code (Unauthorized)'
          : 'error response of ' . $res->{error};
        Carp::croak("Received $msg while attempting to create OAuth access token.");
    }

    # update the base URL for future endpoint calls
    $self->base_url('https://oauth.reddit.com');

    # TODO we will want to eventually keep track of token type, scope and expiration
    #      when dealing with user authentication (not just a personal script)
    return $res->{access_token};
}

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

sub _token_required {
    my ($self, $path) = @_;
    return $TOKEN_REQUIRED{$path} ? 1 : 0;
}

sub _do_request {
    my ($self, $method, $path, %params) = @_;

    my %headers;
    if ($self->_token_required($path)) {
        $headers{Authorization} = 'bearer ' . $self->access_token;
    }

    my $agent = Mojo::UserAgent->new();
    my $url   = Mojo::URL->new($self->base_url);

    $url->path("$path.json");

    my $json;
    if ($method eq 'GET') {
        $url->query(%params) if %params;
        $json = $agent->get($url => \%headers)->res->json;
    }
    else {
        $json = $agent->post($url => \%headers, form => \%params)->res->json;
    }

    if (exists($json->{error})) {
        my $msg =
          $json->{error} == 401
          ? '401 status code (Unauthorized)'
          : 'error response of ' . $json->{error};
        Carp::croak("Received $msg while calling endpoint of $path");
    }
    return $json;
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
