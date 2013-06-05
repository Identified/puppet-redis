## HEAD (unreleased)

FEATURES:

  - Add parameter to enable AOF persistence, parameterize fsync policy

IMPROVEMENTS:

  - Set default version to 2.6.13 (this module will now only support 2.6+)]
  - `Class['redis']` no longer creates a default instance, only manages installation of redis
  - Use update-alternatives for redis-cli and redis-server executables
  - Remove wget/gcc includes
  - Add dependencies requirement: `Package['build-essentials']`, `Package['wget']`
  - Use upstart over init.d
  - Update redis configuration file to latest version in 2.6.13


0.0.9
-----
Use maestrodev/wget and puppetlabs/gcc to replace some common package dependencies. - @garethr

0.0.8
-----
Fix init script when redis_bind_address is not defined (the default).

0.0.7
-----
Add support for parameterized listening port and bind address.

0.0.6
-----
Add support for installing any available version.

0.0.5
-----
Add option to install 2.6.
Add spec tests.

0.0.4
-----
It's possible to configure a password to redis setup.

0.0.3
-----
Fix init script.

0.0.2
-----
Change the name to redis so that module name and class name are in sync.

0.0.1
-----
First release!
