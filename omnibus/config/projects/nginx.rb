# frozen_string_literal: true

#
# Copyright 2017, Socrata, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
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

package :deb do
  vendor 'Socrata, Inc <sysadmin@socrata.com>'
end

package :rpm do
  vendor 'Socrata, Inc <sysadmin@socrata.com>'
end

# Patch Omnibus' copy_file method to make it support symlinks instead of
# copying them over as files.
Omnibus::Util.class_eval do
  def copy_file(source, destination)
    if File.directory?(destination)
      destination = File.join(destination, File.basename(source))
    end
    log.debug(log_key) { "Copying `#{source}' to `#{destination}'" }
    if File.symlink?(source)
      FileUtils.copy_entry(source, destination)
    elsif File.directory?(source)
      FileUtils.cp_r(source, destination)
    else
      FileUtils.cp(source, destination)
    end
    destination
  end
end

# Patch the RPM packager to not claim ownership of system directories,
# e.g. /usr/sbin.
Omnibus::Packager::RPM.class_eval do
  def mark_filesystem_directories(fsdir)
    filesystem_directories.include?(fsdir) ? '' : "%dir #{fsdir}"
  end
end
