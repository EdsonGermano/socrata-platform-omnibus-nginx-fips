# frozen_string_literal: true

#
# Cookbook Name:: build
# Recipe:: build
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

cleaner 'Pre-build cleanup'

include_recipe 'omnibus'
include_recipe 'sudo'

sudo 'Omnibus user' do
  user node['omnibus']['build_user']
  nopasswd true
end

package 'rsync'

execute 'Copy the Omnibus project to the build directory' do
  command "rsync -a -d #{node['omnibus']['staging_dir']}/ " \
          "#{node['omnibus']['build_dir']}/"
end

execute 'Fix ownership of the build directory' do
  usr = node['omnibus']['build_user']

  command "chown -R #{usr}:#{usr} #{node['omnibus']['build_dir']}"
end

omnibus_build 'nginx' do
  project_dir node['omnibus']['build_dir']
  environment(OPENSSL_FIPS_VERSION: node['omnibus']['openssl_fips']['version'],
              OPENSSL_VERSION: node['omnibus']['openssl']['version'],
              NGINX_VERSION: node['omnibus']['nginx']['version'],
              NGINX_SHA256: node['omnibus']['nginx']['sha256'])
  live_stream true
end

execute 'Copy the build artifacts back to the staging directory' do
  command "rsync -a #{node['omnibus']['build_dir']}/pkg/ " \
          "#{node['omnibus']['staging_dir']}/pkg/"
end
