# == Class: ruby_build::resource::ruby
#
# Setup a ruby version managed by rbenv.
#
# === Parameters
#
# $ruby_name
#   The name of the version of ruby to install as defined by `rbenv install
#   --list`. Defaults to $title.
#
# === Variables
#
# === Examples
#
# ruby_build::resource::ruby { '1.9.3-p327': }
#
# === Authors
#
# Brendan O'Donnell <brendan.james.odonnell@gmail.com>
#
# === Copyright
#
# Copyright (C) 2012 Brendan O'Donnell
#
define ruby_build::resource::ruby(
  $ruby_name = $title
) {

  require build_essential
  require ruby_build

  $build_exe    = "${ruby_build::params::install_dir}/bin/ruby-build"
  $rbenv_exe    = "${rbenv::params::install_dir}/bin/rbenv"
  $ruby_prefix  = "${rbenv::params::install_dir}/versions/${ruby_name}"

  exec { "rbenv install ${ruby_name}":
    command     => "${build_exe} ${ruby_name} ${ruby_prefix}",
    creates     => "${ruby_prefix}/bin/ruby"
  }

  exec { "rbenv rehash ${ruby_name}":
    command     => "${rbenv_exe} rehash",
    environment => "RBENV_VERSION=${ruby_name}",
    refreshonly => true
  }

  File["${rbenv::params::install_dir}/versions"]
    -> Exec["rbenv install ${ruby_name}"]

  Exec["git clone ${ruby_build::params::repo_name}"]
    -> Exec["rbenv install ${ruby_name}"]

}
