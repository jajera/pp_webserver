# frozen_string_literal: true

require 'spec_helper'

describe 'webserver' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'with defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('nginx') }
        it { is_expected.to contain_class('nginx::config') }
        it { is_expected.to contain_class('nginx::config').that_requires('Class[nginx::package]') }
        it { is_expected.to contain_class('nginx::service') }
        it { is_expected.to contain_class('nginx::service').that_subscribes_to('Class[nginx::package]') }
        it { is_expected.to contain_class('nginx::service').that_subscribes_to('Class[nginx::config]') }
        it { is_expected.to contain_class('nginx::package') }
        it { is_expected.to contain_class('nginx::params') }
      end

      context 'nginx::package' do
        it { is_expected.to compile.with_all_deps }

        case os_facts[:osfamily]
        when 'RedHat'
          context 'using defaults' do
            it { is_expected.to contain_package('nginx') }

            it do
              is_expected.to contain_yumrepo('nginx-release').with(
                'baseurl'  => "https://nginx.org/packages/#{['CentOS', 'VirtuozzoLinux'].include?(os_facts[:operatingsystem]) ? 'centos' : 'rhel'}/#{os_facts[:operatingsystemmajrelease]}/$basearch/",
                'descr'    => 'nginx repo',
                'enabled'  => '1',
                'gpgcheck' => '1',
                'priority' => '1',
                'gpgkey'   => 'https://nginx.org/keys/nginx_signing.key',
              )
            end

            it do
              is_expected.to contain_yumrepo('passenger').with(
                'ensure' => 'absent',
              )
            end

            it { is_expected.to contain_yumrepo('nginx-release').that_comes_before('Package[nginx]') }
            it { is_expected.to contain_yumrepo('passenger').that_comes_before('Package[nginx]') }
          end

        when 'Debian'
          context 'using defaults' do
            it { is_expected.to contain_package('nginx') }
            it { is_expected.not_to contain_package('passenger') }

            it do
              is_expected.to contain_apt__source('nginx').with(
                'location' => "https://nginx.org/packages/#{os_facts[:operatingsystem].downcase}",
                'repos'    => 'nginx',
                'key'      => { 'id' => '573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62' },
              )
            end
          end

        when 'Archlinux'
          context 'using defaults' do
            it { is_expected.to contain_package('nginx-mainline') }
          end
        else
          it { is_expected.to contain_package('nginx') }
        end
      end

      context 'nginx::service' do
        context 'using default parameters' do
          it do
            is_expected.to contain_service('nginx').with(
              ensure: 'running',
              enable: true,
            )
          end

          it { is_expected.to contain_service('nginx').without_restart }
        end
      end

      context 'nginx::config' do
        context 'with defaults' do
          it do
            is_expected.to contain_file('/etc/nginx').only_with(
              path: '/etc/nginx',
              ensure: 'directory',
              owner: 'root',
              group: 'root',
              mode: '0644',
            )
          end

          it do
            is_expected.to contain_file('/etc/nginx/conf.d').only_with(
              path: '/etc/nginx/conf.d',
              ensure: 'directory',
              owner: 'root',
              group: 'root',
              mode: '0644',
            )
          end

          it do
            is_expected.to contain_file('/etc/nginx/conf.stream.d').only_with(
              path: '/etc/nginx/conf.stream.d',
              ensure: 'directory',
              owner: 'root',
              group: 'root',
              mode: '0644',
            )
          end

          it do
            is_expected.to contain_file('/etc/nginx/conf.mail.d').only_with(
              path: '/etc/nginx/conf.mail.d',
              ensure: 'directory',
              owner: 'root',
              group: 'root',
              mode: '0644',
            )
          end

          it do
            is_expected.to contain_file('/etc/nginx/nginx.conf').with(
              ensure: 'file',
              owner: 'root',
              group: 'root',
              mode: '0644',
            )
          end

          it do
            is_expected.to contain_file('/etc/nginx/mime.types').with(
              ensure: 'file',
              owner: 'root',
              group: 'root',
              mode: '0644',
            )
          end

          it do
            is_expected.to contain_file('/tmp/nginx.d').with(
              ensure: 'absent',
              purge: true,
              recurse: true,
            )
          end

          it do
            is_expected.to contain_file('/tmp/nginx.mail.d').with(
              ensure: 'absent',
              purge: true,
              recurse: true,
            )
          end

          case os_facts[:osfamily]
          when 'RedHat'
            it { is_expected.to contain_file('/etc/nginx/nginx.conf').with_content %r{^user nginx;} }

            it do
              is_expected.to contain_file('/var/log/nginx').with(
                ensure: 'directory',
                owner: 'nginx',
                group: 'nginx',
                mode: '0750',
                replace: true,
              )
            end
          when 'Debian'
            it { is_expected.to contain_file('/etc/nginx/nginx.conf').with_content %r{^user www-data;} }

            it do
              is_expected.to contain_file('/var/log/nginx').with(
                ensure: 'directory',
                owner: 'root',
                group: 'adm',
                mode: '0755',
                replace: true,
              )
            end
          end

          context 'when mime.types is default' do
            it { is_expected.to contain_file('/etc/nginx/mime.types').with_content(%r{text/css css;}) }
            it { is_expected.to contain_file('/etc/nginx/mime.types').with_content(%r{audio/mpeg mp3;}) }
          end
        end
      end
    end
  end
end
