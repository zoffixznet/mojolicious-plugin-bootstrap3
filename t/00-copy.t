use Mojo::Base -base;
use Mojolicious;
use Mojolicious::Plugin::Bootstrap3;
use Test::More;
use File::Basename;
use File::Copy;
use File::Find;
use File::Path qw( make_path remove_tree );

plan skip_all => 'Cannot copy files without _bootstrap.scss' unless -r 'assets/stylesheets/_bootstrap.scss';

my $CAN_SASS = do {
  my $app = Mojolicious->new;
  $app->plugin('AssetPack');
  $app->asset->preprocessors->can_process('scss');
};

my $BASE = 'lib/Mojolicious/Plugin/Bootstrap3';

mkdir $BASE or die "mkdir $BASE: $!" unless -d $BASE;

remove_tree "$BASE/$_" for qw( font js/bootstrap packed sass );

find(
  {
    follow   => 0,
    no_chdir => 1,
    wanted   => sub {
      return if -d $File::Find::name;
      my $dest = dest($File::Find::name) or return diag "No destination for $File::Find::name";
      my $dir = dirname($dest);
      make_path($dir) or die "mkdir $dir: $!" unless -d $dir;
      copy $File::Find::name => $dest or die "cp $File::Find::name $dest: $!";
    },
  },
  'assets',
);

ok -e "$BASE/sass/bootstrap.scss", "bootstrap.scss";

SKIP: {
  skip 'Sass is required', 1 unless $CAN_SASS;
  my $app = Mojolicious->new;
  $app->mode('production');
  $app->static->paths([Mojolicious::Plugin::Bootstrap3->asset_path]);
  $app->plugin('bootstrap3');
  diag join ' ', packed_files();
  is_deeply([packed_files()], [qw( bootstrap.css bootstrap.js )], 'packed for production',);
}

SKIP: {
  skip 'Sass is required', 1 unless $CAN_SASS;
  my $app = Mojolicious->new;
  $app->static->paths([Mojolicious::Plugin::Bootstrap3->asset_path]);
  $app->mode('development');
  $app->plugin('bootstrap3');
  is_deeply(
    [packed_files()],
    [
      qw(
        affix.js alert.js bootstrap.css bootstrap.js button.js
        carousel.js collapse.js dropdown.js jquery-1.11.0.min.js
        modal.js popover.js scrollspy.js tab.js tooltip.js
        transition.js
        )
    ],
    'packed for development',
  );
}

done_testing;

sub dest {
  my $file = $_[0];
  my $name = basename $file;
  my @path = split '/', dirname $file;

  while (@path) {
    my $p = shift @path;
    last if $p eq 'stylesheets';
  }

  $name = 'bootstrap.scss' if $name eq '_bootstrap.scss';
  local $" = '/';

  return "$BASE/font/$name"         if $file =~ /\bfonts\b/;
  return "$BASE/js/bootstrap/$name" if $file =~ /\.js$/;
  return "$BASE/sass/@path/$name"   if $file =~ /\.scss$/;
  return;
}

sub packed_files {
  sort map { s!-\w+\.(\w+)$!.$1!; basename $_ } glob "$BASE/packed/*";
}
