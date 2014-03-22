package t::Helper;
BEGIN { $ENV{MOJO_MODE} ||= 'production' }
use Mojo::Base -strict;
use Test::More;
use Test::Mojo;

my $base = 'lib/Mojolicious/Plugin/Bootstrap3';
my $vendor = 'vendor/assets';

sub copy_font {
  mkdir "$base/font";

  for(qw(
    glyphicons-halflings-regular.eot glyphicons-halflings-regular.svg
    glyphicons-halflings-regular.ttf glyphicons-halflings-regular.woff
  )) {
    link "$vendor/fonts/bootstrap/$_", "$base/font/$_" or die "$_: $!";
  }
}

sub copy_javascript {
  mkdir "$base/js/bootstrap";

  for(qw(
    button.js carousel.js scrollspy.js popover.js dropdown.js tooltip.js alert.js
    transition.js affix.js collapse.js modal.js tab.js
  )) {
    link "$vendor/javascripts/bootstrap/$_", "$base/js/bootstrap/$_" or die "$_: $!";
  }
}

sub copy_sass_bootstrap {
  mkdir "$base/sass";
  mkdir "$base/sass/bootstrap";
  link "$vendor/stylesheets/bootstrap.scss", "$base/sass/bootstrap.scss" or die "link bootstrap.scss: $!";

  for(qw(
    _alerts.scss _badges.scss _breadcrumbs.scss _button-groups.scss _buttons.scss _carousel.scss
    _close.scss _code.scss _component-animations.scss _dropdowns.scss _forms.scss _field-with-error.scss _glyphicons.scss
    _grid.scss _input-groups.scss _jumbotron.scss _labels.scss _list-group.scss _media.scss _mixins.scss
    _modals.scss _navbar.scss _navs.scss _normalize.scss _pager.scss _pagination.scss _panels.scss
    _popovers.scss _print.scss _progress-bars.scss _responsive-utilities.scss _scaffolding.scss
    _tables.scss _theme.scss _thumbnails.scss _tooltip.scss _type.scss _utilities.scss
    _variables.scss _wells.scss
  )) {
    link "$vendor/stylesheets/bootstrap/$_", "$base/sass/bootstrap/$_" or die "$_: $!";
  }
}

sub import {
  my $class = shift;
  my $caller = caller;

  strict->import;
  warnings->import;

  mkdir "t/public";
  mkdir "t/public/packed";

  if(-d $vendor) {
    $base = "blib/$base" if -d "blib";
    mkdir $base;
    plan skip_all => "Could not create $base: $!" unless -d $base;

    $class->copy_font unless -d "$base/font";
    $class->copy_javascript unless -d "$base/js/bootstrap";
    $class->copy_sass_bootstrap unless -d "$base/sass/bootstrap";
  }

  if(!-e "$base/sass/bootstrap.scss") {
    BAIL_OUT "$base/sass/bootstrap.scss is missing!";
  }

  eval qq[
    package $caller;
    use Test::More;
    use Test::Mojo;
    1;
  ] or die $@;
}

1;
