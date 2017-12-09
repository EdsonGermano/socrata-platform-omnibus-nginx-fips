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
    '--pid-path=/var/run/nginx.pid',
    '--lock-path=/var/lock/nginx.lock',
    '--http-log-path=/var/log/nginx/access.log',
    '--error-log-path=/var/log/nginx/error.log',
    '--http-client-body-temp-path=/var/cache/nginx/client_temp',
    '--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp',
    '--http-proxy-temp-path=/var/cache/nginx/proxy_temp',
    '--http-scgi-temp-path=/var/cache/nginx/scgi_temp',
    '--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp',
    '--with-threads',
    '--with-debug',
    '--with-compat',
    '--with-file-aio',
    '--with-http_addition_module',
    '--with-http_auth_request_module',
    '--with-http_dav_module',
    '--with-http_flv_module',
    '--with-http_gunzip_module',
    '--with-http_gzip_static_module',
    '--with-http_mp4_module',
    '--with-http_random_index_module',
    '--with-http_realip_module',
    '--with-http_secure_link_module',
    '--with-http_slice_module',
    '--with-http_ssl_module',
    '--with-http_stub_status_module',
    '--with-http_sub_module',
    '--with-http_v2_module',
    '--with-mail',
    '--with-mail_ssl_module',
    '--with-stream',
    '--with-stream_realip_module',
    '--with-stream_ssl_module',
    '--with-stream_ssl_preread_module'
  ].join(' '), env: env

  # TODO: What about these other configure flags?
  # --conf-path=/etc/nginx/nginx.conf
  # --modules-path=/usr/lib/nginx/modules
  # --user=nginx
  # --group=nginx

  make "-j #{workers}", env: env

  # Omnibus doesn't currently support adding directories; see:
  # https://github.com/chef/omnibus/issues/464
  %w[
    /var/log/nginx
    /var/cache/nginx
  ].each do |dir|
    command "sudo mkdir #{dir}"
    command "sudo touch #{File.join(dir, '.keep')}"
    project.extra_package_file File.join(dir, '.keep')
  end

  make 'install', env: env

  # Remove the default bin dir and put a symlink to embedded/sbin/nginx in
  # sbin/nginx.
  delete "#{install_dir}/bin"
  mkdir "#{install_dir}/sbin"
  link "#{install_dir}/embedded/sbin/nginx", "#{install_dir}/sbin/nginx"
  command "sudo ln -s #{install_dir}/sbin/nginx /usr/sbin/nginx"
  project.extra_package_file '/usr/sbin/nginx'

  # Put symlinks to embedded/conf/* in conf/*.
  mkdir "#{install_dir}/conf"
  link "#{install_dir}/embedded/conf/*", "#{install_dir}/conf/"
  delete "#{install_dir}/conf/*.default"

  # Copy all the init scripts into the project directory.
  copy File.join(project.files_path, 'init'), File.join(install_dir, 'init')
end
