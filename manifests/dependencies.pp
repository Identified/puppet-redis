# == Class: redis::dependencies
#
# Installs dependencies required to install redis
#
# === Authors
#
# Identified, Inc.
#
# === Copyright
#
# Copyright 2013 Identified, Inc.
#
class redis::dependencies {
  if ! defined(Package['build-essential'])  {
    package { 'build-essential': ensure => installed }
  }

  if ! defined(Package['wget']) {
    package { 'wget': ensure => installed }
  }
}
