package Mojo::Snoo::Comment;
#use Mojo::Base 'Mojo::Snoo::Base';
use Moo;

extends 'Mojo::Snoo::Base';

has [qw( id author body )] => (is => 'ro');

# let the user call the constructor using new($sub) or new(name => $sub)
sub BUILDARGS {
    my ($class, @args) = @_;
    @args > 1 ? { @args } : { name => shift @args };
};

1;

__END__

=head1 NAME

Mojo::Snoo::Comment - Interact with comments via the Reddit API

=head1 SYNOPSIS

=head1 DESCRIPTION
