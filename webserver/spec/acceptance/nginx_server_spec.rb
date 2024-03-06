# # # frozen_string_literal: true

# require 'spec_helper_acceptance'

# describe 'nginx::resource::server define:' do
#   context 'new server on port 80' do
#     it 'configures a nginx server' do
#       pp = "
#       class { 'nginx': }
#       nginx::resource::server { 'www.puppetlabs.com':
#         ensure   => present,
#         www_root => '/var/www/www.puppetlabs.com',
#       }
#       host { 'www.puppetlabs.com': ip => '127.0.0.1', }
#       file { ['/var/www','/var/www/www.puppetlabs.com']: ensure => directory }
#       file { '/var/www/www.puppetlabs.com/index.html': ensure  => file, content => 'Hello from www\n', }
#       "

#       apply_manifest(pp, catch_failures: true)
#       apply_manifest(pp, catch_changes: true)
#     end

#     describe file('/etc/nginx/sites-available/www.puppetlabs.com.conf') do
#       it { is_expected.to be_file }
#       it { is_expected.to contain 'www.puppetlabs.com' }
#     end

#     describe file('/etc/nginx/sites-enabled/www.puppetlabs.com.conf') do
#       it { is_expected.to be_linked_to '/etc/nginx/sites-available/www.puppetlabs.com.conf' }
#     end

#     describe service('nginx') do
#       it { is_expected.to be_running }
#     end

#     describe port(80) do
#       it { is_expected.to be_listening }
#     end

#     it 'answers to www.puppetlabs.com and responds with "Hello from www"' do
#       run_shell('/usr/bin/curl http://www.puppetlabs.com:80') do |r|
#         expect(r.stdout).to eq("Hello from www\n")
#       end
#     end

#     it 'answers to www.puppetlabs.com without error' do
#       run_shell('/usr/bin/curl --fail http://www.puppetlabs.com:80') do |r|
#         expect(r.exit_code).to be_zero
#       end
#     end
#   end

#   context 'should run successfully with ssl' do
#     it 'configures SSL certificate' do
#       pp = "
#       package { 'openssl':
#         ensure => installed,
#       }
#       "
  
#       # Run it twice and test for idempotency
#       apply_manifest(pp, catch_failures: true)
#       apply_manifest(pp, catch_changes: true)

