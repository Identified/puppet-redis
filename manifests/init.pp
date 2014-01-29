# == Class: redis
#
# Install redis.
#
# === Parameters
#
# [*version*]
#   Version to install.
#   Default: 2.6.13
#
# [*redis_src_dir*]
#   Location to unpack source code before building and installing it.
#   Default: /opt/redis-src
#
# [*redis_bin_dir*]
#   Location to install redis binaries.
#   Default: /opt/redis
#
# === Examples
#
# include redis
#
# class { 'redis':
#   version       => '2.6.13',
#   redis_src_dir => '/fake/path/redis-src',
#   redis_bin_dir => '/fake/path/redis',
# }
#
# === Authors
#
# Identified, Inc.
# Thomas Van Doren
#
# === Copyright
#
# Copyright 2013 Identified, Inc.
# Copyright 2012 Thomas Van Doren, unless otherwise noted.
#
class redis (
  $version = $redis::params::version,
  $src_dir = $redis::params::src_dir,
  $bin_dir = $redis::params::bin_dir
) inherits redis::params {

  include redis::dependencies

  $pkg_name = "redis-${version}.tar.gz"
  $pkg = "${src_dir}/${pkg_name}"

  File {
    owner => root,
    group => root,
  }

  file { $src_dir:
    ensure => directory,
  }

  file { '/etc/redis':
    ensure => directory,
  }

  file { 'redis-lib':
    ensure => directory,
    path   => '/var/lib/redis',
  }

  exec { 'get-redis-pkg':
    command => "rm -rf ${src_dir} && mkdir ${src_dir} && /usr/bin/wget --output-document ${pkg} http://download.redis.io/releases/${pkg_name}",
    unless  => "/usr/bin/test -f ${pkg}",
    require => [Package['wget'], File[$src_dir]],
  }

  exec { 'unpack-redis':
    command => "tar --strip-components 1 -xzf ${pkg}",
    cwd     => $src_dir,
    path    => '/bin:/usr/bin',
    unless  => "test -f ${src_dir}/Makefile  && /usr/bin/test $(cat ${src_dir}/src/version.h | cut -d ' ' -f 3 | cut -d '\"' -f 2) = '${version}'",
    require => Exec['get-redis-pkg'],
  }

  exec { 'install-redis':
    command => "make && make install PREFIX=${bin_dir}",
    cwd     => $src_dir,
    path    => '/bin:/usr/bin',
    unless  => "test $(${bin_dir}/bin/redis-server --version | cut -d ' ' -f 3) = 'v=${version}'",
    require => [Package['build-essential'], Exec['unpack-redis']],
  }

  exec { 'redis update-alternative':
    command => "sudo update-alternatives --install /usr/bin/redis-server redis-server ${bin_dir}/bin/redis-server 1 \
                                         --slave   /usr/bin/redis-cli    redis-cli    ${bin_dir}/bin/redis-cli",
    unless => "/bin/sh -c '[ -L /etc/alternatives/redis-server ] && [ /etc/alternatives/redis-server -ef ${bin_dir}/bin/redis-server ] && [ -L /etc/alternatives/redis-cli ] && [ /etc/alternatives/redis-cli -ef ${bin_dir}/bin/redis-cli ]'",
    cwd     => '/home',
    require => Exec['install-redis'],
  }

}
