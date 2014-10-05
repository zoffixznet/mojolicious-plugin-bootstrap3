package Mojolicious::Plugin::Bootstrap3;

=head1 NAME

Mojolicious::Plugin::Bootstrap3 - Mojolicious + http://getbootstrap.com/

=head1 VERSION

3.2001

=head1 DESCRIPTION

L<Mojolicious::Plugin::Bootstrap3> is used to include L<http://getbootstrap.com/>
CSS and JavaScript files into your project.

This is done with the help of L<Mojolicious::Plugin::AssetPack> and
L<sass|http://sass-lang.com/>. Sass is required to do
L<modifications|/register> to the css pack.

=head1 SYNOPSIS

=head2 Mojolicious::Lite

  use Mojolicious::Lite;
  plugin "bootstrap3";
  get "/" => "index";
  app->start;

=head2 Mojolicious

  sub startup {
    my $self = shift;

    $self->plugin("bootstrap3");
  }

=head2 Template

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

TIP! You might want to load L<Mojolicious::Plugin::AssetPack> yourself to specify
options.

=head1 STATIC FILE STRUCTURE

You can replace any of these static files in your own project.

L<public/sass/bootstrap.scss|https://github.com/twbs/bootstrap-sass/blob/master/vendor/assets/stylesheets/bootstrap.scss>
and
L<public/sass/bootstrap/_variables.scss|https://github.com/twbs/bootstrap-sass/blob/master/vendor/assets/stylesheets/bootstrap/_variables.scss>
are probably the files that you want to replace, to make the generated
bootstrap file smaller and more personal.

  font/glyphicons-halflings-regular.eot
  font/glyphicons-halflings-regular.svg
  font/glyphicons-halflings-regular.ttf
  font/glyphicons-halflings-regular.woff
  js/bootstrap/affix.js
  js/bootstrap/alert.js
  js/bootstrap/button.js
  js/bootstrap/carousel.js
  js/bootstrap/collapse.js
  js/bootstrap/dropdown.js
  js/bootstrap/modal.js
  js/bootstrap/popover.js
  js/bootstrap/scrollspy.js
  js/bootstrap/tab.js
  js/bootstrap/tooltip.js
  js/bootstrap/transition.js
  js/jquery-1.11.0.min.js
  sass/bootstrap.scss
  sass/bootstrap/_alerts.scss
  sass/bootstrap/_badges.scss
  sass/bootstrap/_breadcrumbs.scss
  sass/bootstrap/_button-groups.scss
  sass/bootstrap/_buttons.scss
  sass/bootstrap/_carousel.scss
  sass/bootstrap/_close.scss
  sass/bootstrap/_code.scss
  sass/bootstrap/_component-animations.scss
  sass/bootstrap/_dropdowns.scss
  sass/bootstrap/_field-with-error.scss
  sass/bootstrap/_forms.scss
  sass/bootstrap/_glyphicons.scss
  sass/bootstrap/_grid.scss
  sass/bootstrap/_input-groups.scss
  sass/bootstrap/_jumbotron.scss
  sass/bootstrap/_labels.scss
  sass/bootstrap/_list-group.scss
  sass/bootstrap/_media.scss
  sass/bootstrap/_mixins.scss
  sass/bootstrap/_modals.scss
  sass/bootstrap/_navbar.scss
  sass/bootstrap/_navs.scss
  sass/bootstrap/_normalize.scss
  sass/bootstrap/_pager.scss
  sass/bootstrap/_pagination.scss
  sass/bootstrap/_panels.scss
  sass/bootstrap/_popovers.scss
  sass/bootstrap/_print.scss
  sass/bootstrap/_progress-bars.scss
  sass/bootstrap/_responsive-utilities.scss
  sass/bootstrap/_scaffolding.scss
  sass/bootstrap/_tables.scss
  sass/bootstrap/_theme.scss
  sass/bootstrap/_thumbnails.scss
  sass/bootstrap/_tooltip.scss
  sass/bootstrap/_type.scss
  sass/bootstrap/_utilities.scss
  sass/bootstrap/_variables.scss
  sass/bootstrap/_wells.scss

=head2 Non-standard files

Some of the L<static files|/STATIC FILE STRUCTURE> are not bundled with the
original Bootstrap distribution.

=over 4

=item * js/jquery-1.11.0.min.js

