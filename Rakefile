require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'yamllint/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'Run all linters on the codebase'
task :linters do
  Rake::Task['rubocop'].invoke
end

desc 'rubocop compliancy checks'
RuboCop::RakeTask.new(:rubocop) do |t|
  t.patterns = %w{ lib/**/*.rb lib/*.rb spec/*.rb }
end

desc 'yamllint rake test'
YamlLint::RakeTask.new do |t|
  t.paths = %w{ spec/data/valid* }
end

desc 'yamllint rake test disabled file ext check'
YamlLint::RakeTask.new(:yamlling_disable_ext_check) do |t|
  t.paths = %w{ spec/data/wrong_extention.txt }
  t.disable_ext_check = true
end

task default: [:rubocop, :yamllint, :yamlling_disable_ext_check, :spec]
