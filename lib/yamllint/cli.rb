require 'trollop'
require 'pry'

module YamlLint
  ###
  # CLI execution
  #
  class CLI
    attr_reader :opts

    # setup CLI options
    def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR,
                   kernel = Kernel)
      @argv = argv
      @stdin = stdin
      @stdout = stdout
      @stderr = stderr
      @kernel = kernel
    end

    # Run the CLI command
    def execute!
      files_to_check = parse_options.leftovers

      no_yamls_to_check_msg = "Error: need at least one YAML file to check.\n"\
                              'Try --help for help.'
      abort(no_yamls_to_check_msg) if files_to_check.empty?
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
      ext = opts.extensions.split(',') unless opts.extensions.nil?
      linter = YamlLint::Linter.new(disable_ext_check: opts.disable_ext_check,
                                    extensions: ext
                                   )
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

    def setup_options
      Trollop::Parser.new do
        banner 'Usage: yamllint [options] file1.yaml [file2.yaml ...]'
        version(YamlLint::VERSION)

        banner ''
        banner 'Options:'
        opt :disable_ext_check, 'Disable file extension check', default: false
        opt :extensions, 'Add more allowed extensions (comma delimited list)',
            type: :string
      end
    end

    def parse_options
      p = setup_options

      @opts = Trollop.with_standard_exception_handling p do
        p.parse(@argv)
      end

      p
    end
  end
end
