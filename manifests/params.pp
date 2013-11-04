# == Class: redis::params
#
# Redis params.
#
# === Authors
#
# Identified, Inc.
# Thomas Van Doren
#
# === Copyright
# Copyright 2013 Identified, Inc.
# Copyright 2012 Thomas Van Doren, unless otherwise noted.
#
class redis::params {
  $version = '2.6.16'
  $src_dir = '/opt/redis-src'
  $bin_dir = '/opt/redis'
}
