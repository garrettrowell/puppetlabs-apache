require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

# put local configuration and setup into spec_helper_local
begin
  require 'spec_helper_local'
#rescue LoadError
end

RSpec.configure do |config|
  config.mock_framework = :rspec

  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.hiera_config = File.expand_path(File.join(__FILE__, '../fixtures/hiera.yaml'))
end
add_custom_fact :concat_basedir, '/dne'
add_custom_fact :sudoversion, '1.7.2p1'
add_custom_fact :selinux_current_mode, 'enforcing'
add_custom_fact :location, 'mia'
add_custom_fact :staging_http_get, 'wget'
add_custom_fact :puppet_vardir, '/var/lib/puppet'
add_custom_fact :root_home, '/root'