#       [
#         'echo "-----BEGIN PRIVATE KEY-----
# MIIJQgIBADANBgkqhkiG9w0BAQEFAASCCSwwggkoAgEAAoICAQClaMoD8ngzwKOm
# 2Lz36s0Jndus7icck31wFlAC00XQxZi8CbD9d3tz+aLzYrefaBrKPX69c7M9QVKH
# 92Tl4tEiedwhgr6wvYM+LIYIla/+VYP+LUYA7pf6DWCUzZOk5sZp0bLVhNCvP1pK
# RKMlZTQwiL42Tq0BYgcxDhONZQgkkAS9fXAhtNst4TB29ElbXjKmFu9CW4NLVqmB
# rIB9azHZKlKkC6N2eINelt3Txnhtn3QwViCJZcEnrJQ1tfQYUTGZPitASvqAWMkx
# fJfsyi0V/cD4Y4KcmMMtkn9+yySUshbRIGxCDPj0OrixnyHgMsJIQ9CSHE486Jtp
# wOTXnoT8eVFMsTXNr7bAMzX8tY2uVFiLocWtvqOZNOf38JvBW3b5zxK+gdniEIw0
# l9h1NW98AdHcKZE8LU6jIiCOrmCZ83gNtC2clNG6jKk1GfJp7OMGOo4bR+yqg0Z0
# biD3BM53tSM/agjogLWWB70Q3XtDp5RE3PHtW1TT58D7ApxDrnZ6aWWKyqCirnEn
# WoPryPFaVzIP6hELwwQOCP28EW2rhHvjuyd40U5zzJkN/+HhImNJbmzIdcvJy55i
# xHJ3Gy+eQCk9HeFr8Oz7upcu7BYC9oD62dtx+MSZDLVkXH29Ww2tgti1ydPTyqdJ
# me/pJI9F9fCuqAH0CdigPuunXMRomwIDAQABAoICAQChu2RLl7mQYLujWCjs/9ib
# no48+F+lwVDVV/vDx3BsQcilk5RLQZikPWLnN47zfoczWA2kkIyhSE26RFuTq8Nx
# QlXLLlvl1GePU1l662G5/UOiNAJOxvwyswHMfXXvtvYqYa/KtqKVuAxAsfwThHET
# Q6E42JSw1XjSrkDP8AmWNntsDEqnqn7kzVrl9NYFUIWVgLdQ2sn10DbNZC3+c+G5
# xXgojni2Tf+lbT5Y46a9CTxCRvRpY+UJNeV03wRdAobMn80KgEWPWUDf8kNadBTB
# e+xC8omzNGsjFCs1fsu12KwWru0raCPEKeaNRluJLBhrMGOveZ3GUGolbUZUzdqY
# sA12tS+dgGPpSqtusg1ZMnVrPQNKVbV01UtBCurTVOmyAga/Pijp10kktIKMaCuH
# 1+mJiernL2U2G0v4e3g/oZUlrOoX4+nVYJ7Ff92LY8C2V9RdAbj67wKC/TotOi0R
# dZvDdWFLyZDSCiBLJuRi2YS0+l5uEd0KlEe+4N6D9WZ2TfQVh/4jxO7lRVavAiuA
# zzg8WdlhuizshS8wklUA9q9cRUZg5bb17C0gjKbuZTKm/VRxmVnM4koNLgJ3UHwj
# i+pDR6Gg5xcFUdVpBlx2wmtjIJMk57I5Lln+cHcmcf1Tpb/05tttGOAD4TKs0xru
# 0Olbtw3MUURZ0QLKVNIMAQKCAQEA1gMnhXn5oJgCVMDINVojah4txQFjXM1IuYXT
# dzLPzjgWZM3Pu3NGQzakCIX+oz03LICQkXs5ZZ7Y+piTmo8lLExQA2xcL4GXwRnq
# t5DmP9ylwMlTvJUm/M2tyXa5pg+dyTmsBd/FWB+L5SoH9YtLwzQvB5hGzWOnFciY
# B50tXq0OZasLMYokDnOWLgN9JMKafDY5V1ktkC8H8vbN0WnOO6P5pyp2Osux3KMe
# h2dLDTm0q/kA251lZznZNLneZp5+BAT5ZdSNXJdXYmL9dfoV2Gv3qVMY/4GaB8BC
# OmLj8RRjfwCWcoMVVf7264/9pIWEVAE/0mHMuFzJkG49Zjp8ewKCAQEAxdyIPIT5
# Y2zQOD8nuhCY6gqxA0CmU8aMRKrbtWIszoUb36fP4co6YxZMwAARBeyIMPk1JPK4
# +Z9ndbJ4+GS/ZbzPhBNeo08DHOnXRQeIqA4Bxp8s1VZgZra0393IDzASOXVljlQ2
# /opLvL2FRAxPV9lIp1BpktHN9R31g8u9cnQrcAgVYOMvCDvI1NHI/S5q/ZehEExf
# PTFMMq4vwxfLVxinU7TBeA2sYjzV/clKrCM0TeFX0Jh5gFytY20FjKq95MWJxI8a
# weC/F3lPtmQKJEYUuEYavHH5VAOXk5rKKho/1uTdKBO/ls1o20jJ60PaIWxYpw3D
# WdrHkzWmdwhaYQKCAQBiAuPQr0HxmGxI4FlQhc1+Rf/0H2SgFaveuzlTd8PPz8QB
# ungOgwaEtbt948/wdpKUIPUUi3iH363DZqkCudfuZ6ylRLUbVKBpYTMrioLIcIbA
# ufNNhIlscc3LXEI9mR1MEMuFjSvV5eytsQggHgE+juGS+txCKAdXZJyrsAIdP+g+
# C41+zKMiszDuNc7UTQNvK24rYL4LMF7VmM49v9UhX0Fwm3O2DZ+RSmsq29V1Yx4p
# PEp2SaktE0M0cIM4QBG6SYTma+eppe3xMyCdLUFf8mJj+5iRO4uNTTGHh86YlBvV
# CDHek8Xrsm7nBvTEqhkmV8Qg14VoUaZGLRaVgOeNAoIBABByrMCbLUAeo5CJb3wA
# NTX/fYePsEP2lWJ/8ZO6fY8Ncau9/4H9laz3BZpQZxne99NaZBiWNNpLbgZSt8uu
# VFrYv0dzdMKOpuuYZNTQM4QE5hDk2o1BiPIA7jhN73uTu3AbWj3isk+mn3UpLBLk
# ExRyc5+1B5G07zIZM3epUC5bieDeSyiquhYtIhzO865YVXyPRkxcjO5BUtxDrqTB
# LZ4n5oEG3a5lNJdWB1P5j8OPiaGPwgUNJ8yL574EKhnvd6m04ib83nSPglMpOn8n
# AdDSIpbO/Rn9P4TEZ61ViMjHNddfXyMdwSeAG99exapREakFoLkCY+LsVPrf0t7C
# SwECggEAaruBV8L+t4K2Ts2s7nUodLEm9D3F0B8KQcZ9a7jKxSxgKJ4MGi9UVuVA
# k3DDCpAokVj3ZTlwIeiXnH0bz8+2K3rT55/EhVi1TEUm4nS7qkh3PTAaU1ESbCbE
# VB9ruHi5iyDQYePf8UXtnnmuQlIh8gzXm6MY4YGFu7UF50qY8is6tYQK1oDGnCtF
# vJ2zxuaGG971dvvN1uvIiKx3SmQAHboUnVGJ4u9rpAf8Pb2DgaDgjc/zQKZCUT4a
# MNTh6O4DDw7Zpv6p0A/U8R8ntfGhWaZH+06KXK6Lu8Jol7hGDTaj0MlH+Hl5FkIV
# i5A8a0crzAUy0qEmGadFRVrqGpw74Q==
# -----END PRIVATE KEY-----" > /tmp/blah.key',
#         'echo "-----BEGIN CERTIFICATE-----
# MIIFITCCAwmgAwIBAgIUflF+XwcxPU99fLGJ5nmmfqCL+iAwDQYJKoZIhvcNAQEL
# BQAwIDEeMBwGA1UEAwwVbG9jYWxob3N0LmxvY2FsZG9tYWluMB4XDTIwMDEwNjEz
# MzkwOVoXDTMwMDEwMzEzMzkwOVowIDEeMBwGA1UEAwwVbG9jYWxob3N0LmxvY2Fs
# ZG9tYWluMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEApWjKA/J4M8Cj
# pti89+rNCZ3brO4nHJN9cBZQAtNF0MWYvAmw/Xd7c/mi82K3n2gayj1+vXOzPUFS
# h/dk5eLRInncIYK+sL2DPiyGCJWv/lWD/i1GAO6X+g1glM2TpObGadGy1YTQrz9a
# SkSjJWU0MIi+Nk6tAWIHMQ4TjWUIJJAEvX1wIbTbLeEwdvRJW14yphbvQluDS1ap
# gayAfWsx2SpSpAujdniDXpbd08Z4bZ90MFYgiWXBJ6yUNbX0GFExmT4rQEr6gFjJ
# MXyX7MotFf3A+GOCnJjDLZJ/fssklLIW0SBsQgz49Dq4sZ8h4DLCSEPQkhxOPOib
# acDk156E/HlRTLE1za+2wDM1/LWNrlRYi6HFrb6jmTTn9/CbwVt2+c8SvoHZ4hCM
# NJfYdTVvfAHR3CmRPC1OoyIgjq5gmfN4DbQtnJTRuoypNRnyaezjBjqOG0fsqoNG
# dG4g9wTOd7UjP2oI6IC1lge9EN17Q6eURNzx7VtU0+fA+wKcQ652emllisqgoq5x
# J1qD68jxWlcyD+oRC8MEDgj9vBFtq4R747sneNFOc8yZDf/h4SJjSW5syHXLycue
# YsRydxsvnkApPR3ha/Ds+7qXLuwWAvaA+tnbcfjEmQy1ZFx9vVsNrYLYtcnT08qn
# SZnv6SSPRfXwrqgB9AnYoD7rp1zEaJsCAwEAAaNTMFEwHQYDVR0OBBYEFATBaY1l
# 5qzX0UjbVq7sxk6dpTi9MB8GA1UdIwQYMBaAFATBaY1l5qzX0UjbVq7sxk6dpTi9
# MA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggIBADEMosWeoB2ZY4XE
# EM8gy0EbJ2HZ0zUHQA8UgGqtj2JZVkA3Um/gORzhmANb22XeG1O1sebJ9VMUJwrp
# 3CeZUz7zJtpF7VN47qmB5B3zMjOyTVQ3eYx1RC06wrq/dY+AJWrUZZgcbkNUwY6y
# HLBHFkuYSjzvt2jy2r01nFjqlgvd3GvIaz/1ElxTj/E4TU2yzDY0vNKVeddRsbme
# sE4BvMVH/p1z7NTcC9uKVpQSkQykQtXB8jkecXoIvYvS3UIPye7dAb1iPXueIBnK
# mkbF5FfUEds01Z28ugkVQd39DukuNZ2ZDbZZCyyCU/ASJLEs0I/0vmYDjAHu2aGd
# N3QAaomJVFVZ/3VrqBlzJVSmKhCJ0yWP4ZU+msdBSC10fsxXir0gA2+FgpTzrt0z
# 7/DNowZuF+DxapOatwBM6cX2GMxUtIFNaOcgyte1AJYrjmSMjhi8ShtYmQJXrQ7F
# 4y2YbyhYDUC5vcxQupH8ew4ujIollwYXk0MokMWqogtCnllbH8CmaEHdSNKa5jFE
# ndWUyCibOg2Cmwov8IUej6bMk9aE7akpy0VnlxhTyLDf/WEm5Uf2yUId8M3nB0Wn
# VMrp/E2f2Wf83aggglj2zFMbZUOV1BkEkjfIcXr0KIWKD8uv4iobyUVDLIMv8Qpp
# xfzmRMxZCJIk9jjChtw8KY7NlKyu
# -----END CERTIFICATE-----" > /tmp/blah.cert',
#         'mkdir -p /etc/pki/tls/certs',
#         'mkdir -p /etc/pki/tls/private',
#         'cp /tmp/blah.cert /etc/pki/tls/certs/blah.cert',
#         'cp /tmp/blah.cert /etc/pki/tls/certs/crypted.cert',
#         'cp /tmp/blah.key /etc/pki/tls/private/blah.key',
#         'rm -rf /etc/pki/tls/private/crypted.key /etc/pki/tls/private/crypted.pass',
#         'openssl rsa -in /tmp/blah.key -out /etc/pki/tls/private/crypted.key -passout pass:Sup3r_S3cr3t_Passw0rd',
#         'echo Sup3r_S3cr3t_Passw0rd >/etc/pki/tls/private/crypted.pass',
#         'chmod 0600 /etc/pki/tls/private/crypted.pass',
#       ].each do |command|
#         run_shell(command) do |r|
#           expect(r.exit_code).to eq(0)
#         end
#       end
#     end

