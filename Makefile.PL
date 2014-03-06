use ExtUtils::MakeMaker;
WriteMakefile(
  NAME => 'Mojolicious::Plugin::Bootstrap',
  ABSTRACT_FROM => 'lib/Mojolicious/Plugin/Bootstrap.pm',
  VERSION_FROM => 'lib/Mojolicious/Plugin/Bootstrap.pm',
  AUTHOR => 'Jan Henning Thorsen <jhthorsen@cpan.org>',
  LICENSE => 'perl',
  PREREQ_PM => {
    'Mojolicious' => '4.30',
    'Mojolicious::Plugin::AssetPack' => '0.0601',
  },
  BUILD_REQUIRES => {
    'Test::More' => '0.90',
  },
  META_MERGE => {
    resources => {
      license => 'http://dev.perl.org/licenses/',
      homepage => 'https://metacpan.org/release/Mojolicious-Plugin-Bootstrap',
      bugtracker => 'https://github.com/jhthorsen/mojolicious-plugin-bootstrap/issues',
      repository => 'https://github.com/jhthorsen/mojolicious-plugin-bootstrap',
    },
  },
  test => {
    TESTS => 't/*.t',
  },
);
