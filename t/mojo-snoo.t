use Test::More;

BEGIN {
    use_ok('Mojo::Snoo');
}

diag('Creating Mojo::Snoo object');
my $snoo = Mojo::Snoo->new();
isa_ok($snoo, 'Mojo::Snoo');

diag(q@Checking can_ok for Mojo::Snoo's methods@);
can_ok($snoo, qw(multireddit subreddit thing comment user));

my $multi = $snoo->multireddit('foo');
isa_ok($multi, 'Mojo::Snoo::Multireddit');

my $sub = $snoo->subreddit('foo');
isa_ok($sub, 'Mojo::Snoo::Subreddit');

my $thing = $snoo->thing('foo');
isa_ok($thing, 'Mojo::Snoo::Thing');

my $comment = $snoo->comment('foo');
isa_ok($comment, 'Mojo::Snoo::Comment');

my $user = $snoo->user('foo');
isa_ok($user, 'Mojo::Snoo::User');

done_testing();
