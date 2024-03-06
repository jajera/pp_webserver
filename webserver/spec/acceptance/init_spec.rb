# # frozen_string_literal: true

# require 'spec_helper_acceptance'

# describe 'webserver class' do
#   describe 'webserver class' do
#     context 'default parameters' do
#       it 'works idempotently with no errors' do
#         pp = <<-EOS
#         class { 'webserver': }
#         EOS

#         # Apply the manifest
#         apply_manifest(pp, catch_failures: true)
  
#         # Ensure the manifest is idempotent
#         apply_manifest(pp, catch_changes: true)
#       end

#       describe package('nginx') do
#         it { is_expected.to be_installed }
#       end
  
#       describe service('nginx') do
#         it { is_expected.to be_enabled }
#         it { is_expected.to be_running }
#       end
  
#       describe port(80) do
#         it { is_expected.to be_listening }
#       end
#     end
#   end

#   context 'default parameters' do

#     # Using puppet_apply as a helper
#     it 'works idempotently with no errors' do
#       pp = "
#       include webserver

#       nginx::resource::server { 'example.com':
#         ensure   => present,
#         www_root => '/var/www/html',
#       }
#       "

#       # Run it twice and test for idempotency
#       apply_manifest(pp, catch_failures: true)
#       apply_manifest(pp, catch_changes: true)
#     end

#     # do some basic checks
#     pkg = case os[:family]
#           when 'Archlinux'
#             'nginx-mainline'
#           else
#             'nginx'
#           end
#     describe package(pkg) do
#       it { is_expected.to be_installed }
#     end

#     describe service('nginx') do
#       it { is_expected.to be_running }
#       it { is_expected.to be_enabled }
#     end

#     describe port(80) do
#       it { is_expected.to be_listening }
#     end
#   end

#   context 'with service_config_check true' do
#     # Using puppet_apply as a helper
#     it 'works idempotently with no errors' do
#       pp = "
#       class { 'nginx':
#         service_config_check => true,
#       }

#       nginx::resource::server { 'example.com':
#         ensure   => present,
#         www_root => '/var/www/html',
#       }
#       "

#       # Run it twice and test for idempotency
#       apply_manifest(pp, catch_failures: true)
#       apply_manifest(pp, catch_changes: true)
#     end

#     # do some basic checks
#     pkg = case os[:family]
#           when 'Archlinux'
#             'nginx-mainline'
#           else
#             'nginx'
#           end
#     describe package(pkg) do
#       it { is_expected.to be_installed }
#     end

#     describe service('nginx') do
#       it { is_expected.to be_running }
#       it { is_expected.to be_enabled }
#     end

#     describe port(80) do
#       it { is_expected.to be_listening }
#     end
#   end
# end
