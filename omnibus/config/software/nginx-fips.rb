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

name 'nginx-fips'
default_version '0.1.0'

dependency 'openssl-fips'
dependency 'openssl'
dependency 'nginx'

license :project_license

source path: project.files_path

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Set the embedded OpenSSL to default to FIPS mode.
  patch source: 'openssl.cnf.patch',
        target: "#{install_dir}/embedded/ssl/openssl.cnf",
        env: env

  delete "#{install_dir}/bin"
  mkdir "#{install_dir}/sbin"
  link "#{install_dir}/embedded/sbin/nginx", "#{install_dir}/sbin/nginx"

  mkdir "#{install_dir}/conf"
  link "#{install_dir}/embedded/conf/*", "#{install_dir}/conf/"
  delete "#{install_dir}/conf/*.default"

  copy File.join(project.files_path, 'init'), File.join(install_dir, 'init')
end
