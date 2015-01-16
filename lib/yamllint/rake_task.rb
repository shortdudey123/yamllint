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
    attr_accessor :fail_on_error

    def initialize(name = :yamllint)
      @name = name
      @fail_on_error = true

      yield self if block_given?

      define_task
    end

    private

    def define_task
      desc 'Run yamllint' unless ::Rake.application.last_comment

      task(name) do
        puts 'Running YamlLint...'

        files_to_check = Rake::FileList.new(paths)

        puts "Checking #{files_to_check.flatten.length} files"

        linter = ::YamlLint::Linter.new
        linter.check_all(files_to_check)

        if linter.errors?
          linter.display_errors
          puts "YAML lint found #{linter.errors_count} errors"
          abort('YamlLint failed!') if fail_on_error
        else
          puts 'YamlLint found no errors'
        end
      end
    end
  end
end
