use Mojo::Base -base;
use Mojolicious::Lite;
use Test::Mojo;
use Test::More;

# Test that the assets can be fetched like normal files

plugin 'bootstrap3';

my $t = Test::Mojo->new;

for my $file (
  qw(
  /font/glyphicons-halflings-regular.eot
  /font/glyphicons-halflings-regular.svg
  /font/glyphicons-halflings-regular.ttf
  /font/glyphicons-halflings-regular.woff
  /js/bootstrap/affix.js
  /js/bootstrap/alert.js
  /js/bootstrap/button.js
  /js/bootstrap/carousel.js
  /js/bootstrap/collapse.js
  /js/bootstrap/dropdown.js
  /js/bootstrap/modal.js
  /js/bootstrap/popover.js
  /js/bootstrap/scrollspy.js
  /js/bootstrap/tab.js
  /js/bootstrap/tooltip.js
  /js/bootstrap/transition.js
  /js/jquery-1.11.0.min.js
  /sass/bootstrap.scss
  /sass/bootstrap/_alerts.scss
  /sass/bootstrap/_badges.scss
  /sass/bootstrap/_breadcrumbs.scss
  /sass/bootstrap/_button-groups.scss
  /sass/bootstrap/_buttons.scss
  /sass/bootstrap/_carousel.scss
  /sass/bootstrap/_close.scss
  /sass/bootstrap/_code.scss
  /sass/bootstrap/_component-animations.scss
  /sass/bootstrap/_dropdowns.scss
  /sass/bootstrap/_forms.scss
  /sass/bootstrap/_field-with-error.scss
  /sass/bootstrap/_glyphicons.scss
  /sass/bootstrap/_grid.scss
  /sass/bootstrap/_input-groups.scss
  /sass/bootstrap/_jumbotron.scss
  /sass/bootstrap/_labels.scss
  /sass/bootstrap/_list-group.scss
  /sass/bootstrap/_media.scss
  /sass/bootstrap/_mixins.scss
  /sass/bootstrap/_modals.scss
  /sass/bootstrap/_navbar.scss
  /sass/bootstrap/_navs.scss
  /sass/bootstrap/_normalize.scss
  /sass/bootstrap/_pager.scss
  /sass/bootstrap/_pagination.scss
  /sass/bootstrap/_panels.scss
  /sass/bootstrap/_popovers.scss
  /sass/bootstrap/_print.scss
  /sass/bootstrap/_progress-bars.scss
  /sass/bootstrap/_responsive-utilities.scss
  /sass/bootstrap/_scaffolding.scss
  /sass/bootstrap/_tables.scss
  /sass/bootstrap/_theme.scss
  /sass/bootstrap/_thumbnails.scss
  /sass/bootstrap/_tooltip.scss
  /sass/bootstrap/_type.scss
  /sass/bootstrap/_utilities.scss
  /sass/bootstrap/_variables.scss
  /sass/bootstrap/_wells.scss
  )
  )
{
  $t->get_ok($file)->status_is(200);
}

done_testing;
