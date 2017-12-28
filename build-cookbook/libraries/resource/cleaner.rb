# frozen_string_literal: true

#
# Cookbook Name:: build
# Library:: resource/cleaner
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

require 'chef/resource'

class Chef
  class Resource
    # A resource for cleaning up remnants of an Omnibus build or install stage.
    class Cleaner < Resource
      provides :cleaner

      default_action :run

      action :run do
        apt_update 'default' if platform_family?('debian')

        package 'nginx' do
          action platform_family?('debian') ? :purge : :remove
        end

        %w[
          /opt/nginx
          /etc/nginx
          /var/log/nginx
          /var/cache/nginx
          /usr/lib/nginx
        ].each do |d|
          directory d do
            recursive true
            action :delete
          end
        end

        %w[
          /usr/sbin/nginx
          /etc/init.d/nginx
          /etc/init/nginx.conf
          /lib/systemd/system/nginx.service
        ].each do |l|
          link(l) { action :delete }
        end
      end
    end
  end
end
