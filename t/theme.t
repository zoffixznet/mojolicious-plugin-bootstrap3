BEGIN { $ENV{MOJO_ASSETPACK_NO_CACHE} = 1 }
use Mojo::Base -base;
use Mojolicious;
use Test::Mojo;
use Test::More;
use File::Temp 'tempdir';
use File::Path qw( make_path remove_tree );

my $tempdir = tempdir;
my $app     = Mojolicious->new(mode => 'development', home => Mojo::Home->new($tempdir));
my $t       = Test::Mojo->new($app);

make_path "$tempdir/public";
$app->plugin('AssetPack', {minify => 0});

plan skip_all => 'BS_THEME=https://bootswatch.com/paper/_bootswatch.scss' unless $ENV{BS_THEME};
plan skip_all => 'Sass is required' unless $app->asset->preprocessors->can_process('scss');

eval {
  $app->plugin('bootstrap3', js => [], theme => {paper => $ENV{BS_THEME}});
  $app->routes->get('/test1' => 'test1');
  $t->get_ok('/test1')->status_is(200)->element_exists('style')
    ->content_like(qr{family=Roboto}, 'paper _bootswatch.scss')->content_like(qr{\#2196F3}, 'paper _variables.scss')
    ->content_like(qr{a\.thumbnail}, 'bootstrap3');
} or do {
  is $@, undef, 'loading bootstrap3 plugin';
};

remove_tree $tempdir;
ok !-d $tempdir, "$tempdir was removed";

done_testing;

__DATA__
@@ test1.html.ep
%= asset 'paper.css' => { inline => 1 };
