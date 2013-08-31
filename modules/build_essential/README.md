# Puppet module for build-essential

Ubuntu package for build tools.

https://launchpad.net/ubuntu/+source/build-essential

## Basic Usage

To install build-essential

    class { 'build-essential': }

## Resources

To install a source package

    build_essential::resource::build_package { 'nginx':
      link          => 'http://nginx.org/download/nginx-1.2.5.tar.gz',
      name          => 'nginx',
      version       => '1.2.5',
      binary        => '/usr/local/nginx/sbin/nginx',
      deps          => ['libpcre3-dev'],
      packed_dir    => 'nginx-1.2.5',
    }

    build_essential::resource::build_package { 'mysql dev release':
      link          => 'http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.8-rc-linux2.6-x86_64.tar.gz/from/http://cdn.mysql.com/',
      name          => 'mysql',
      version       => '5.6.8',
      binary        => '/usr/local/mysql/bin/mysql',
      packed_dir    => 'mysql-5.6.8-rc-linux2.6-x86_64',
      build_command => 'useradd -r mysql && cp -r . /usr/local/mysql'
    }

## License

Copyright (C) 2012 Brendan O'Donnell

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
