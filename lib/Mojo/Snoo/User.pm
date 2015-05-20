package Mojo::Snoo::User;
use Moo;

extends 'Mojo::Snoo::Base';

use Mojo::Collection;

use constant FIELD => 'name';

has name => (
    is  => 'ro',
    isa => sub {
        die "User needs a name!" unless $_[0];
    },
    required => 1
);

sub BUILDARGS { shift->SUPER::BUILDARGS(@_ == 1 ? (name => shift) : @_) }

sub send_message {
    my $self = shift;

    # make sure we're clear of any captcha if required
    my ($captcha_id, $captcha_text) = $self->_solve_captcha();

    my %form = (
        api_type => 'json',
        captcha  => $captcha_text,
        iden     => $captcha_id,
        subject  => 'subject goes here',
        text     => 'body goes here',
        to       => $self->name,
    );
    $self->_do_request('POST', '/api/compose', %form);
}

1;
