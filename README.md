# YamlLint

[![Build Status](https://travis-ci.org/shortdudey123/yamllint.svg?branch=master)](https://travis-ci.org/shortdudey123/yamllint)
[![Gem Version](http://img.shields.io/gem/v/yamllint.svg)](https://rubygems.org/gems/yamllint)
[![Coverage Status](https://img.shields.io/coveralls/shortdudey123/yamllint/master.svg)](https://coveralls.io/r/shortdudey123/yamllint?branch=master)
[![Code Climate](https://codeclimate.com/github/shortdudey123/yamllint/badges/gpa.svg)](https://codeclimate.com/github/shortdudey123/yamllint)
[![Dependency Status](https://img.shields.io/gemnasium/shortdudey123/yamllint.svg)](https://gemnasium.com/shortdudey123/yamllint)

Checks YAML files for correct syntax.  Currently it checks for:

 * Valid YAML syntax
 * Overlapping key definitions in YAML files, where the last definition would win

This is a YAML version of [jsonlint](https://github.com/dougbarth/jsonlint)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yamllint'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yamllint

## Usage

### CLI

You can run yamllint against a set of files in the command line. Any errors will be printed and the process will exit with a non-zero exit code.

```
$ yamllint spec/data/*
spec/data/empty.yaml
  The YAML should not be an empty string
spec/data/invalid.yaml
  (<unknown>): found character that cannot start any token while scanning for the next token at line 1 column 6
spec/data/overlapping_keys.yaml
  The same key is defined more than once: foo
spec/data/overlapping_keys_complex.yaml
  The same key is defined more than once: foo
spec/data/overlapping_keys_deep.yaml
  The same key is defined more than once: foo
spec/data/spaces.yaml
  The YAML should not just be spaces
$
```

#### CLI options

<table>
  <th>
    <td>Short</td>
    <td>Long</td>
    <td>Description</td>
    <td>Default</td>
  </th>
  <tr>
    <td>`-d`</td>
    <td>`--disable-ext-check`</td>
    <td>Disable file extension check</td>
    <td>false</td>
  </tr>
  <tr>
    <td>`-v`</td>
    <td>`--version`</td>
    <td>Print version and exit</td>
    <td>false</td>
  </tr>
  <tr>
    <td>`-h`</td>
    <td>`--help`</td>
    <td>Show help message</td>
    <td>false</td>
  </tr>
</table>

### Rake task

You can integrate yamllint into your build process by adding a Rake task to your project

```ruby
require 'yamllint/rake_task'
YamlLint::RakeTask.new do |t|
  t.paths = %w(
    spec/**/*.yaml
  )
end
```

Then run the rake task.

```
$ rake yamllint
spec/data/empty.yaml
  The YAML should not be an empty string
spec/data/invalid.yaml
  (<unknown>): found character that cannot start any token while scanning for the next token at line 1 column 6
spec/data/overlapping_keys.yaml
  The same key is defined more than once: foo
spec/data/overlapping_keys_complex.yaml
  The same key is defined more than once: foo
spec/data/overlapping_keys_deep.yaml
  The same key is defined more than once: foo
spec/data/spaces.yaml
  The YAML should not just be spaces
$
```

#### Rake task options

Add these options similarly to the path option seen above.

<table>
  <th>
    <td>Option</td>
    <td>Description</td>
    <td>Default</td>
  </th>
  <tr>
    <td>`disable_ext_check`</td>
    <td>Disable file extension check</td>
    <td>false</td>
  </tr>
  <tr>
    <td>`fail_on_error`</td>
    <td>Continue on to the next rake task and don't fail even if YamlLint finds errors</td>
    <td>true</td>
  </tr>
  <tr>
    <td>`path`</td>
    <td>List of files or paths to lint</td>
    <td>nil</td>
  </tr>
</table>

## Contributing

1. Fork it ( https://github.com/shortdudey123/yamllint/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
