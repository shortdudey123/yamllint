# frozen_string_literal: true

require 'spec_helper'

describe 'yamllint' do
  it 'should print usage if run with no args' do
    yamllint
    expect(last_command_started).to_not be_successfully_executed
    expect(last_command_started).to have_output(/Error: need at least one YAML/)
  end

  it '-h should print usage' do
    yamllint '-h'
    expect(last_command_started).to be_successfully_executed
    expect(last_command_started).to have_output(/Usage: yamllint/)
  end

  it '--help should print usage' do
    yamllint '--help'
    expect(last_command_started).to be_successfully_executed
    expect(last_command_started).to have_output(/Usage: yamllint/)
  end

  it '-v should print its version' do
    yamllint '-v'
    expect(last_command_started).to be_successfully_executed
    expect(last_command_started).to have_output YamlLint::VERSION
  end

  it '--version should print its version' do
    yamllint '--version'
    expect(last_command_started).to be_successfully_executed
    expect(last_command_started).to have_output YamlLint::VERSION
  end

  it '-D should print debug log and exit successfully with good YAML' do
    yamllint spec_data('valid.yaml -D')
    expect(last_command_started).to be_successfully_executed
    expect(last_command_started).to have_output(/DEBUG -- : add_value: "bar"/)
    expect(last_command_started).to have_output(/DEBUG -- : Checking my_array/)
  end

  it '--debug should print debug log and exit successfully with good YAML' do
    yamllint spec_data('valid.yaml --debug')
    expect(last_command_started).to be_successfully_executed
    expect(last_command_started).to have_output(/DEBUG -- : add_value: "bar"/)
    expect(last_command_started).to have_output(/DEBUG -- : Checking my_array/)
  end

  it 'should exit successfully with good YAML' do
    yamllint spec_data('valid.yaml')
    expect(last_command_started).to be_successfully_executed
  end

  it 'should fail with bad YAML' do
    yamllint spec_data('invalid.yaml')
    expect(last_command_started).to_not be_successfully_executed
  end

  it 'should fail with a path that does not exist' do
    yamllint '/does/not/exist'
    expect(last_command_started).to_not be_successfully_executed
    expect(last_command_started).to have_output(/no such file/)
  end

  it 'should fail with an invalid YAML file extension' do
    yamllint spec_data('wrong_extension.txt')
    expect(last_command_started).to_not be_successfully_executed
    expect(last_command_started).to have_output(/File extension must be .yaml/)
  end

  it 'should pass with invalid file extension and extension check disabled' do
    yamllint "-d #{spec_data('wrong_extension.txt')}"
    expect(last_command_started).to be_successfully_executed
  end

  it 'should pass with custom extension' do
    yamllint "-e eyaml #{spec_data('custom_extension.eyaml')}"
    expect(last_command_started).to be_successfully_executed
  end

  it 'should fail with a path that is unreadable' do
    run_command_and_stop('mkdir -p tmp')
    run_command_and_stop('touch tmp/unreadable_file.yaml')
    run_command_and_stop('chmod -r tmp/unreadable_file.yaml')

    yamllint 'tmp/unreadable_file.yaml'
    expect(last_command_started).to_not be_successfully_executed
    expect(last_command_started).to have_output(/Permission denied/)
  end

  it 'should be able to lint good YAML from STDIN' do
    run_command "#{yamllint_bin} -"
    pipe_in_file('../../spec/data/valid.yaml') && close_input
    expect(last_command_started).to be_successfully_executed
  end

  it 'should be able to lint bad YAML from STDIN' do
    run_command "#{yamllint_bin} -"
    pipe_in_file('../../spec/data/invalid.yaml') && close_input
    expect(last_command_started).to_not be_successfully_executed
  end
end
