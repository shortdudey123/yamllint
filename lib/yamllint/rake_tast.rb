require 'rake'
require 'rake/tasklib'

require 'yamllint'

module YamlLint
  ###
  # RakeTast execution
  #
  class RakeTask < Rake::TaskLib
    attr_accessor :name
    attr_accessor :paths

    def initialize(name = :yamllint)
      @name = name

      yield self if block_given?

      define_task
    end

    private

    def define_task
      desc 'Run yamllint' unless ::Rake.application.last_comment

      task(name) do
        files_to_check = Rake::FileList.new(paths)

        linter = ::YamlLint::Linter.new
        linter.check_all(files_to_check)

        if linter.errors?
          linter.display_errors
          abort('YAML lint found')
        end
      end
    end
  end
end
