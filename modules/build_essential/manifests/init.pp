# == Class: build-essential
#
# Install build-essentail.
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { 'build-essential':  }
#
# === Authors
#
# Brendan O'Donnell <brendan.james.odonnell@gmail.com>
#
# === Copyright
#
# Copyright (C) 2012 Brendan O'Donnell
#
class build_essential {

  package { 'build-essential': }

}
