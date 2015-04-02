requires Mojolicious => 0;
requires Moo         => 0;

on test => sub {
    requires 'Test::More' => 0;
    requires 'Test::Pod'  => 0;
};
