require 'bump/tasks'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'

task default: [:yard, :rubocop, :spec]
task travis: [:rubocop, :spec]

desc 'Run all tasks'
task all: [:yard, :rubocop, :spec]

YARD::Config.load_plugin 'redcarpet-ext'
YARD::Rake::YardocTask.new do |t|
  t.files = ['**/*.rb', '-', 'README.md', 'CHANGELOG.md', 'LICENSE.txt']
  t.options = ['--markup-provider=redcarpet', '--markup=markdown']
end

RuboCop::RakeTask.new do |t|
  t.formatters = ['progress']
end

RSpec::Core::RakeTask.new
