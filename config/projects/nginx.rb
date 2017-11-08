#
# Copyright 2017 YOUR NAME
#
# All Rights Reserved.
#

name "nginx"
maintainer "CHANGE ME"
homepage "https://CHANGE-ME.com"

# Defaults to C:/nginx on Windows
# and /opt/nginx on all other platforms
install_dir "#{default_root}/#{name}"

build_version Omnibus::BuildVersion.semver
build_iteration 1

# Creates required build directories
dependency "preparation"

# nginx dependencies/components
# dependency "somedep"

# Version manifest file
dependency "version-manifest"

exclude "**/.git"
exclude "**/bundler/git"
