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
default_version '1.12.2'

dependency 'pcre'
dependency 'openssl'

license 'BSD-2-Clause'
license_file 'LICENSE'

source url: "http://nginx.org/download/nginx-#{version}.tar.gz"

version('1.12.2') do
  source sha256: '305f379da1d5fb5aefa79e45c829852ca6983c7cd2a79328f8e084a324' \
                 'cf0416'
end

relative_path "nginx-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command [
    './configure',
    "--prefix=#{install_dir}/embedded",
    '--with-http_ssl_module',
    '--with-http_stub_status_module',
    '--with-ipv6',
    '--with-debug',
    "--with-cc-opt=\"-L#{install_dir}/embedded/lib " \
                     "-I#{install_dir}/embedded/include\"",
    "--with-ld-opt=-L#{install_dir}/embedded/lib"
  ].join(' '), env: env

  make "-j #{workers}", env: env
  make 'install', env: env

  # Ensure the logs directory is available on rebuild from git cache
  touch "#{install_dir}/embedded/logs/.gitkeep"

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
