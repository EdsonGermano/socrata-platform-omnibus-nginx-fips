# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'rubocop/rake_task'
require 'foodcritic'
require 'kitchen/rake_tasks'

RuboCop::RakeTask.new

FoodCritic::Rake::LintTask.new do |f|
  f.options = { fail_tags: %w[any] }
end

Kitchen::RakeTasks.new

task default: %w[rubocop foodcritic]
