use t::Helper;

plain skip_all 'Cannot access t/public/packed' unless -d 't/public/packed';

{
  use Mojolicious::Lite;
  plugin 'bootstrap3', jquery => 0, js => ['affix.js'], css => [];
  get '/:type' => sub {
    my $c = shift;
    $c->render(text => $c->asset('bootstrap.'.$c->stash('type')));
  };
}

my $t = Test::Mojo->new;
my $src;

$t->get_ok('/js')->status_is(200)->element_exists('script[src^="/packed/bootstrap-"]');
$src = $t->tx->res->dom->at('script')->{src};
$t->get_ok($src)->status_is(200)->content_like(qr{affix\.js}, 'affix.js');

unlink "t/public/$src";

done_testing;
