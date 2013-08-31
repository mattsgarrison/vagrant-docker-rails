# == Class: build_essential::resource::build_package
#
# Install software from a source package.
#
# === Parameters
#
# $link
#   A link to the source package. Required.
# $name
#   The name of the software to install. Used to deduce $package and
#   $packed_dir. Required.
# $version
#   The version of the software to install. Used to deduce $package and
#   $packed_dir. Required.
# $binary
#   The full path to a binary that will be installed. Used to test for
#   previous installation. Required.
# $deps
#   An array of dependant packages. Defaults to [].
# $staging_dir
#   The full path to the directory to stage the original source packages.
#   Defaults to '/u/upstreams'.
# $package
#   The name of the local, original source package. The manifest will force
#   this so it doesn't have to match the remote filename. Defaults to
#   "${name}_${version}.orig.tar.gz".
# $packed_dir
#   The name of the first level directory in the source package. Defaults to
#   "${name}_${version}".
# $build_command
#   The command used to build the software. Defaults to 'configure && make
#   && make install'.
#
# === Variables
#
# === Examples
#
# build_essential::resource::build_package { 'nginx':
#   link          => 'http://nginx.org/download/nginx-1.2.5.tar.gz',
#   name          => 'nginx',
#   version       => '1.2.5',
#   binary        => '/usr/local/nginx/sbin/nginx',
#   deps          => ['libpcre3-dev'],
#   packed_dir    => 'nginx-1.2.5',
# }
#
# build_essential::resource::build_package { 'mysql':
#   link          => 'http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.8-rc-linux2.6-x86_64.tar.gz/from/http://cdn.mysql.com/',
#   name          => 'mysql',
#   version       => '5.6.8',
#   binary        => '/usr/local/mysql/bin/mysql',
#   packed_dir    => 'mysql-5.6.8-rc-linux2.6-x86_64',
#   build_command => 'useradd -r mysql && cp -r . /usr/local/mysql'
# }
#
# NOTE: some post-install steps have been left out of the mysql resource
#   shell> cd /usr/local/mysql
#   shell> chown -R mysql .
#   shell> chgrp -R mysql .
#   shell> scripts/mysql_install_db --user=mysql
#   shell> chown -R root .
#   shell> chown -R mysql data
#
# === Authors
#
# Brendan O'Donnell <brendan.james.odonnell@gmail.com>
#
# === Copyright
#
# Copyright (C) 2012 Brendan O'Donnell
#
define build_essential::resource::build_package(
  $link,
  $name,
  $version,
  $binary,
  $deps               = [],
  $staging_dir        = '/u/upstreams',
  $package            = "${name}_${version}.orig.tar.gz",
  $packed_dir         = "${name}_${version}",
  $build_command      = 'configure && make && make install'
) {

  require build_essential

  exec { "prepare ${name}":
    command   => "mkdir -p ${staging_dir}",
    creates   => $staging_dir,
  }

  Exec["prepare ${name}"] -> Exec["get ${name}"]

  exec { "get ${name}":
    cwd       => $staging_dir,
    command   => "wget -qO ${package} ${link}",
    timeout   => 0,
    creates   => "${staging_dir}/${package}"
  }

  package { $deps : }

  Exec["get ${name}"] -> Exec["unpack ${name}"]
  Package[$deps]      -> Exec["unpack ${name}"]

  exec { "unpack ${name}":
    cwd       => $staging_dir,
    command   => "tar xzf ${package}",
    creates   => "${staging_dir}/${packed_dir}"
  }

  Exec["unpack ${name}"] -> Exec["build ${name}"]

  exec { "build ${name}":
    cwd       => "${staging_dir}/${packed_dir}",
    command   => $build_command,
    creates   => $binary,
    path      => "${::path}:${staging_dir}/${packed_dir}"
  }

}
