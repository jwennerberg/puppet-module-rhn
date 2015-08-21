require 'spec_helper'
describe 'rhn' do

  context 'with default options on osfamily RedHat' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it { should contain_package('rhnsd').with_ensure('installed') }
    it { should contain_package('rhn-client-tools').with_ensure('installed') }
    it {
      should contain_file('up2date_file').with({
        'ensure' => 'file',
        'path'   => '/etc/sysconfig/rhn/up2date',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0600',
      })
    }
    it { should contain_file('up2date_file').with_content(/^serverURL=https:\/\/xmlrpc.rhn.redhat.com\/XMLRPC$/) }
    it { should contain_file('up2date_file').with_content(/^sslCACert=\/usr\/share\/rhn\/RHN-ORG-TRUSTED-SSL-CERT$/) }

    it {
      should contain_file('rhnsd_file').with({
        'ensure' => 'file',
        'path'   => '/etc/sysconfig/rhn/rhnsd',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      }).with_content(/^INTERVAL=240$/)
    }
    it {
      should contain_service('rhnsd_service').with({
        'ensure' => 'running',
        'enable' => 'true',
        'name'   => 'rhnsd',
      })
    }
  end

  context 'with specifying up2date_server_url' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :params do
      { :up2date_server_url => 'https://satellite.example.com/XMLRPC' }
    end

    it {
      should contain_file('up2date_file').with({
        'ensure' => 'file',
        'path'   => '/etc/sysconfig/rhn/up2date',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0600',
      }).with_content(/^serverURL=https:\/\/satellite.example.com\/XMLRPC$/)
    }
  end

  context 'with specifying up2date_ssl_ca_cert' do
    let :facts do
      { :operatingsystem => 'RedHat' }
    end

    let :params do
      { :up2date_ssl_ca_cert => '/usr/share/rhn/CUSTOM-SSL-CERT' }
    end

    it {
      should contain_file('up2date_file').with({
        'ensure' => 'file',
        'path'   => '/etc/sysconfig/rhn/up2date',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0600',
      }).with_content(/^sslCACert=\/usr\/share\/rhn\/CUSTOM-SSL-CERT$/)
    }
  end

  context 'with specifying up2date file parameters' do
    let :facts do
      { :operatingsystem => 'RedHat' }
    end

    let :params do
      {
        :up2date_file_owner => 'root',
        :up2date_file_group => 'rhn',
        :up2date_file_mode  => '0640',
        :up2date_file_path  => '/etc/sysconfig/rhn/up2date_c',
      }
    end

    it {
      should contain_file('up2date_file').with({
        'ensure' => 'file',
        'path'   => '/etc/sysconfig/rhn/up2date_c',
        'owner'  => 'root',
        'group'  => 'rhn',
        'mode'   => '0640',
      })
    }
  end

  context 'with specifying rhnsd file parameters' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :params do
      {
        :rhnsd_file_owner => 'rhn',
        :rhnsd_file_group => 'rhn',
        :rhnsd_file_mode  => '0664',
        :rhnsd_file_path  => '/etc/sysconfig/rhn/rhnsd_c',
      }
    end

    it {
      should contain_file('rhnsd_file').with({
        'ensure' => 'file',
        'path'   => '/etc/sysconfig/rhn/rhnsd_c',
        'owner'  => 'rhn',
        'group'  => 'rhn',
        'mode'   => '0664',
      })
    }
  end

  context 'with rhnsd_service_enable set to false' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :params do
      {
        :rhnsd_service_enable => 'false',
      }
    end

    it {
      should contain_service('rhnsd_service').with({
        'ensure' => 'running',
        'enable' => 'false',
        'name'   => 'rhnsd',
      })
    }
  end

  context 'with rhnsd_service_ensure set to stopped' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :params do
      {
        :rhnsd_service_ensure => 'stopped',
      }
    end

    it {
      should contain_service('rhnsd_service').with({
        'ensure' => 'stopped',
        'enable' => 'true',
        'name'   => 'rhnsd',
      })
    }
  end

  context 'with specifying rhnsd_service_name' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :params do
      {
        :rhnsd_service_name => 'rhnsd_c',
      }
    end

    it {
      should contain_service('rhnsd_service').with({
        'ensure' => 'running',
        'enable' => 'true',
        'name'   => 'rhnsd_c',
      })
    }
  end

  context 'with specifying packages' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :params do
      { :packages => ['rhnsd','rhn-client-tools','osad'] }
    end

    it { should contain_package('rhnsd').with_ensure('installed') }
    it { should contain_package('rhn-client-tools').with_ensure('installed') }
    it { should contain_package('osad').with_ensure('installed') }
  end
end