#     it 'configures a nginx SSL server' do
#       pp = "
#       class { 'nginx': }
#       nginx::resource::server { 'www.puppetlabs.com':
#         ensure   => present,
#         ssl      => true,
#         ssl_cert => '/etc/pki/tls/certs/blah.cert',
#         ssl_key  => '/etc/pki/tls/private/blah.key',
#         www_root => '/var/www/www.puppetlabs.com',
#       }
#       host { 'www.puppetlabs.com': ip => '127.0.0.1', }
#       file { ['/var/www','/var/www/www.puppetlabs.com']: ensure => directory }
#       file { '/var/www/www.puppetlabs.com/index.html': ensure  => file, content => 'Hello from www\n', }
#       "

#       apply_manifest(pp, catch_failures: true)
#     end


#     it 'remove leftovers from previous tests', if: os[:family] == 'RedHat' do
#       run_shell('yum -y remove nginx nginx-filesystem passenger')
#     end

#     it 'configures a nginx SSL server' do
#       pp = "
#       class { 'nginx': }
#       nginx::resource::server { 'www.puppetlabs.com':
#         ensure   => present,
#         ssl      => true,
#         ssl_cert => '/etc/pki/tls/certs/blah.cert',
#         ssl_key  => '/etc/pki/tls/private/blah.key',
#         www_root => '/var/www/www.puppetlabs.com',
#       }
#       host { 'www.puppetlabs.com': ip => '127.0.0.1', }
#       file { ['/var/www','/var/www/www.puppetlabs.com']: ensure => directory }
#       file { '/var/www/www.puppetlabs.com/index.html': ensure  => file, content => 'Hello from www\n', }
#       "

