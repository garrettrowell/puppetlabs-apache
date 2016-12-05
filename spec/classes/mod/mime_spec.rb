require 'spec_helper'

# This function is called inside the OS specific conte, :compilexts
def general_mime_specs
  it { is_expected.to contain_apache__mod("mime") }
end

describe 'apache::mod::mime', :type => :class do
  it_behaves_like "a mod class, without including apache"

  context "On a Debian OS with default params", :compile do
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

    general_mime_specs()

    it { is_expected.to contain_file("mime.conf").with_path('/etc/apache2/mods-available/mime.conf') }
  end

  context "on a RedHat OS with default params", :compile do
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

    general_mime_specs()

    it { is_expected.to contain_file("mime.conf").with_path("/etc/httpd/conf.d/mime.conf") }
  end
end
