use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('TestWork');
$t->get_ok('/')->status_is(200)->content_like(qr/url/i);
$t->post_ok('/add/', form => {nu => 'http://lib.ru'});

done_testing();
