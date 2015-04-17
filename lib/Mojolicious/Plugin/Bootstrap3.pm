package Mojolicious::Plugin::Bootstrap3;

=head1 NAME

Mojolicious::Plugin::Bootstrap3 - Mojolicious + http://getbootstrap.com/

=head1 VERSION

3.3006

=head1 DESCRIPTION

L<Mojolicious::Plugin::Bootstrap3> is used to include L<http://getbootstrap.com/>
CSS and JavaScript files into your project.

This is done with the help of L<Mojolicious::Plugin::AssetPack> and
L<Sass|http://sass-lang.com/>.

See L<Mojolicious::Plugin::AssetPack::Preprocessor::Sass/DESCRIPTION> on how to
intall Sass.

=head1 SYNOPSIS

=head2 Mojolicious application

  use Mojolicious::Lite;
  plugin "bootstrap3";
  get "/" => "index";
  app->start;

This basic application will make the C<bootstrap.css> and C<bootstrap.js>
assets available, which you can load in your L<template|/Mojolicious template>.

Note: If this is all you're going to do, you can rather use
L<AssetPack|Mojolicious::Plugin::AssetPack> directly:

  use Mojolicious::Lite;
  plugin "AssetPack";
  app->asset("bootstrap.css" => "http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css");
  app->asset("bootstrap.js" => "http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js");

=head2 Mojolicious template

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

=head2 Custom stylesheet

The reason for using this plugin is that it's very easy to customize Bootstrap,
and make a smaller package for the user to download.

  use Mojolicious::Lite;
  plugin "bootstrap3", {custom => 1};
  get "/" => "index";
  app->start;

Setting C<custom> to a true value will copy C<bootstrap.scss> to your
C<public/sass> directory. You can then edit the file and remove the parts
you don't need.

=head2 Custom javascript

Custom list of which javascript to include can be done directly in the
configuration:

  plugin "bootstrap3", jquery => 0, js => [qw( transition.js tooltip.js )];

The config above will I<not> include jQuery, and only include "transition.js"
and "tooltip.js" in the output C<bootstrap.js> bundle. Complete list of
possible javascripts can be found under L</STATIC FILE STRUCTURE>.

=head2 Themes

It is very simple to use a custom
L<_variables.scss|https://github.com/twbs/bootstrap-sass/blob/master/assets/stylesheets/bootstrap/_variables.scss>
file with your project. This file contains the variables controlling colors,
fonts and styling rules in general.

Example:

  # application code
  $app->plugin(bootstrap3 => (
    theme => {xyz => "http://example.com/_variables.scss"}
  ));

  # template code
  %= asset "xyz.css"
  %= asset "bootstrap.js"

There is also built in support for themes from L<https://bootswatch.com>. To
use one of the themes from bootswatch, simply specify the URL to the
C<_bootswatch.scss> file instead of C<_variables.scss>:

  # application code
  $app->plugin(bootstrap3 => (
    theme => {paper => "https://bootswatch.com/paper/_bootswatch.scss"}
  ));

  # template code
  %= asset "paper.css"
  %= asset "bootstrap.js"

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
use Mojo::Util ();
use File::Basename 'dirname';
use File::Copy ();
use File::Path ();
use File::Spec ();
use Cwd        ();
use constant DEBUG => $ENV{MOJO_ASSETPACK_DEBUG} || 0;

our $VERSION = '3.3006';
our $OVERRIDE;    # ugly hack. might go away

$ENV{SASS_PATH} ||= '';

my $ASSET_DIR = do { local $_ = Cwd::abs_path(__FILE__); s!\.pm$!!; $_; };

my @DEFAULT_CSS_FILES = qw( bootstrap.scss );
my @DEFAULT_JS_FILES
  = qw( transition.js alert.js button.js carousel.js collapse.js dropdown.js modal.js tooltip.js popover.js scrollspy.js tab.js affix.js );

=head1 METHODS

=head2 asset_path

  $path = Mojolicious::Plugin::Bootstrap3->asset_path($type);
  $path = $self->asset_path($type);

Returns the base path to the assets bundled with this module.

Set C<$type> to "sass" if you want a return value that is suitable for
the C<SASS_PATH> environment variable.

=cut

sub asset_path {
  my ($self, $type) = @_;
  my @path = ref $self ? @{$self->{sass_path}} : ();
  my %PATH;

  return join ':', grep { -d $_ and !$PATH{$_}++ } split(/:/, $ENV{SASS_PATH}), @path,
    File::Spec->catdir($ASSET_DIR, 'sass')
    if $type and $type eq 'sass';
  return $ASSET_DIR;
}

=head2 register

  $app->plugin(
    bootstrap3 => {
      css    => [qw( bootstrap.scss )],
      js     => [qw( button.js collapse.js ... )],
      custom => 0,
      jquery => 1,
      theme  => undef,
    },
  );

Default values:

=over 4

=item * css: C<bootstrap.scss>

The name of the files to include in the asset named C<bootstrap.css>.

Specify an empty list to disable building C<bootstrap.css>.

=item * js

