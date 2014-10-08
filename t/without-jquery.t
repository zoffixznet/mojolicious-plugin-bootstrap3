use Mojo::Base -base;
use Mojolicious;
use Test::Mojo;
use Test::More;

my $app = Mojolicious->new(mode => 'production');
my $t = Test::Mojo->new($app);

$app->plugin('AssetPack');

plan skip_all => 'Sass is required' unless $app->asset->preprocessors->can_process('scss');

$app->plugin(bootstrap3 => jquery => 0, js => ['affix.js'], css => []);
$app->routes->get('/test1' => 'test1');
$t->get_ok('/test1')->status_is(200)->text_like('script', qr{Bootstrap: affix\.js})
  ->text_unlike('script', qr{jQuery Foundation}i);

done_testing;

__DATA__
@@ test1.html.ep
%= asset 'bootstrap.js' => { inline => 1 };
