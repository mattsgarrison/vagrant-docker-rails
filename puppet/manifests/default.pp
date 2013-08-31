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

# ExecJS runtime. The old Node.js will suffice.
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

group { "docker":
  ensure => "present",
}

# Manage the vagrant user
user { "vagrant":
  ensure     => "present",
  managehome => true,
  shell => "/bin/zsh"
}

exec {"vagrant user docker membership":
  unless => "grep -q 'docker\\S*vagrant' /etc/group",
  command => "usermod -aG docker vagrant",
  require => User['vagrant'],
}

# --- Ruby ---------------------------------------------------------------------

# Install Ruby dependencies

package { ['bison', 'openssl', 'libreadline6','libreadline6-dev', 'git-core',
 'zlib1g', 'zlib1g-dev', 'libssl-dev', 'libyaml-dev', 'libxml2-dev', 'autoconf',
 'libxslt1-dev', 'libc6-dev', 'libncurses5-dev', 'automake', 'libtool']:
  ensure => installed
}

class { 'rbenv': }->rbenv::plugin { [ 'sstephenson/rbenv-vars', 'sstephenson/ruby-build' ]: }
rbenv::build { '2.0.0-p247': global => true }->
rbenv::gem { 'bundler': ruby_version => '2.0.0-p247' }->
rbenv::gem { 'pry': ruby_version => '2.0.0-p247' }

# Configure RBenv systemwide

exec {"rbenv_setup":
  command => "echo '# rbenv setup' > /etc/profile.d/rbenv.sh",
  require  => Class['rbenv']
}
exec {"rbenv_root":
  command => "echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh",
  require => Exec['rbenv_setup'],
}
exec {"rbenv_path":
  command => "echo 'export PATH=\"/usr/local/rbenv/bin:\$PATH\"' >> /etc/profile.d/rbenv.sh",
  require => Exec['rbenv_root'],
}
exec {"rbenv_init":
  command => "echo 'eval \"$(rbenv init -)\"' >> /etc/profile.d/rbenv.sh",
  require => Exec['rbenv_path'],
}
exec {"rbenv_make_exec":
  command => "chmod +x /etc/profile.d/rbenv.sh",
  require => Exec['rbenv_init'],
}
exec {"add_profile_to_zsh":
  command => "echo '. /etc/profile' >> /etc/zsh/zshrc",
  require => Exec['rbenv_make_exec'],
}
# exec {"rbenv_source_it":
#   command => "source /etc/profile.d/rbenv.sh",
#   require => Exec['rbenv_make_exec'],
# }

host { 'rails.dev':
    ip => '127.0.0.1',
}

