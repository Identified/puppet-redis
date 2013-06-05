class redis::dependencies {
  if ! defined(Package['build-essential'])  {
    package { 'build-essential': ensure => installed }
  }

  if ! defined(Package['wget']) {
    package { 'wget': ensure => installed }
  }
}
