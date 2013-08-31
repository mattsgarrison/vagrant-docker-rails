# == Class: ruby_build
#
# Install ruby-build and setup resources to manage ruby and gem versions.
#
# === Parameters
#
# === Variables
#
# $rbenv::params::repo_path
#   The repository to clone from
#   Defaults to 'git://github.com/sstephenson/ruby-build.git'
# $rbenv::params::repo_name
#   The name of the new local directory to clone into
#   Defaults to 'ruby-build'
# $rbenv::params::install_prefix
#   The name of the existing parent directory to clone into
#   Defaults to '/usr/local/rbenv/plugins'
# $rbenv::params::install_dir
#   The full path to the newly created directory
#   Defaults to $install_prefix/$repo_name
#
# === Examples
#
#  class { 'ruby_build': }
#
# === Authors
#
# Brendan O'Donnell <brendan.james.odonnell@gmail.com>
#
# === Copyright
#
# Copyright (C) 2012 Brendan O'Donnell
#
class ruby_build {

  include ruby_build::params

  require git
  require rbenv

  exec { "git clone ${ruby_build::params::repo_name}":
    cwd       => $ruby_build::params::install_prefix,
    command   => "git clone \
                  ${ruby_build::params::repo_path} \
                  ${ruby_build::params::repo_name}",
    creates   => $ruby_build::params::install_dir
  }

}
