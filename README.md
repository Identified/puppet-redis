# puppet-redis

A puppet module for installing and managing Redis.

## Installation

Add this as a git submodule into your puppet modules/redis directory:
```bash
git submodule add git://github.com/Identified/puppet-redis.git modules/redis
git commit -m 'Adding modules/redis as a git submodule.'
```

Usage
-----
Installs redis server and client packages (defaults to version 2.6.13)

```puppet
include redis
```

Installs redis server and client packages with version `x.x.x`.

```puppet
class { 'redis':
  version => 'x.x.x',
}
```

Creates an instance on port 6379, sets maxmemory to 1 gb, and sets a password from hiera.

```puppet
redis::instance { 'redis-6379':
  port      => 6379,
  password  => hiera('redis_password'),
  maxmemory => '1gb',
}
```

## Limitations

This module has only been tested on Ubuntu 12.04LTS

## Authors
- Identified, Inc.
- Thomas Van Doren (Commits 17308f1be093cd2fa003b5e53a99c22b61e4e24e and older)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
BSD
