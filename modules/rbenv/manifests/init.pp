# == Class: rbenv
#
# Install rbenv.
#
# === Parameters
#
# $rbenv::params::repo_path
#   The repository to clone from
#   Defaults to 'git://github.com/sstephenson/rbenv.git'
# $rbenv::params::repo_name
#   The name of the new local directory to clone into
#   Defaults to 'rbenv'
# $rbenv::params::install_prefix
#   The name of the existing parent directory to clone into
#   Defaults to '/usr/local'
# $rbenv::params::install_dir
#   The full path to the newly created directory
#   Defaults to $install_prefix/$repo_name
#
# === Variables
#
# === Examples
#
#  class { 'rbenv':  }
#
# === Authors
#
# Brendan O'Donnell <brendan.james.odonnell@gmail.com>
#
# === Copyright
#
# Copyright (C) 2012 Brendan O'Donnell
#
class rbenv {

  include rbenv::params

  require git

  exec { "git clone ${rbenv::params::repo_name}":
    cwd       => $rbenv::params::install_prefix,
    command   => "git clone \
                  ${rbenv::params::repo_path} \
                  ${rbenv::params::repo_name}",
    creates   => $rbenv::params::install_dir
  }

  file { [
    $rbenv::params::install_dir,
    "${rbenv::params::install_dir}/plugins",
    "${rbenv::params::install_dir}/shims",
    "${rbenv::params::install_dir}/versions"
  ]:
    ensure    => directory,
    owner     => 'root',
    group     => 'admin',
    mode      => '0775',
  }

  file { '/etc/profile.d/rbenv.sh':
    ensure    => file,
    content   => template('rbenv/rbenv.sh'),
    mode      => '0775'
  }

  Exec["git clone ${rbenv::params::repo_name}"] -> File['/usr/local/rbenv']

}
