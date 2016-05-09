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
  t.patterns = %w( lib/**/*.rb lib/*.rb spec/*.rb )
end

desc 'yamllint rake test'
YamlLint::RakeTask.new do |t|
  t.paths = %w( spec/data/valid* )
end

desc 'yamllint rake test with exclude_paths'
YamlLint::RakeTask.new(:yamllint_exclude_paths) do |t|
  t.paths = %w(
    spec/data/*
  )
  t.exclude_paths = %w(
    spec/data/custom_extension.eyaml
    spec/data/empty.yaml
    spec/data/invalid.yaml
    spec/data/overlapping_keys.yaml
    spec/data/overlapping_keys_deep.yaml
    spec/data/spaces.yaml
    spec/data/wrong_extension.txt
  )
end

desc 'yamllint rake test disabled file ext check'
YamlLint::RakeTask.new(:yamllint_disable_ext_check) do |t|
  t.paths = %w( spec/data/wrong_extension.txt )
  t.disable_ext_check = true
end

desc 'yamllint rake test disabled file ext check'
YamlLint::RakeTask.new(:yamllint_custom_ext) do |t|
  t.paths = %w( spec/data/custom_extension.eyaml )
  t.extensions = %w( eyaml )
end

desc 'yamllint rake test disabled file ext check'
YamlLint::RakeTask.new(:yamllint_debug_logging) do |t|
  t.paths = %w( spec/data/valid.yaml )
  t.debug = true
end

task default: [
  :rubocop,
  :yamllint,
  :yamllint_exclude_paths,
  :yamllint_disable_ext_check,
  :yamllint_custom_ext,
  :yamllint_debug_logging,
  :spec
]
