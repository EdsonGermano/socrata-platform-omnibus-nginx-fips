# frozen_string_literal: true

#
# Cookbook Name:: build
# Recipe:: _verify
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

case node['platform_family']
when 'debian'
  dpkg_package 'nginx' do
    version = node['omnibus']['nginx']['version']
    iteration = node['omnibus']['build_iteration']

    source File.join(node['omnibus']['staging_dir'],
                     "pkg/nginx_#{version}-#{iteration}_amd64.deb")
  end
else
  raise(Chef::Exceptions::UnsupportedPlatform, 'Unsupported platform')
end

service 'nginx' do
  action %i[enable start]
end
