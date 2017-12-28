# frozen_string_literal: true

#
# Cookbook Name:: build
# Attributes:: default
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

default['omnibus'].tap do |o|
  o['build_name'] = 'nginx'
  o['build_user'] = 'omnibus'
  o['build_user_group'] = 'omnibus'
  o['build_user_password'] = 'omnibus'
  o['staging_dir'] = '/tmp/omnibus'
  o['build_dir'] = '/home/omnibus/nginx'
  o['install_dir'] = '/opt/nginx'

  o['openssl_fips']['version'] = nil
  o['openssl']['version'] = nil
  o['nginx']['version'] = nil
end
