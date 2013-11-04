require 'spec_helper'

describe 'redis', type: 'class' do
  context 'On a Debian OS with default params' do
    let(:facts) { {osfamily: 'Debian'} }
    it do
      should contain_file('/opt/redis-src').with(ensure: 'directory')
      should contain_file('/etc/redis').with(ensure: 'directory')
      should contain_file('redis-lib').with(ensure: 'directory',
                                            path: '/var/lib/redis')
      should contain_exec('get-redis-pkg').with_command(/http:\/\/download\.redis\.io\/releases\/redis-2\.6\.16\.tar\.gz/)
      should contain_exec('unpack-redis').with(cwd: '/opt/redis-src',
                                               path: '/bin:/usr/bin')
      should contain_exec('install-redis').with(cwd: '/opt/redis-src',
                                                path: '/bin:/usr/bin')
    end
  end

  context 'On a Debian OS with non-default src and bin locations' do
    let(:facts) { {osfamily: 'Debian'} }
    let(:params) { {src_dir: '/fake/path/to/redis-src', bin_dir: '/fake/path/to/redis'} }
    it do
      should contain_file('/fake/path/to/redis-src').with(ensure: 'directory')
      should contain_file('/etc/redis').with(ensure: 'directory')
      should contain_file('redis-lib').with(ensure: 'directory',
                                            path: '/var/lib/redis')
      should contain_exec('unpack-redis').with(cwd: '/fake/path/to/redis-src',
                                               path: '/bin:/usr/bin')
      should contain_exec('install-redis').with(cwd: '/fake/path/to/redis-src',
                                                path: '/bin:/usr/bin')
    end
  end

  context 'With an invalid version param.' do
    let(:params) { {version: 'bad version'} }
    it do
      expect { should raise_error(Puppet::Error) }
    end
  end
end
