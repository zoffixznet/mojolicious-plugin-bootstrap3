use Mojo::Base -base;
use Mojolicious;
use Test::Mojo;
use Test::More;

$ENV{PATH} = '/dev/null';    # make sure sass is not found

my $app = Mojolicious->new(mode => 'production');
my $t = Test::Mojo->new($app);

$app->plugin('bootstrap3');
$app->routes->get('/test1' => 'test1');
$t->get_ok('/test1')->status_is(200)->text_like('script', qr{Bootstrap: affix\.js}, 'affix.js')
  ->text_like('script', qr{jQuery Foundation}, 'jQuery')->text_like('style', qr{normalize\.css}, 'normalize.css')
  ->text_like('style', qr{\.navbar-fixed-bottom}, 'navbar-fixed-bottom')
  ->text_like('style', qr{\.btn-warning},         'btn-warning');

done_testing;

__DATA__
@@ test1.html.ep
%= asset 'bootstrap.css' => { inline => 1 };
%= asset 'bootstrap.js' => { inline => 1 };
