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
    attr_accessor :exclude_paths
    attr_accessor :fail_on_error
    attr_accessor :disable_ext_check
    attr_accessor :extensions
    attr_accessor :debug

    def initialize(name = :yamllint)
      @name = name
      @fail_on_error = true
      @disable_ext_check = false
      @extensions = nil
      @debug = false
      @exclude_paths = []

      yield self if block_given?

      define_task
    end

    private

    # Rake task
    def define_task
      desc 'Run yamllint' unless ::Rake.application.last_description

      task(name) do
        puts 'Running YamlLint...'

        YamlLint.logger.level = Logger::DEBUG if debug

        files_to_check_raw = Rake::FileList.new(paths)
        files_to_exclude = Rake::FileList.new(exclude_paths)
        files_to_check = files_to_check_raw - files_to_exclude

        puts "Checking #{files_to_check.flatten.length} files"
        puts "Excluding #{files_to_exclude.flatten.length} files"

        linter = ::YamlLint::Linter.new(disable_ext_check: disable_ext_check,
                                        extensions: extensions)
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
