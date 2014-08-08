use t::Helper;

{
  use Mojolicious::Lite;
  plugin 'bootstrap3', jquery => 0, js => ['affix.js'], css => [];
  get '/:type' => sub {
    my $c = shift;
    $c->render(text => $c->asset('bootstrap.'.$c->stash('type')));
  };
}

my $t = Test::Mojo->new;

$t->get_ok('/js')->status_is(200)->element_exists('script[src^="/packed/bootstrap-"]');
$t->get_ok($t->tx->res->dom->at('script')->{src})->status_is(200)->content_like(qr{affix\.js}, 'affix.js');

done_testing;