#       apply_manifest(pp, catch_failures: true)
#     end

#     describe file('/etc/nginx/sites-available/www.puppetlabs.com.conf') do
#       it { is_expected.to be_file }
#       it { is_expected.to contain 'listen       *:443 ssl;' }
#       it { is_expected.not_to contain 'shared:SSL:10m;' }
#     end

#     describe file('/etc/nginx/sites-enabled/www.puppetlabs.com.conf') do
#       it { is_expected.to be_linked_to '/etc/nginx/sites-available/www.puppetlabs.com.conf' }
#     end

#     describe service('nginx') do
#       it { is_expected.to be_running }
#     end

#     describe port(443) do
#       it { is_expected.to be_listening }
#     end

#     it 'answers to http://www.puppetlabs.com with "Hello from www"' do
#       run_shell('/usr/bin/curl http://www.puppetlabs.com:80') do |r|
#         expect(r.stdout).to eq("Hello from www\n")
#       end
#     end

#     it 'answers to http://www.puppetlabs.com without error' do
#       run_shell('/usr/bin/curl --fail http://www.puppetlabs.com:80') do |r|
#         expect(r.exit_code).to eq(0)
#       end
#     end

#     it 'answers to https://www.puppetlabs.com with "Hello from www"' do
#       # use --insecure because it's a self-signed cert
#       run_shell('/usr/bin/curl --insecure https://www.puppetlabs.com:443') do |r|
#         expect(r.stdout).to eq("Hello from www\n")
#       end
#     end

