require 'spec_helper'

describe 'apache::service', :type => :class do
  let :pre_condition do
    'include apache::params'
  end
  context "on a Debian OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :lsbdistcodename        => 'squeeze',
        :operatingsystem        => 'Debian',
        :id                     => 'root',
        :kernel                 => 'Linux',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        :is_pe                  => false
      }
    end
    it do
      is_expected.to contain_service("httpd").with(
        'name'      => 'apache2',
        'ensure'    => 'running',
        'enable'    => 'true'
      )
    end

    context "with $service_name => 'foo'" do
      let (:params) do
        { :service_name => 'foo' }
      end
      it do
        is_expected.to contain_service("httpd").with(
          'name'      => 'foo'
        )
      end
    end

    context "with $service_enable => true" do
      let (:params) do
        { :service_enable => true }
      end
      it do
        is_expected.to contain_service("httpd").with(
          'name'      => 'apache2',
          'ensure'    => 'running',
          'enable'    => 'true'
        )
      end
    end

    context "with $service_enable => false" do
      let (:params) do
        { :service_enable => false }
      end
      it do
        is_expected.to contain_service("httpd").with(
          'name'      => 'apache2',
          'ensure'    => 'running',
          'enable'    => 'false'
        )
      end
    end

    context "$service_enable must be a bool" do
      let (:params) do
        { :service_enable => 'not-a-boolean' }
      end

      it 'should fail' do
        expect { catalogue }.to raise_error(Puppet::Error, /is not a boolean/)
      end
    end

    context "$service_manage must be a bool" do
      let (:params) do
        { :service_manage => 'not-a-boolean' }
      end

      it 'should fail' do
        expect { catalogue }.to raise_error(Puppet::Error, /is not a boolean/)
      end
    end

    context "with $service_ensure => 'running'" do
      let (:params) do
        { :service_ensure => 'running' }
      end
      it do
        is_expected.to contain_service("httpd").with(
          'ensure'    => 'running',
          'enable'    => 'true'
        )
      end
    end

    context "with $service_ensure => 'stopped'" do
      let (:params) do
        { :service_ensure => 'stopped' }
      end
      it do
        is_expected.to contain_service("httpd").with(
          'ensure'    => 'stopped',
          'enable'    => 'true'
        )
      end
    end

    context "with $service_ensure => 'UNDEF'" do
      let (:params) do
        { :service_ensure => 'UNDEF' }
      end
      it { is_expected.to contain_service("httpd").without_ensure }
    end

    context "with $service_restart unset" do
      it { is_expected.to contain_service("httpd").without_restart }
    end

    context "with $service_restart => '/usr/sbin/apachectl graceful'" do
      let (:params) do
        { :service_restart => '/usr/sbin/apachectl graceful' }
      end
      it do
        is_expected.to contain_service("httpd").with(
          'restart' => '/usr/sbin/apachectl graceful'
        )
      end
    end
  end


  context "on a RedHat 5 OS, do not manage service" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '5',
        :concat_basedir         => '/dne',
        :operatingsystem        => 'RedHat',
        :id                     => 'root',
        :kernel                 => 'Linux',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        :is_pe                  => false
      }
    end
    let(:params) do
      {
        'service_ensure' => 'running',
        'service_name'   => 'httpd',
        'service_manage' => false
      }
    end
    it { is_expected.not_to contain_service('httpd') }
  end

  context "on a FreeBSD 5 OS" do
    let :facts do
      {
        :osfamily               => 'FreeBSD',
        :operatingsystemrelease => '9',
        :concat_basedir         => '/dne',
        :operatingsystem        => 'FreeBSD',
        :id                     => 'root',
        :kernel                 => 'FreeBSD',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        :is_pe                  => false
      }
    end
    it do
      is_expected.to contain_service("httpd").with(
        'name'      => 'apache24',
        'ensure'    => 'running',
        'enable'    => 'true'
      )
    end
  end

  context "on a Gentoo OS" do
    let :facts do
      {
        :osfamily               => 'Gentoo',
        :operatingsystem        => 'Gentoo',
        :operatingsystemrelease => '3.16.1-gentoo',
        :concat_basedir         => '/dne',
        :id                     => 'root',
        :kernel                 => 'Linux',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin',
        :is_pe                  => false
      }
    end
    it do
      is_expected.to contain_service("httpd").with(
        'name'      => 'apache2',
        'ensure'    => 'running',
        'enable'    => 'true'
      )
    end
  end
end
