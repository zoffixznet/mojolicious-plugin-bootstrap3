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

plan skip_all => 'Unable to create application home' unless -d "$tempdir/public";
plan skip_all => 'Sass is required' unless $app->asset->preprocessors->can_process('scss');

eval {
  $app->plugin('bootstrap3', js => [], custom => 1);
  $app->routes->get('/test1' => 'test1');
  $t->get_ok('/test1')->status_is(200)->element_exists('style')->content_like(qr{a\.thumbnail});
} or do {
  is $@, undef, 'loading bootstrap3 plugin';
};

ok -d "$tempdir/public/sass",                "$tempdir/public/sass";
ok -f "$tempdir/public/sass/bootstrap.scss", "$tempdir/public/sass/bootstrap.scss";

{
  local @ARGV = ("$tempdir/public/sass/bootstrap.scss");
  local $^I   = '';
  while (<>) {
    s/.*// unless /Components/ ... /Components/;
    print;
  }
}

$t->get_ok('/test1')->status_is(200)->element_exists('style')->content_unlike(qr{a\.thumbnail});

remove_tree $tempdir;
ok !-d $tempdir, "$tempdir was removed";

done_testing;

__DATA__
@@ test1.html.ep
%= asset 'bootstrap.css' => { inline => 1 };
