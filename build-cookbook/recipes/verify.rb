# frozen_string_literal: true

#
# Cookbook Name:: build
# Recipe:: verify
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

cleaner 'Pre-verify cleanup'

package 'openssl'

package 'nginx' do
  action platform_family?('debian') ? :purge : :remove
end

directory '/opt/nginx' do
  recursive true
  action :delete
end

case node['platform_family']
when 'debian'
  dpkg_package 'nginx' do
    version = node['omnibus']['nginx']['version']
    iteration = node['omnibus']['build_iteration']

    source File.join(node['omnibus']['staging_dir'],
                     "pkg/nginx_#{version}-#{iteration}_amd64.deb")
  end
when 'rhel'
  rpm_package 'nginx' do
    version = node['omnibus']['nginx']['version']
    iteration = node['omnibus']['build_iteration']
    rhel = node['platform_version'].to_i

    source File.join(node['omnibus']['staging_dir'],
                     "pkg/nginx-#{version}-#{iteration}.el#{rhel}.x86_64.rpm")
  end
else
  raise(Chef::Exceptions::UnsupportedPlatform, 'Unsupported platform')
end

service 'nginx' do
  # RHEL 6 needs some help to know to use Upstart.
  if platform_family?('rhel') && node['platform_version'].to_i == 6
    provider Chef::Provider::Service::Upstart
  end
  action %i[enable start]
end
