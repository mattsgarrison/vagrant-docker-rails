# == Class: ruby_build::resource::gem
#
# Setup a gem with a ruby version managed by rbenv.
#
# === Parameters
#
# $gem_name
#   The name of the gem to install. Defaults to $title.
# $gem_version
#   The version of the gem to install. Defaults to not specified.
# $ruby_version
#   The ruby version used to install the gem.
#
# === Variables
#
# === Examples
#
# ruby_build::resource::gem  { 'bundler':
#   ruby_name => '1.9.3-p327'
# }
#
# === Authors
#
# Brendan O'Donnell <brendan.james.odonnell@gmail.com>
#
# === Copyright
#
# Copyright (C) 2012 Brendan O'Donnell
#
define ruby_build::resource::gem(
  $ruby_name,
  $gem_name     = $title,
  $gem_version  = ''
) {

  require ruby_build

  $gem_exe = "${rbenv::params::install_dir}/versions/${ruby_name}/bin/gem"

  if $gem_version == '' {
    exec { "rbenv install ${ruby_name} ${gem_name}":
      command     => "${gem_exe} install ${gem_name} \
                      --no-ri --no-rdoc",
      unless      => "${gem_exe} list | grep ${gem_name}",
      environment => "RBENV_VERSION=${ruby_name}"
    }
  }
  else
  {
    exec { "rbenv install ${ruby_name} ${gem_name}":
      command     => "${gem_exe} install ${gem_name} \
                      --version ${gem_version} \
                      --no-ri --no-rdoc",
      unless      => "${gem_exe} list | grep '${gem_name} (${gem_version})'",
      environment => "RBENV_VERSION=${ruby_name}"
    }
  }

  Exec["rbenv install ${ruby_name}"]
    -> Exec["rbenv install ${ruby_name} ${gem_name}"]
    ~> Exec["rbenv rehash ${ruby_name}"]

}
