# == Define: redis::instance
#
# Configure redis instance on an arbitrary port.
#
# === Parameters
# [*appendfsync*]
#   Sets the fsync policy, either `no`, `everysec`, or `always`
#   Default: everysec
#
# [*appendonly*]
#   Set AOF Persistence
#   Default: false
#
# [*port*]
#   Accept redis connections on this port.
#   Default: 6379
#
# [*bind_address*]
#   Address to bind to.
#   Default: false, which binds to all interfaces
#
# [*loglevel*]
#   Set the redis config value loglevel. Valid values are debug,
#   verbose, notice, and warning.
#   Default: notice
#
# [*max_clients*]
#   Set the redis config value maxclients. If false, it is
#   not included in the configuration
#   Default: false
#
# [*maxmemory*]
#   Sets the max memory for redis to utilize.
#
# [*maxmemory_policy*]
#   Set what keys to remove when redis reaches capacity
#   'volatile-lru' removes the key with an expire set using an LRU algorithm
#   'allkeys-lru' remove any key accordingly to the LRU algorithm
#   'volatile-random' removes a random key with an expire set
#   'allkeys-random' removes a random key, any key
#   'volatile-ttl' removes the key with the nearest expire time (minor TTL)
#   'noeviction' set no expiration at all, just return an error on writes
#   default: 'volatile-lru'
#
# [*password*]
#   Password used by AUTH command. If false, not used.
#   Default: false
#
# [*port*]
#   Set the port that redis will listen on
#   Default: 6379
#
#
# [*rdb_saves*]
#   An array of size 2 tuples indicating criteria for an rdb snapshot
#   Index 0 is <seconds>, Index 1 is <changes>
#   An rdb snapshot is triggered if both conditions pass for at least one
#   of these pairs
#   E.g. The default will trigger a snapshot when:
#   900 seconds has passed with at least 1 change, OR
#   300 seconds has passed with at least 10 changes, OR
#   60 seconds has passed with at least 10000 changes
#   Default: [ [900, 1], [300, 10], [60, 10000] ]
#
# [*timeout*]
#   Set the redis config value timeout (seconds).
#   Default: 300
#
# [*slave_read_only*]
#   Make slaves read-only
#   Default: true
#
# [*slowlog_log_slower_than*]
#   Set the redis config value slowlog-log-slower-than (microseconds).
#   Default: 10000
#
# [*showlog_max_len*]
#   Set the redis config value slowlog-max-len.
#   Default: 1024
#
# [*autostart*]
#   Configure the init script to start redis on system boot
#   Default: true
#
# === Examples
#
# redis::instance { 'redis-6900':
#   redis_port       => '6900',
#   redis_max_memory => '64gb',
# }
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
define redis::instance (
  $maxmemory,
  $appendfsync             = 'everysec',
  $appendonly              = false,
  $bind_address            = false,
  $log_level               = 'notice',
  $max_clients             = false,
  $maxmemory_policy        = 'volatile-lru',
  $password                = false,
  $port                    = 6379,
  $rdb_saves               = [ [900, 1], [300, 10], [60, 10000] ],
  $slave_read_only         = true,
  $slowlog_log_slower_than = 10000,
  $slowlog_max_len         = 128,
  $timeout                 = 300,
  $autostart               = true
) {
  Class['redis'] -> Redis::Instance[$name]

  $version = $redis::version

  file { "redis-lib-${port}":
    ensure => directory,
    path   => "/var/lib/redis/${port}",
  }

  file { "redis-init-${port}":
    ensure  => present,
    path    => "/etc/init/redis_${port}.conf",
    mode    => '0755',
    content => template('redis/redis.init.erb'),
    notify  => Service["redis_${port}"],
  }

  file { "redis_${port}.conf":
    ensure  => present,
    path    => "/etc/redis/redis_${port}.conf",
    mode    => '0644',
    content => template('redis/redis_port.conf.erb'),
  }

  service { "redis_${port}":
    ensure    => running,
    name      => "redis_${port}",
    enable    => true,
    require   => [ File["redis_${port}.conf"], File["redis-init-${port}"], File["redis-lib-${port}"] ],
    subscribe => File["redis_${port}.conf"],
  }
}
