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

    # create a new Mojo::Snoo::Subreddit object
    $sub = Mojo::Snoo->new->subreddit('Perl');

    # or call Mojo::Snoo::Subreddit directly
    $sub = Mojo::Snoo::Subreddit->new('Perl');

    # print names of moderators from /r/Perl
    $sub->mods->each( sub { say $_->name } );

    # print title and author of each post (or "thing") from /r/Perl
    # returns 25 "hot" posts by default
    $sub->things->each( sub { say $_->title, ' posted by ', $_->author } );

    # get only self posts
    @selfies = $sub->things->grep( sub { $_->is_self } );

    # get the top 3 controversial posts ("things") on /r/AskReddit
    @things = $sub->things_contro_all(3);

    # print past week's top video URLs from /r/videos
    $sub->things_top_week->each( sub { say $_->url } );

    # print the /r/Perl subreddit description
    say Mojo::Snoo->new->subreddit('Perl')->about->description;

    # get the /r/Perl header image!
    say Mojo::Snoo->new->subreddit('Perl')->about->header_img;

# LICENSE

The (two-clause) FreeBSD License. See LICENSE for details.
