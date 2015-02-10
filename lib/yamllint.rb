require 'logger'

require 'yamllint/version'
require 'yamllint/linter'

###
#
# YamlLint checks YAML files for correct syntax
module YamlLint
  def self.logger
    @logger ||= Logger.new(STDOUT).tap do |l|
      l.level = Logger::INFO
    end
  end
end
