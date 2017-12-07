# frozen_string_literal: true

name 'build'
maintainer 'Socrata Engineering'
maintainer_email 'sysadmin@socrata.com'
license 'Apache-2.0'
description 'Builds Nginx packages with FIPS mode'
long_description 'Builds Nginx packages with FIPS mode'
version '0.0.1'
chef_version '>= 12.1'

source_url 'https://github.com/socrata-platform/nginx-build'
issues_url 'https://github.com/socrata-platform/nginx-build/issues'

depends 'omnibus'
depends 'sudo'

supports 'ubuntu'
