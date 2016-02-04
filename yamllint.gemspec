# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yamllint/version'

Gem::Specification.new do |spec|
  spec.name          = 'yamllint'
  spec.version       = YamlLint::VERSION
  spec.authors       = 'Grant Ridder'
  spec.email         = 'shortdudey123@gmail.com'
  spec.summary       = 'YAML lint checker'
  spec.description   = 'Checks YAML files for correct syntax'
  spec.license       = 'MIT'
  spec.homepage      = ''

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'trollop', '~> 2'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'aruba', '~> 0.12'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'coveralls'
end
