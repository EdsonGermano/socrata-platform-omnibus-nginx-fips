#
# Copyright 2017 YOUR NAME
#
# All Rights Reserved.
#

name 'nginx'
maintainer 'Socrata Engineering <sysadmin@socrata.com>'
homepage 'https://github.com/socrata-platform/omnibus-nginx-fips'
license 'Apache-2.0'
license_file 'LICENSE'

install_dir "#{default_root}/#{name}"

build_version ENV['NGINX_VERSION']
build_iteration ENV['OMNIBUS_BUILD_ITERATION']

dependency 'preparation'

dependency 'openssl-fips'
dependency 'openssl'
dependency 'nginx'
dependency 'nginx-fips'

dependency 'version-manifest'

unless ENV['OPENSSL_FIPS_VERSION'].nil?
  override :'openssl-fips', version: ENV['OPENSSL_FIPS_VERSION']
end
unless ENV['OPENSSL_VERSION'].nil?
  override :openssl, version: ENV['OPENSSL_VERSION']
end
override :nginx, version: ENV['NGINX_VERSION'] unless ENV['NGINX_VERSION'].nil?

exclude '**/.git'
exclude '**/bundler/git'

Omnibus::Config.fips_mode true