#     it 'answers to https://www.puppetlabs.com without error' do
#       # use --insecure because it's a self-signed cert
#       run_shell('/usr/bin/curl --fail --insecure https://www.puppetlabs.com:443') do |r|
#         expect(r.exit_code).to eq(0)
#       end
#     end
#   end

#   context 'should run successfully with encrypted ssl key' do
#     it 'configures a nginx SSL server' do
#       pp = "
#       class { 'nginx': }
#       nginx::resource::server { 'www.puppetlabs.com':
#         ensure            => present,
#         ssl               => true,
#         ssl_cache         => 'shared:SSL:10m',
#         ssl_cert          => '/etc/pki/tls/certs/crypted.cert',
#         ssl_key           => '/etc/pki/tls/private/crypted.key',
#         ssl_password_file => '/etc/pki/tls/private/crypted.pass',
#         www_root          => '/var/www/www.puppetlabs.com',
#       }
#       host { 'www.puppetlabs.com': ip => '127.0.0.1', }
#       file { ['/var/www','/var/www/www.puppetlabs.com']: ensure => directory }
#       file { '/var/www/www.puppetlabs.com/index.html': ensure  => file, content => 'Hello from www\n', }
#       "

#       apply_manifest(pp, catch_failures: true)
#     end

#     describe file('/etc/nginx/sites-available/www.puppetlabs.com.conf') do
#       it { is_expected.to be_file }
#       it { is_expected.to contain 'ssl_session_cache         shared:SSL:10m;' }
#       it { is_expected.to contain 'ssl_password_file         /etc/pki/tls/private/crypted.pass;' }
#     end

#     describe service('nginx') do
#       it { is_expected.to be_running }
#     end

#     describe port(443) do
#       it { is_expected.to be_listening }
#     end

#     it 'answers to https://www.puppetlabs.com with "Hello from www"' do
#       # use --insecure because it's a self-signed cert
#       run_shell('/usr/bin/curl --insecure https://www.puppetlabs.com:443') do |r|
#         expect(r.stdout).to eq("Hello from www\n")
#       end
#     end

