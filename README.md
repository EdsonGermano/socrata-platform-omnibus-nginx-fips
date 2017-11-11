# Nginx Omnibus Project

[![Build Status](https://img.shields.io/travis/socrata-platform/omnibus-nginx-fips.svg)][travis]

[travis]: https://travis-ci.org/socrata-platform/omnibus-nginx-fips

This project creates full-stack platform-specific packages for Nginx with an
embedded OpenSSL built and configured for FIPS mode.

## Installation

This project makes use of Bundler and Test Kitchen for its builds, so requires
a Ruby 2.0+ environment with Bundler installed.

All the dependencies can be installed with Bundler:

```shell
$ bundle install
```

## Usage

### Build

Builds are managed by the included Test Kitchen configs and build cookbook.
To kick off a build, just run Kitchen:

```shell
$ bundle exec kitchen converge
```

This will start a build node, install Omnibus on it, build and validate a new
Nginx package, and sync it back to the `./omnibus/pkg/` directory.

The platform/architecture type of the package artifact will match the Kitchen
platform on which the build takes place. Currently, this is limited to a 64-bit
.deb package.

### Publish

Artifacts built by this project are deployed to a repo in Bintray. Because
Omnibus does not have a backend for Bintray, these deploys are currently done
manually at the end of a build.

## Maintainers

- Jonathan Hartman <jonathan.hartman@socrata.com>
