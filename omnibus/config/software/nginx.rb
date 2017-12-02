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
default_version ENV['NGINX_VERSION']

dependency 'pcre'
dependency 'openssl'

license 'BSD-2-Clause'
license_file 'LICENSE'

source url: "http://nginx.org/download/nginx-#{version}.tar.gz"

version ENV['NGINX_VERSION'] { source sha256: ENV['NGINX_SHA256'] }

relative_path "nginx-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Set the embedded OpenSSL to default to FIPS mode.
  patch source: 'openssl.cnf.patch',
        target: "#{install_dir}/embedded/ssl/openssl.cnf",
        env: env

  command [
    './configure',
    "--prefix=#{install_dir}/embedded",
    "--with-cc-opt=\"-L#{install_dir}/embedded/lib " \
                     "-I#{install_dir}/embedded/include\"",
    "--with-ld-opt=-L#{install_dir}/embedded/lib",
    '--conf-path=/etc/nginx/nginx.conf',
    '--pid-path=/var/run/nginx.pid',
    '--lock-path=/var/lock/nginx.lock',
    '--http-log-path=/var/log/nginx/access.log',
    '--error-log-path=/var/log/nginx/error.log',
    '--http-client-body-temp-path=/var/cache/nginx/body',
    '--http-fastcgi-temp-path=/var/cache/nginx/fastcgi',
    '--http-proxy-temp-path=/var/cache/nginx/proxy',
    '--http-scgi-temp-path=/var/cache/nginx/scgi',
    '--http-uwsgi-temp-path=/var/cache/nginx/uwsgi'
    '--with-ipv6',
    '--with-debug',
    '--with-http_ssl_module',
    '--with-http_stub_status_module'
  ].join(' '), env: env

  make "-j #{workers}", env: env
  make 'install', env: env

  # Remove the default bin dir and put a symlink to embedded/sbin/nginx in
  # sbin/nginx.
  delete "#{install_dir}/bin"
  mkdir "#{install_dir}/sbin"
  link "#{install_dir}/embedded/sbin/nginx", "#{install_dir}/sbin/nginx"

  # Put symlinks to embedded/conf/* in conf/*.
  mkdir "#{install_dir}/conf"
  link "#{install_dir}/embedded/conf/*", "#{install_dir}/conf/"
  delete "#{install_dir}/conf/*.default"

  # Copy all the init scripts into the project directory.
  copy File.join(project.files_path, 'init'), File.join(install_dir, 'init')
end
