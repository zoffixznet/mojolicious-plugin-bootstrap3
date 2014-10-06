use Mojo::Base -strict;
use Test::Mojo;
use Test::More;
use Mojolicious;

my %mode = map { $_ => rand(100) } qw( production development );

for my $mode (sort { $mode{$a} <=> $mode{$b} } keys %mode) {
  diag $mode;
  local $ENV{PATH} = ''; # <-- disabling `sass` tool will fail in development mode
  my $app = Mojolicious->new;
  my $t = Test::Mojo->new($app);

  $app->mode($mode);
  $app->plugin('bootstrap3');
  $app->routes->get('/' => 'index');

  $t->get_ok('/');

  if ($mode eq 'production') {
    $t->element_exists(qq(link[href^="/packed/bootstrap-"]));
    $t->element_exists(qq(script[src^="/packed/bootstrap-"]));
  }
  else {
    for(qw(
      jquery-1.11.0.min.js
      bootstrap/transition.js
      bootstrap/alert.js
      bootstrap/button.js
      bootstrap/carousel.js
      bootstrap/collapse.js
      bootstrap/dropdown.js
      bootstrap/modal.js
      bootstrap/tooltip.js
      bootstrap/popover.js
      bootstrap/scrollspy.js
      bootstrap/tab.js
      bootstrap/affix.js
    )) {
      $t->element_exists(qq(script[src="/js/$_"]));
    }

    local $TODO = $t->app->asset->preprocessors->can_process('sass') ? undef : 'AssetPack 0.21 is required';
    $t->element_exists(qq(link[href^="/packed/bootstrap-"]));
    $t->get_ok(($t->tx->res->dom->at('link') || {})->{href} || '/')->status_is(200);
  }
}

done_testing;

__DATA__
@@ index.html.ep
<!doctype html>
<html>
  <head>
    %= asset "bootstrap.css"
    %= asset "bootstrap.js"
  </head>
  <body>
    <p class="alert alert-danger">Danger, danger! High Voltage!</p>
  </body>
</html>
