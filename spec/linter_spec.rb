require 'spec_helper'
require 'yamllint/linter'

describe 'YamlLint::Linter' do
  let(:linter) { YamlLint::Linter.new }

  it 'should throw an exception if given a bogus path' do
    expect { linter.check('/does/not/exist') }.to raise_error
  end

  it 'should be happy with a valid YAML file' do
    expect(linter.check(spec_data('valid.yaml'))).to be(true)
    expect(linter.check(spec_data('valid_complex.yaml'))).to be(true)
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

  it 'should be unhappy with an empty YAML file' do
    expect(linter.check(spec_data('empty.yaml'))).to be(false)
  end

  it 'should be unhapy with a YAML file full of spaces' do
    expect(linter.check(spec_data('spaces.yaml'))).to be(false)
  end
end
