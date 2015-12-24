# NAME

Mojo::Snoo - Mojo wrapper for the Reddit API

# DESCRIPTION

[Mojo::Snoo](https://metacpan.org/pod/Mojo::Snoo) is a Perl wrapper for the Reddit API which
relies heavily on the Mojo modules. [Mojo::Collection](https://metacpan.org/pod/Mojo::Collection)
was the initial inspiration for going the Mojo route.
Skip to [synopsis](https://metacpan.org/pod/Mojo::Snoo#SYNOPSIS) to see how
[Mojo::Snoo](https://metacpan.org/pod/Mojo::Snoo) can be great for one-liners, quick
scripts, and full-blown applications!

# SYNOPSIS

    use Mojo::Snoo;

    # OAuth ONLY. Reddit is deprecating cookie auth soon.
    my $snoo = Mojo::Snoo->new(
        username      => 'foobar',
        password      => 'very_secret',
        client_id     => 'oauth_client_id',
        client_secret => 'very_secret_oauth',
    );

    # upvote first 10 posts from /r/perl after a specific post ID
    $snoo->subreddit('perl')->links(
        10 => {after => 't3_39ziem'} => sub {
            say shift->code;    # callback receives Mojo::Message::Response
        }
    )->each(sub { $_->upvote });

    # print names of moderators from /r/Perl
    # Warning: mods() is subject to change!
    Mojo::Snoo->new->subreddit('Perl')->mods->each( sub { say $_->name } );

    # Print moderators via Mojo::Snoo::Subreddit
    Mojo::Snoo::Subreddit->new('Perl')->mods->each( sub { say $_->name } );

    # print title and author of the newest "self" posts from /r/perl
    Mojo::Snoo::Subreddit->new('Perl')->links_new(50)->grep(sub { $_->is_self })
      ->each(sub { say $_->title, ' posted by ', $_->author });

    # get the top 3 controversial links on /r/AskReddit
    @links = Mojo::Snoo::Subreddit->new('Perl')->links_contro_all(3);

    # print past week's top video URLs from /r/videos
    Mojo::Snoo::Subreddit->new('Perl')->links_top_week->each( sub { say $_->url } );

    # print the /r/Perl subreddit description
    say Mojo::Snoo->new->subreddit('Perl')->about->description;

    # even fetch a subreddit's header image!
    say Mojo::Snoo->new->subreddit('Perl')->about->header_img;

# METHODS

## multireddit

Returns a [Mojo::Snoo::Multireddit](https://metacpan.org/pod/Mojo::Snoo::Multireddit) object.

## subreddit

Returns a [Mojo::Snoo::Subreddit](https://metacpan.org/pod/Mojo::Snoo::Subreddit) object.

## link

Returns a [Mojo::Snoo::Link](https://metacpan.org/pod/Mojo::Snoo::Link) object.

## comment

Returns a [Mojo::Snoo::Comment](https://metacpan.org/pod/Mojo::Snoo::Comment) object.

## user

Returns a [Mojo::Snoo::User](https://metacpan.org/pod/Mojo::Snoo::User) object.

# WHY SNOO?

Snoo is reddit's alien mascot. Not to be confused
with [snu-snu](https://en.wikipedia.org/wiki/Amazon_Women_in_the_Mood).

Reddit's [licensing changes](https://www.reddit.com/r/redditdev/comments/2ujhkr/important_api_licensing_terms_clarified/)
prohibit the word "reddit" from being used in the name of reddit API clients.

# API DOCUMENTATION

Please see the official [Reddit API documentation](http://www.reddit.com/dev/api)
for more details regarding the usage of endpoints. For a better idea of how
OAuth works, see the [Quick Start](https://github.com/reddit/reddit/wiki/OAuth2-Quick-Start-Example)
and the [full documentation](https://github.com/reddit/reddit/wiki/OAuth2). There is
also a lot of useful information of the [redditdev subreddit](http://www.reddit.com/r/redditdev).

# SEE ALSO

[ojo::Snoo](https://metacpan.org/pod/ojo::Snoo)

[Mojolicious::Command::snoodoc](https://metacpan.org/pod/Mojolicious::Command::snoodoc)

# LICENSE

Copyright (C) 2015 by Curtis Brandt

The (two-clause) FreeBSD License. See LICENSE for details.
