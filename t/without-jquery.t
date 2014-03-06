use t::Helper;

{
  use Mojolicious::Lite;
  plugin 'bootstrap3', jquery => 0, js => ['affix.js'], css => [];
  get '/:type' => sub {
    my $c = shift;
    $c->render(text => $c->asset('bootstrap.'.$c->stash('type')));
  };
  app->start;
}

my $t = Test::Mojo->new;

$t->get_ok('/js')->status_is(200)->element_exists('script[src="/packed/bootstrap-a779d5400d6128c28ac269e4bd986cd2.js"]');

$t->get_ok('/packed/bootstrap-a779d5400d6128c28ac269e4bd986cd2.js')
  ->status_is(200)
  ->content_like(qr{affix\.js}, 'affix.js')
  ;

done_testing;
