require 'spec_helper'

describe 'apache::mod::rpaf', :type => :class do
  it_behaves_like "a mod class, without including apache"
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
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_apache__mod('rpaf') }
    it { is_expected.to contain_package("libapache2-mod-rpaf") }
    it do
      is_expected.to contain_file('rpaf.conf').with(
        'path' => '/etc/apache2/mods-available/rpaf.conf'
      )
    end
    it { is_expected.to contain_file('rpaf.conf').with_content(/^RPAFenable On$/) }

    describe "with sethostname => true" do
      let :params do
        { :sethostname => 'true' }
      end
      it { is_expected.to contain_file('rpaf.conf').with_content(/^RPAFsethostname On$/) }
    end
    describe "with proxy_ips => [ 10.42.17.8, 10.42.18.99 ]" do
      let :params do
        { :proxy_ips => [ '10.42.17.8', '10.42.18.99' ] }
      end
      it { is_expected.to contain_file('rpaf.conf').with_content(/^RPAFproxy_ips 10.42.17.8 10.42.18.99$/) }
    end
    describe "with header => X-Real-IP" do
      let :params do
        { :header => 'X-Real-IP' }
      end
      it { is_expected.to contain_file('rpaf.conf').with_content(/^RPAFheader X-Real-IP$/) }
    end
  end
  context "on a FreeBSD OS" do
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
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_apache__mod('rpaf') }
    it { is_expected.to contain_package("www/mod_rpaf2") }
    it do
      is_expected.to contain_file('rpaf.conf').with(
        'path' => '/usr/local/etc/apache24/Modules/rpaf.conf'
      )
    end
    it { is_expected.to contain_file('rpaf.conf').with_content(/^RPAFenable On$/) }

    describe "with sethostname => true" do
      let :params do
        { :sethostname => 'true' }
      end
      it { is_expected.to contain_file('rpaf.conf').with_content(/^RPAFsethostname On$/) }
    end
    describe "with proxy_ips => [ 10.42.17.8, 10.42.18.99 ]" do
      let :params do
        { :proxy_ips => [ '10.42.17.8', '10.42.18.99' ] }
      end
      it { is_expected.to contain_file('rpaf.conf').with_content(/^RPAFproxy_ips 10.42.17.8 10.42.18.99$/) }
    end
    describe "with header => X-Real-IP" do
      let :params do
        { :header => 'X-Real-IP' }
      end
      it { is_expected.to contain_file('rpaf.conf').with_content(/^RPAFheader X-Real-IP$/) }
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
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_apache__mod('rpaf') }
    it { is_expected.to contain_package("www-apache/mod_rpaf") }
    it do
      is_expected.to contain_file('rpaf.conf').with(
        'path' => '/etc/apache2/modules.d/rpaf.conf'
      )
    end
    it { is_expected.to contain_file('rpaf.conf').with_content(/^RPAFenable On$/) }

    describe "with sethostname => true" do
      let :params do
        { :sethostname => 'true' }
      end
      it { is_expected.to contain_file('rpaf.conf').with_content(/^RPAFsethostname On$/) }
    end
    describe "with proxy_ips => [ 10.42.17.8, 10.42.18.99 ]" do
      let :params do
        { :proxy_ips => [ '10.42.17.8', '10.42.18.99' ] }
      end
      it { is_expected.to contain_file('rpaf.conf').with_content(/^RPAFproxy_ips 10.42.17.8 10.42.18.99$/) }
    end
    describe "with header => X-Real-IP" do
      let :params do
        { :header => 'X-Real-IP' }
      end
      it { is_expected.to contain_file('rpaf.conf').with_content(/^RPAFheader X-Real-IP$/) }
    end
  end
end
