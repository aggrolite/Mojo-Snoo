use Mojo::Base -strict;
use Test::More;

use Mojo::Transaction::HTTP;
use Mojo::JSON qw(encode_json);

BEGIN {
    use_ok('Mojo::Snoo::Subreddit');
}

diag('Creating Mojo::Snoo::Subreddit object');
my $perl = Mojo::Snoo::Subreddit->new('perl');
isa_ok($perl, 'Mojo::Snoo::Subreddit');

my @subs = (
    qw(
      links
      links_new
      links_rising
      links_contro
      links_contro_week
      links_contro_month
      links_contro_year
      links_contro_all
      links_top
      links_top_week
      links_top_month
      links_top_year
      links_top_all
      )
);
diag(q@Checking can_ok for Mojo::Snoo::Subreddit's methods@);
can_ok($perl, @subs);

cmp_ok($perl->name, 'eq', 'perl', q@Subreddit's name is "perl"@);

diag('Now begins the code I wrote while on a plane full of screaming children');
no warnings 'redefine';
local *Mojo::Snoo::Base::_do_request = sub {
    my ($class, $method, $path, %params) = @_;
    my $tx = Mojo::Transaction::HTTP->new();
    $tx->res->code(200);

    ok($params{t}, 'We received a "t" param');

    diag('TODO test mods and about subroutines as well.');
    my $mock_data = {
        data => {
            children => [
                {   kind => 't3',
                    data => {
                        title  => 'Russian bears drink vodka.',
                        url    => 'http://www.youtube.com?v=313373',
                        domain => 'youtube.com',
                    },
                },
                {   kind => 't3',
                    data => {
                        title  => 'Kindergarten graduation gone wrong.',
                        url    => 'http://imgur.com/a/1234567',
                        domain => 'imgur.com',
                    },
                },
            ],
        },
    };

    cmp_ok(
        scalar(@{$mock_data->{data}{children}}),    #
        '==', 2, 'Mock response contains two children'
    );

    $tx->res->body(encode_json($mock_data));
    $tx->res;
};

my $cb;
my $links = $perl->links(
    5 => +{t => 'all'} => sub {    #
        isa_ok(shift, 'Mojo::Message::Response', 'Callback has response object');
        $cb = 1;
    }
);
ok($cb, 'Callback was run');

isa_ok($links, 'Mojo::Collection', 'Links returned from subreddit isa Mojo::Collection');
cmp_ok($links->size, '==', 2, 'Two links were returned');

$links->each(
    sub {
        isa_ok($_, 'Mojo::Snoo::Link');
        ok($_->has_url, 'Link has URL');
        ok($_->has_title, 'Link has title');

        can_ok($_, 'comments');
    }
);

done_testing();
