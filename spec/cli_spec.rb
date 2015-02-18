require 'spec_helper'

describe 'yamllint' do
  it 'should print usage if run with no args' do
    yamllint
    assert_failing_with('Error')
  end

  it '-h should print usage' do
    yamllint '-h'
    assert_passing_with('Usage')
  end

  it '--help should print usage' do
    yamllint '--help'
    assert_passing_with('Usage')
  end

  it '-v should print its version' do
    yamllint '-v'
    assert_passing_with(YamlLint::VERSION)
  end

  it '--version should print its version' do
    yamllint '--version'
    assert_passing_with(YamlLint::VERSION)
  end

  it 'should exit successfully with good YAML' do
    yamllint spec_data('valid.yaml')
    assert_success(true)
  end

  it 'should fail with bad YAML' do
    yamllint spec_data('invalid.yaml')
    assert_success(false)
  end

  it 'should fail with a path that does not exist' do
    yamllint '/does/not/exist'
    assert_failing_with('no such file')
  end

  it 'should fail with an invalid YAML file extension' do
    yamllint spec_data('wrong_extension.txt')
    assert_failing_with('File extension must be .yaml or .yml')
  end

  it 'should pass with invalid file extension and extension check disabled' do
    yamllint "-d #{spec_data('wrong_extension.txt')}"
    assert_success(true)
  end

  it 'should pass with custom extension' do
    yamllint "-e eyaml #{spec_data('custom_extension.eyaml')}"
    assert_success(true)
  end

  it 'should fail with a path that is unreadable' do
    run_simple('mkdir -p tmp')
    run_simple('touch tmp/unreadable_file.yaml')
    run_simple('chmod -r tmp/unreadable_file.yaml')

    yamllint 'tmp/unreadable_file.yaml'
    assert_failing_with('Permission denied')
  end

  it 'should be able to lint good YAML from STDIN' do
    run_interactive "#{yamllint_bin} -"
    pipe_in_file(spec_data('valid.yaml')) && close_input
    assert_success(true)
  end

  it 'should be able to lint bad YAML from STDIN' do
    run_interactive "#{yamllint_bin} -"
    pipe_in_file(spec_data('invalid.yaml')) && close_input
    assert_success(false)
  end
end
