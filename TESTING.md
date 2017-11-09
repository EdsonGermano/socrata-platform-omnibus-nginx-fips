# Testing

## Prerequisites

Running the tests described below assumes an already installed Ruby environment
(via Chef-DK, Homebrew, system Ruby, etc).

## Installing Dependencies

Install all the gem dependencies into your Ruby environment:

```shell
$ bundle install
```

Or, if using the Chef-DK's Ruby:

```shell
$ eval "$(chef shell-init bash)"
$ bundle install
```

## All Test Suites

The included `Rakefile` defines a default task that runs all non-integration
tests:

```shell
$ bundle exec rake
```

## Lint Tests

This project uses both RuboCop and FoodCritic for linting. Just the lint tests
can be run with Rake:

```shell
$ bundle exec rake rubocop
$ bundle exec rake foodcritic
```
