use Test::More;

BEGIN {
    use_ok('Mojo::Snoo::Subreddit');
}

diag('Creating Mojo::Snoo::Subreddit object');
my $perl = Mojo::Snoo::Subreddit->new('perl');
isa_ok($perl, 'Mojo::Snoo::Subreddit');

my @subs = (
    qw(
      things
      things_new
      things_rising
      things_contro
      things_contro_week
      things_contro_month
      things_contro_year
      things_contro_all
      things_top
      things_top_week
      things_top_month
      things_top_year
      things_top_all
      )
);
diag(q@Checking can_ok for Mojo::Snoo::Subreddit's methods@);
can_ok($perl, @subs);

cmp_ok($perl->name, 'eq', 'perl', q@Subreddit's name is "perl"@);

done_testing();
