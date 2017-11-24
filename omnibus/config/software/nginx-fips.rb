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
end