The jQuery bundled with this distribution will always be compatible with
the Bootstrap javascript files. It might change minor version, but it is
very unlikely that it will change much. Exceptions from this rule is if
the Bootstrap javascripts should require a newer version to function
properly.

=item * sass/bootstrap/_field-with-error.scss

This SASS file need to be included manually. It is used to style
L<.field-with-error|Mojolicious::Plugin::TagHelpers/DESCRIPTION>
tags, the same way as L<.has-error|http://getbootstrap.com/css/#forms-control-validation>.

Example of markup that will be styled on
L<invalid input|Mojolicious::Controller/validation>:

  <div class="form-group">
    %= label_for "username", "Username", class => "col-sm-2 control-label"
    <div class="col-sm-4">
      %= text_field "username", class => "form-control"
    </div>
  </div>

This is EXPERIMENTAL and subject to change.

=back

=cut

use Mojo::Base 'Mojolicious::Plugin';
use File::Spec::Functions 'catdir';
use Cwd ();

our $VERSION = '3.2001';

=head1 METHODS

=head2 asset_path

  $path = Mojolicious::Plugin::Bootstrap3->asset_path($type);
  $path = $self->asset_path($type);

Returns the base path to the assets bundled with this module.

Set C<$type> to "sass" if you want a return value that is suitable for
the C<SASS_PATH> environment variable.

=cut

sub asset_path {
  my($class, $type) = @_;
  my $path = Cwd::abs_path(__FILE__);

  $path =~ s!\.pm$!!;

  return join ':', grep { $_ } catdir($path, 'sass'), $ENV{SASS_PATH} if $type and $type eq 'sass';
  return $path;
}

=head2 register

  $app->plugin(
    bootstrap3 => {
      css => [qw( bootstrap.scss )],
      js => [qw( button.js collapse.js ... )],
      jquery => $bool, # default true
    },
  );

Default values:

=over 4

=item * css

C<bootstrap.scss>.

The name of the files to include in the asset named C<bootstrap.css>.

Specify an empty list to disable building C<bootstrap.css>.

=item * js

C<affix.js>, C<alert.js>, C<button.js>, C<carousel.js>, C<collapse.js>,
C<dropdown.js>, C<modal.js>, C<popover.js>, C<scrollspy.js>, C<tab.js>,
C<tooltip.js> and C<transition.js>.

The name of the files to include in the asset named C<bootstrap.js>.

Specify an empty list to disable building C<bootstrap.css>.

NOTE! This list might change, but will include all the javascripts available
in the current version.

=item * jquery

This will include the bundled L<jQuery|http://jquery.com/> version in the
L<bootstrap.js> asset. Set this to 0 if you include your own jQuery.

=back

=cut

sub register {
  my($self, $app, $config) = @_;

  $app->plugin('AssetPack') unless eval { $app->asset };

  $config->{css} ||= [qw( bootstrap.scss )];
  $config->{js} ||= [qw( transition.js alert.js button.js carousel.js collapse.js dropdown.js modal.js tooltip.js popover.js scrollspy.js tab.js affix.js )];
  $config->{jquery} //= 1;

  push @{ $app->static->paths }, $self->asset_path;

  # TODO: 'bootstrap_resources.scss'
  if(@{ $config->{css} }) {
    local $ENV{SASS_PATH} = $self->asset_path('sass');
    $app->asset('bootstrap.css' => map { "/sass/$_" } @{ $config->{css} });
  }

  if(@{ $config->{js} }) {
    $app->asset('bootstrap.js' =>
      $config->{jquery} ? ('/js/jquery-1.11.0.min.js') : (),
      map { "/js/bootstrap/$_" } @{ $config->{js} },
    );
  }
}

=head1 CREDITS

L<bootstrap-sass|https://github.com/twbs/bootstrap-sass> has a number of major
contributors:

  Thomas McDonald
  Tristan Harward
  Peter Gumeson
  Gleb Mazovetskiy

and a L<significant number of other contributors|https://github.com/twbs/bootstrap-sass/graphs/contributors>

=head1 LICENSE

Bootstrap is licensed under L<MIT|https://github.com/twbs/bootstrap/blob/master/LICENSE>

Mojolicious is licensed under Artistic License version 2.0 and so is this code.

=head1 AUTHOR

Jan Henning Thorsen - C<jhthorsen@cpan.org>

=cut

1;
