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
  t.paths = %w{ spec/data/wrong_extension.txt }
  t.disable_ext_check = true
end

desc 'yamllint rake test disabled file ext check'
YamlLint::RakeTask.new(:yamlling_custom_ext) do |t|
  t.paths = %w{ spec/data/custom_extension.eyaml }
  t.extensions = %w{ eyaml }
end

task default: [:rubocop, :yamllint, :yamlling_disable_ext_check, :yamlling_custom_ext, :spec]