#     it 'answers to https://www.puppetlabs.com without error' do
#       # use --insecure because it's a self-signed cert
#       run_shell('/usr/bin/curl --fail --insecure https://www.puppetlabs.com:443') do |r|
#         expect(r.exit_code).to eq(0)
#       end
#     end
#   end

#   context 'should run successfully with ssl_redirect' do
#     it 'configures a nginx SSL server' do
#       pp = "
#       class { 'nginx': }
#       nginx::resource::server { 'www.puppetlabs.com':
#         ensure       => present,
#         ssl          => true,
#         ssl_cert     => '/etc/pki/tls/certs/blah.cert',
#         ssl_key      => '/etc/pki/tls/private/blah.key',
#         ssl_redirect => true,
#         www_root     => '/var/www/www.puppetlabs.com',
#       }
#       nginx::resource::location { 'letsencrypt':
#         location    => '^~ /.well-known/acme-challenge',
#         www_root    => '/var/www/letsencrypt',
#         index_files => [],
#         ssl         => false,
#         server      => ['www.puppetlabs.com'],
#       }
#       host { 'www.puppetlabs.com': ip => '127.0.0.1', }
#       file { ['/var/www','/var/www/www.puppetlabs.com','/var/www/letsencrypt','/var/www/letsencrypt/.well-known','/var/www/letsencrypt/.well-known/acme-challenge']: ensure => directory }
#       file { '/var/www/www.puppetlabs.com/index.html': ensure  => file, content => 'Hello from www\n', }
#       file { '/var/www/letsencrypt/.well-known/acme-challenge/fb9bd98604be3d0c7d589fcc7561cb41': ensure  => file, content => 'LetsEncrypt\n', }
#       "

#       apply_manifest(pp, catch_failures: true)
#     end

#     describe file('/etc/nginx/sites-available/www.puppetlabs.com.conf') do
#       it { is_expected.to be_file }
#       it { is_expected.to contain 'return 301 https://$host$request_uri;' }
#     end

#     describe service('nginx') do
#       it { is_expected.to be_running }
#     end

#     describe port(80) do
#       it { is_expected.to be_listening }
#     end

#     describe port(443) do
#       it { is_expected.to be_listening }
#     end

#     it 'answers to http://www.puppetlabs.com with redirect to HTTPS' do
#       run_shell('/usr/bin/curl -I http://www.puppetlabs.com:80') do |r|
#         expect(r.stdout).to contain('301 Moved Permanently')
#       end
#     end

#     it 'answers to http://www.puppetlabs.com with redirect to HTTPS' do
#       run_shell('/usr/bin/curl -I http://www.puppetlabs.com:80') do |r|
#         expect(r.stdout).to contain('Location: https://www.puppetlabs.com')
#       end
#     end

#     it 'answers to http://www.puppetlabs.com without error' do
#       run_shell('/usr/bin/curl --fail http://www.puppetlabs.com:80') do |r|
#         expect(r.exit_code).to eq(0)
#       end
#     end

#     it 'answers to https://www.puppetlabs.com with "Hello from www"' do
#       # use --insecure because it's a self-signed cert
#       run_shell('/usr/bin/curl --insecure https://www.puppetlabs.com:443') do |r|
#         expect(r.stdout).to eq("Hello from www\n")
#       end
#     end

#     it 'answers to http://www.puppetlabs.com/.well-known/acme-challenge/fb9bd98604be3d0c7d589fcc7561cb41 with "LetsEncrypt"' do
#       # use --insecure because it's a self-signed cert
#       run_shell('/usr/bin/curl http://www.puppetlabs.com:80/.well-known/acme-challenge/fb9bd98604be3d0c7d589fcc7561cb41') do |r|
#         expect(r.stdout).to eq("LetsEncrypt\n")
#       end
#     end

#     it 'answers to https://www.puppetlabs.com/.well-known/acme-challenge/fb9bd98604be3d0c7d589fcc7561cb41 with "LetsEncrypt"' do
#       # use --insecure because it's a self-signed cert
#       run_shell('/usr/bin/curl --insecure https://www.puppetlabs.com:443/.well-known/acme-challenge/fb9bd98604be3d0c7d589fcc7561cb41') do |r|
#         expect(r.stdout).to contain('404 Not Found')
#       end
#     end
#   end
# end
