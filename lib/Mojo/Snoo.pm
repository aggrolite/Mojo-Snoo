package Mojo::Snoo;
use Mojo::Base 'Mojo::Snoo::Base';

use Mojo::Snoo::Multireddit;
use Mojo::Snoo::Subreddit;
use Mojo::Snoo::Thing;
use Mojo::Snoo::User;

sub multisubreddit {
    shift->_create_object('Mojo::Snoo::Multireddit', @_);
}

sub subreddit {
    shift->_create_object('Mojo::Snoo::Subreddit', name => shift);
}

sub thing {
    shift->_create_object('Mojo::Snoo::Thing', @_);
}

sub user {
    shift->_create_object('Mojo::Snoo::User', @_);
}

1;


__END__

=head1 NAME

Mojo::Snoo - Mojo wrapper for the Reddit API

=head1 DESCRIPTION

L<Mojo::Snoo> is a Perl wrapper for the Reddit API which
relies heavily on the Mojo modules. L<Mojo::Collection>
was the initial inspiration for going the Mojo route.
Skip to L<synopsis|Mojo::Snoo/SYNOPSIS> to see how
L<Mojo::Snoo> can be great for one-liners, quick
scripts, and full-blown applications!

=head1 SYNOPSIS

    use Mojo::Snoo;

    # create a new Mojo::Snoo::Subreddit object
    $sub = Mojo::Snoo->new->subreddit('Perl');

    # or call Mojo::Snoo::Subreddit directly
    $sub = Mojo::Snoo::Subreddit->new('Perl');

    # print names of moderators from /r/Perl
    say $sub->mods->each( sub { say $_->name } );

    # print title and author of each post (or "thing") from /r/Perl
    # returns 25 "hot" posts by default
    $sub->things->each( sub { say $_->title, ' posted by ', $_->author } );

    # get only self posts
    @selfies = $sub->things->grep( sub { $_->is_self } );

    # get 100 new posts ("things") from /r/Perl
    @things = $sub->things_new(100);

    # print the /r/Perl subreddit description
    say Mojo::Snoo->new->subreddit('Perl')->about->description;

    # get the /r/Perl header image!
    say Mojo::Snoo->new->subreddit('Perl')->about->header_img;