C<affix.js>, C<alert.js>, C<button.js>, C<carousel.js>, C<collapse.js>,
C<dropdown.js>, C<modal.js>, C<popover.js>, C<scrollspy.js>, C<tab.js>,
C<tooltip.js> and C<transition.js>.

The name of the files to include in the asset named C<bootstrap.js>.

Specify an empty list to disable building C<bootstrap.css>.

=item * custom

Disabled by default. Will copy C<sass/bootstrap.scss> to your project if
true and set C<SASS_PATH> to the appropriate paths.

=item * jquery

This will include the bundled L<jQuery|http://jquery.com/> version in the
L<bootstrap.js> asset. Set this to 0 if you include your own jQuery.

=item * theme

Specifying a theme will override L</custom> and L</css>.

See L</Themes>.

=back

=cut

sub register {
  my ($self, $app, $config) = @_;

  $app->plugin('AssetPack') unless eval { $app->asset };

  $self->{sass_path} = [];
  $config->{css} ||= [@DEFAULT_CSS_FILES];
  $config->{js}  ||= [@DEFAULT_JS_FILES];
  $config->{custom} = 0 if $config->{theme};
  $config->{jquery} //= 1;

  push @{$app->static->paths}, $self->asset_path;

  if ($config->{custom}) {
    $self->_copy_files($app,
      map { [$_, $_] } ref $config->{custom} eq 'ARRAY' ? @{$config->{custom}} : @DEFAULT_CSS_FILES);
  }

  if ($config->{theme}) {
    $self->_generate_theme($app, $config->{theme});
  }
  elsif (@{$config->{css}}) {
    $ENV{SASS_PATH} = $self->asset_path('sass');
    warn "[BOOTSTRAP] Defining asset 'bootstrap.css' SASS_PATH=$ENV{SASS_PATH}\n" if DEBUG;
    $app->asset('bootstrap.css' => map {"/sass/$_"} @{$config->{css}});
  }

  if (@{$config->{js}}) {
    $app->asset(
      'bootstrap.js' => $config->{jquery} ? ('/js/jquery-1.11.0.min.js') : (),
      map {"/js/bootstrap/$_"} @{$config->{js}},
    );
  }
}

sub _copy_files {
  my $modifier = ref $_[-1] eq 'CODE' ? pop : sub { };
  my ($self, $app, @files) = @_;

  for (@files) {
    my ($from, $to) = @$_;
    my $source = File::Spec->catfile($ASSET_DIR, 'sass', split '/', $from);
    my $destination = $self->_destination_file($app, $to) or next;
    File::Path::make_path(dirname $destination) unless -d dirname($destination);
    $app->log->info("[BOOTSTRAP] Copying $source to $destination");
    local $_ = Mojo::Util::slurp($source);
    $modifier->();
    Mojo::Util::spurt($_, $destination);
  }
}

sub _destination_file {
  my ($self, $app, $name) = @_;
  my $static = $app->static;

  for my $path (@{$static->paths}) {
    my $destination_dir = File::Spec->catdir($path, 'sass');
    my $destination = File::Spec->catfile($destination_dir, split '/', $name);
    push @{$self->{sass_path}}, $destination_dir;
    return ''                                   if -e $destination;               # already exists
    warn "[BOOTSTRAP] Can write $destination\n" if DEBUG;
    return $destination                         if -w dirname $destination_dir;
  }

  # should never come to this, because of
  # push @{$app->static->paths}, $self->asset_path;
  $app->log->warn("Custom file $name does not exist in static directories!");
  return '';
}

sub _generate_theme {
  my ($self, $app, $theme) = @_;

  for my $name (keys %$theme) {
    my $url = $theme->{$name};

    warn "[BOOTSTRAP] Defining theme '$name' from $url\n" if DEBUG;

    if ($url =~ m!/_bootswatch\.scss!) {
      my $destination = $self->_destination_file($app, "$name/_bootswatch.scss");
      $self->_move($app->asset->fetch($url), $destination) if $destination and !-e $destination;
      $url =~ s!/_bootswatch\.scss!/_variables.scss!;
      local $OVERRIDE = 'bootswatch';
      $self->_generate_theme($app, {$name => $url});
    }
    else {
      my $destination = $self->_destination_file($app, "$name/_variables.scss");
      if ($destination and !-e $destination) {
        $self->_copy_files(
          $app,
          ["bootstrap.scss" => "$name.scss"],
          sub {
            s!(\@import.*bootstrap/variables.*)!\@import "$name/variables";\n$1!m;
            s!(//.*\bUtility\b.*)!$1\n\@import "$name/$OVERRIDE";\n!mi if $OVERRIDE;
          }
        );
        $self->_move($app->asset->fetch($url), $destination);
      }
      $ENV{SASS_PATH} = $self->asset_path('sass');
      warn "[BOOTSTRAP] Defining asset '$name.css' SASS_PATH=$ENV{SASS_PATH}\n" if DEBUG;
      $app->asset("$name.css" => "/sass/$name.scss");
    }
  }
}

sub _move {
  my ($self, $from, $to) = @_;
  File::Path::make_path(dirname $to);
  File::Copy::move($from, $to) or die "[BOOTSTRAP] move $from $to: $!";
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
