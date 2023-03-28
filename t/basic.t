use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use lib('./lib/');

my $t = Test::Mojo->new('MojoPromiseTest');
$t->get_ok('/')->status_is(200)->content_like(qr/Mojo::Promise Tests/i);
$t->get_ok('/')->status_is(200)->content_like(qr/Promise test/i)->content_like(qr/Async Await test/i)->content_like(qr/All Settled Async Await test/i);

$t->get_ok('/promise')->status_is(200)->content_like(qr/promise/i);
$t->get_ok('/promise')->status_is(200)->content_like(qr/Missing param/);
$t->get_ok('/promise?query=')->status_is(200)->content_like(qr/Empty parameter value/);
$t->get_ok('/promise?query=TEST1234')->status_is(200)->content_like(qr/TEST1234/);

$t->get_ok('/async_await')->status_is(200)->content_like(qr/async await/i);
$t->get_ok('/async_await')->status_is(200)->content_like(qr/Missing param/);
$t->get_ok('/async_await')->status_is(200)->content_like(qr/Testing 1234/);

$t->get_ok('/async_await_all_settled')->status_is(200)->content_like(qr/all settled/i);
$t->get_ok('/async_await_all_settled')->status_is(200)->content_like(qr/Missing param/);
$t->get_ok('/async_await_all_settled')->status_is(200)->content_like(qr/Testing 1234/);

done_testing();
