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
