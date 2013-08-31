# == Class: ruby_build::params
#
class ruby_build::params {

  $repo_path       = 'git://github.com/sstephenson/ruby-build.git'
  $repo_name       = 'ruby-build'
  $install_prefix  = '/usr/local/rbenv/plugins'
  $install_dir     = "${install_prefix}/${repo_name}"

}
