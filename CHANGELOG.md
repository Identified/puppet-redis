## HEAD (unreleased)

This is a fork of https://github.com/thomasvandoren/puppet-redis from commit 17308f1be093cd2fa003b5e53a99c22b61e4e24e

FEATURES:

  - Add parameter to enable AOF persistence, parameterize fsync policy
  - Add parameter to specify when to do RDB snapshots

IMPROVEMENTS:

  - Set default version to 2.6.13 (this module will now only support 2.6+)]
  - `Class['redis']` no longer creates a default instance, only manages installation of redis
  - Use update-alternatives for redis-cli and redis-server executables
  - Remove wget/gcc includes
  - Add dependencies requirement: `Package['build-essentials']`, `Package['wget']`
  - Use upstart over init.d
  - Update redis configuration file to latest version in 2.6.13
