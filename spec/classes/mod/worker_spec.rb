require 'spec_helper'

describe 'apache::mod::worker', :type => :class do
  let :pre_condition do
    'class { "apache": mpm_module => false, }'
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
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.not_to contain_apache__mod('worker') }
    it { is_expected.to contain_file("/etc/apache2/mods-available/worker.conf").with_ensure('file') }
    it { is_expected.to contain_file("/etc/apache2/mods-enabled/worker.conf").with_ensure('link') }

    context "with Apache version < 2.4" do
      let :params do
        {
          :apache_version => '2.2'
        }
      end

      it { is_expected.not_to contain_file("/etc/apache2/mods-available/worker.load") }
      it { is_expected.not_to contain_file("/etc/apache2/mods-enabled/worker.load") }

      it { is_expected.to contain_package("apache2-mpm-worker") }
    end

    context "with Apache version >= 2.4" do
      let :params do
        {
          :apache_version => '2.4'
        }
      end

      it do
        is_expected.to contain_file("/etc/apache2/mods-available/worker.load").with(
          'ensure'  => 'file',
          'content' => "LoadModule mpm_worker_module /usr/lib/apache2/modules/mod_mpm_worker.so\n"
        )
      end
      it { is_expected.to contain_file("/etc/apache2/mods-enabled/worker.load").with_ensure('link') }
    end
  end
  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :operatingsystem        => 'RedHat',
        :id                     => 'root',
        :kernel                 => 'Linux',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        :is_pe                  => false
      }
    end
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.not_to contain_apache__mod('worker') }
    it { is_expected.to contain_file("/etc/httpd/conf.d/worker.conf").with_ensure('file') }

    context "with Apache version < 2.4" do
      let :params do
        {
          :apache_version => '2.2'
        }
      end

      it do
        is_expected.to contain_file_line("/etc/sysconfig/httpd worker enable").with(
          'require' => 'Package[httpd]'
        )
      end
    end

    context "with Apache version >= 2.4" do
      let :params do
        {
          :apache_version => '2.4'
        }
      end

      it { is_expected.not_to contain_apache__mod('event') }

      it do
        is_expected.to contain_file("/etc/httpd/conf.d/worker.load").with(
          'ensure'  => 'file',
          'content' => "LoadModule mpm_worker_module modules/mod_mpm_worker.so\n"
        )
      end
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
    it { is_expected.not_to contain_apache__mod('worker') }
    it { is_expected.to contain_file("/usr/local/etc/apache24/Modules/worker.conf").with_ensure('file') }
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
    it { is_expected.not_to contain_apache__mod('worker') }
    it { is_expected.to contain_file("/etc/apache2/modules.d/worker.conf").with_ensure('file') }
  end

  # Template config doesn't vary by distro
  context "on all distros" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'CentOS',
        :operatingsystemrelease => '6',
        :kernel                 => 'Linux',
        :id                     => 'root',
        :concat_basedir         => '/dne',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        :is_pe                  => false
      }
    end

    context 'defaults' do
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^<IfModule mpm_worker_module>$/
        )
      end
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^\s+ServerLimit\s+25$/
        )
      end
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^\s+StartServers\s+2$/
        )
      end
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^\s+MaxClients\s+150$/
        )
      end
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^\s+MinSpareThreads\s+25$/
        )
      end
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^\s+MaxSpareThreads\s+75$/
        )
      end
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^\s+ThreadsPerChild\s+25$/
        )
      end
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^\s+MaxRequestsPerChild\s+0$/
        )
      end
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^\s+ThreadLimit\s+64$/
        )
      end
      it do
        should contain_file("/etc/httpd/conf.d/worker.conf").with(
          :content => /^\s*ListenBacklog\s*511/
        )
      end
    end

    context 'setting params' do
      let :params do
        {
          :serverlimit          => 10,
          :startservers         => 11,
          :maxclients           => 12,
          :minsparethreads      => 13,
          :maxsparethreads      => 14,
          :threadsperchild      => 15,
          :maxrequestsperchild  => 16,
          :threadlimit          => 17,
          :listenbacklog        => 8
        }
      end
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^<IfModule mpm_worker_module>$/
        )
      end
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^\s+ServerLimit\s+10$/
        )
      end
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^\s+StartServers\s+11$/
        )
      end
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^\s+MaxClients\s+12$/
        )
      end
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^\s+MinSpareThreads\s+13$/
        )
      end
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^\s+MaxSpareThreads\s+14$/
        )
      end
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^\s+ThreadsPerChild\s+15$/
        )
      end
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^\s+MaxRequestsPerChild\s+16$/
        )
      end
      it do
        should contain_file('/etc/httpd/conf.d/worker.conf').with(
          :content => /^\s+ThreadLimit\s+17$/
        )
      end
      it do
        should contain_file("/etc/httpd/conf.d/worker.conf").with(
          :content => /^\s*ListenBacklog\s*8/
        )
      end
    end
  end
end
