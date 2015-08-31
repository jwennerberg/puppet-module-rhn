require 'spec_helper'
describe 'rhn' do

  context 'with default options on osfamily RedHat' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it { should contain_package('rhnsd').with_ensure('installed') }
    it { should contain_package('rhn-client-tools').with_ensure('installed') }
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

  context 'with specifying up2date_settings' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :params do
      { :up2date_settings => {
          "serverURL" => "https://satellite.example.com/XMLRPC",
          "sslCACert" => "/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT",
        }
      }
    end

    it {
      should contain_ini_setting('[] serverURL').with({
        'section' => '',
        'setting' => 'serverURL',
        'value'   => 'https://satellite.example.com/XMLRPC',
        'path'    => '/etc/sysconfig/rhn/up2date',
      })
    }
    it {
      should contain_ini_setting('[] sslCACert').with({
        'section' => '',
        'setting' => 'sslCACert',
        'value'   => '/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT',
        'path'    => '/etc/sysconfig/rhn/up2date',
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

  context 'with invalid up2date_settings parameter' do
    let :facts do
      { :osfamily => 'RedHat' }
    end
    let(:params) { { :up2date_settings => ['not','a','hash'] } }

    it 'should fail' do
      expect {
        should contain_class('rhn')
      }.to raise_error(Puppet::Error)
    end
  end

  context 'with invalid up2date_settings_hiera_merge parameter' do
    let :facts do
      { :osfamily => 'RedHat' }
    end
    let(:params) { { :up2date_settings_hiera_merge => ['not','a','bool'] } }

    it 'should fail' do
      expect {
        should contain_class('rhn')
      }.to raise_error(Puppet::Error)
    end
  end

  context 'with invalid rhnsd_service_ensure parameter' do
    let :facts do
      { :osfamily => 'RedHat' }
    end
    let(:params) { { :rhnsd_service_ensure => 'present' } }

    it 'should fail' do
      expect {
        should contain_class('rhn')
      }.to raise_error(Puppet::Error)
    end
  end

  context 'with invalid rhnsd_file_path parameter' do
    let :facts do
      { :osfamily => 'RedHat' }
    end
    let(:params) { { :rhnsd_file_path => 'not/a/abs/path' } }

    it 'should fail' do
      expect {
        should contain_class('rhn')
      }.to raise_error(Puppet::Error)
    end
  end

  context 'with invalid up2date_file_path parameter' do
    let :facts do
      { :osfamily => 'RedHat' }
    end
    let(:params) { { :up2date_file_path => 'not/a/abs/path' } }

    it 'should fail' do
      expect {
        should contain_class('rhn')
      }.to raise_error(Puppet::Error)
    end
  end
end
