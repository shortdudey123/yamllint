require 'trollop'

module YamlLint
  ###
  # CLI execution
  #
  class CLI
    attr_reader :opts

    # setup CLI options
    def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR,
      kernel = Kernel)
      @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout,
                                                 stderr, kernel
    end

    # Run the CLI command
    def execute!
      parse_options

      files_to_check = @argv

      no_yamls_to_check_msg = 'need at least one YAML file to check'
      Trollop.die no_yamls_to_check_msg if files_to_check.empty?
      lint(files_to_check)
    end

    private

    def lint(files_to_check)
      if files_to_check == ['-']
        linter = lint_stream
      else
        linter = lint_files(files_to_check)
      end

      puts 'YamlLint found no errors' unless linter.errors?
      return unless linter.errors?
      linter.display_errors
      puts "YAML lint found #{linter.errors_count} errors"
      @kernel.exit(1)
    end

    def lint_files(files_to_check)
      linter = YamlLint::Linter.new
      begin
        puts "Checking #{files_to_check.flatten.length} files"
        linter.check_all(files_to_check)
      rescue => e
        @stderr.puts e.message
        exit(1)
      end

      linter
    end

    def lint_stream
      linter = YamlLint::Linter.new
      begin
        linter.check_stream(STDIN)
      rescue => e
        @stderr.puts e.message
        exit(1)
      end

      linter
    end

    def parse_options
      @opts = Trollop.options(@argv) do
        banner 'Usage: yamllint [options] file1.yaml [file2.yaml ...]'
        version(YamlLint::VERSION)

        banner ''
        banner 'Options:'
      end
    end
  end
end
