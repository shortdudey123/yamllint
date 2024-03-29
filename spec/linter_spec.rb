require 'spec_helper'
require 'yamllint/linter'

describe 'YamlLint::Linter' do
  let(:linter) { YamlLint::Linter.new }

  before do
    allow(linter).to receive(:puts)
  end

  it 'should throw an exception if given a bogus path' do
    expect { linter.check('/does/not/exist') }.to raise_error(
      YamlLint::FileNotFoundError
    )
  end

  it 'should be happy with a valid YAML file' do
    expect(linter.check(spec_data('valid.yaml'))).to be(true)
    expect(linter.check(spec_data('valid_complex.yaml'))).to be(true)
    expect(linter.check(spec_data('valid_very_complex.yaml'))).to be(true)
    expect(linter.check(spec_data('valid_empty.yaml'))).to be(true)
    expect(linter.check(spec_data('valid_spaces.yaml'))).to be(true)
    expect(linter.check(spec_data('valid_only_comment.yaml'))).to be(true)
  end

  it 'should have 0 error count with a valid YAML file' do
    linter.check(spec_data('valid.yaml'))
    expect(linter.errors_count).to eq(0)
  end

  it 'should have 0 error count with a empty YAML file' do
    linter.check(spec_data('valid_empty.yaml'))
    expect(linter.errors_count).to eq(0)
  end

  it 'should be happy with a multiple valid YAML files' do
    linter.check_all([spec_data('valid.yaml'), spec_data('valid_complex.yaml')])
    expect(linter.errors?).to be(false)
  end

  it 'should be unhappy with an invalid YAML file extension' do
    expect(linter.check(spec_data('wrong_extension.txt'))).to be(false)
  end

  it 'should be unhappy with an invalid YAML file' do
    expect(linter.check(spec_data('invalid.yaml'))).to be(false)
  end

  it 'should be unhappy with YAML that has overlapping keys' do
    expect(linter.check(spec_data('overlapping_keys.yaml'))).to be(false)
    expect(linter.check(spec_data('overlapping_keys_deep.yaml'))).to be(false)
  end

  it 'should be able to check an IO stream' do
    valid_stream = File.open(spec_data('valid.yaml'))
    expect(linter.check_stream(valid_stream)).to be(true)

    invalid_stream = File.open(spec_data('overlapping_keys.yaml'))
    expect(linter.check_stream(invalid_stream)).to be(false)
  end
end
