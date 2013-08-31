$ar_databases = ['activerecord_unittest', 'activerecord_unittest2']
$as_vagrant   = 'sudo -u vagrant -H bash -l -c'
$home         = '/home/vagrant'

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Preinstall Stage ---------------------------------------------------------

stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {

  exec { "update_apt-get":
      command => "apt-get -y update"
  }

  package { 'apt-transport-https':
    ensure => installed,
    require => Exec['update_apt-get']
  }

  package { 'curl':
    ensure => latest
  }

  exec { 'install_aufs':
    command => "apt-get -y install linux-image-extra-`uname -r`",
    require => Package['apt-transport-https']
  }

  exec { 'install_docker_repo_key':
    command => "sh -c 'curl http://get.docker.io/gpg | apt-key add -'",
    require => Exec['install_aufs']
  }

  exec { 'install_docker_repo':
    command => "sh -c 'echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list'",
    require => Exec['install_docker_repo_key']
  }

  exec { 'apt-get -y update':
    #unless => "test -e ${home}/.rvm",
    require => Exec['install_docker_repo']
  }
}
class { 'apt_get_update':
  stage => preinstall
}

# --- Docker -------------------------------------------------------------------





package { 'lxc-docker':
  ensure => installed
}
# exec { 'install_docker':
#   command => "apt-get update; apt-get install lxc-docker",
#   require => Exec['install_docker_repo']
# }


# --- SQLite -------------------------------------------------------------------

package { ['sqlite3', 'libsqlite3-dev']:
  ensure => installed;
}

# --- PostgreSQL ---------------------------------------------------------------

# class install_postgres {
#   class { 'postgresql': }

#   class { 'postgresql::server': }

#   pg_database { $ar_databases:
#     ensure   => present,
#     encoding => 'UTF8',
#     require  => Class['postgresql::server']
#   }

#   pg_user { 'rails':
#     ensure  => present,
#     require => Class['postgresql::server']
#   }

#   pg_user { 'vagrant':
#     ensure    => present,
#     superuser => true,
#     require   => Class['postgresql::server']
#   }

#   package { 'libpq-dev':
#     ensure => installed
#   }

#   package { 'postgresql-contrib':
#     ensure  => installed,
#     require => Class['postgresql::server'],
#   }
# }
# class { 'install_postgres': }

# --- Memcached ----------------------------------------------------------------

class { 'memcached': }

# --- Packages -----------------------------------------------------------------

package { 'build-essential':
  ensure => installed
}

package { 'git-core':
  ensure => installed
}

# Nokogiri dependencies.
package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
}

# ExecJS runtime.
package { 'nodejs':
  ensure => installed
}

# Install zsh
package { 'zsh':
  ensure => installed
}

# Install byobu
package { 'byobu':
  ensure => installed
}

# Install zsh
package { 'vim':
  ensure => installed
}

# --- Ruby ---------------------------------------------------------------------

# exec { 'install_rvm':
#   command => "${as_vagrant} 'curl -L https://get.rvm.io | bash -s stable'",
#   creates => "${home}/.rvm/bin/rvm",
#   require => Package['curl']
# }

# exec { 'install_ruby':
#   # We run the rvm executable directly because the shell function assumes an
#   # interactive environment, in particular to display messages or ask questions.
#   # The rvm executable is more suitable for automated installs.
#   #
#   # Thanks to @mpapis for this tip.
#   command => "${as_vagrant} '${home}/.rvm/bin/rvm install 2.0.0 --latest-binary --autolibs=enabled && rvm --fuzzy alias create default 2.0.0'",
#   creates => "${home}/.rvm/bin/ruby",
#   require => Exec['install_rvm']
# }

# exec { "${as_vagrant} 'gem install bundler --no-rdoc --no-ri'":
#   creates => "${home}/.rvm/bin/bundle",
#   require => Exec['install_ruby']
# }

host { 'rails.dev':
    ip => '127.0.0.1',
}

user { "vagrant":
  ensure     => "present",
  managehome => true,
  shell => "/bin/zsh"
}

group { "logusers":
    ensure => "present",
}