require 'yaml'
require 'set'

require 'yamllint/errors'

module YamlLint
  ###
  # Runs the actual linting
  #
  class Linter
    attr_reader :errors

    def initialize
      @errors = {}
    end

    def check_all(*files_to_check)
      files_to_check.flatten.each { |f| check(f) }
    end

    def check(path)
      fail FileNotFoundError, "#{path}: no such file" unless File.exist?(path)

      valid = false
      unless check_filename(path)
        errors[path] = ['File extention must be .yaml or .yml']
        return valid
      end

      File.open(path, 'r') do |f|
        error_array = []
        valid = check_data(f.read, error_array)
        errors[path] = error_array unless error_array.empty?
      end

      valid
    end

    def check_stream(io_stream)
      yaml_data = io_stream.read
      error_array = []

      valid = check_data(yaml_data, error_array)
      errors[''] = error_array unless error_array.empty?

      valid
    end

    def errors?
      !errors.empty?
    end

    def errors_count
      errors.length
    end

    def display_errors
      errors.each do |path, errors|
        puts path
        errors.each do |err|
          puts "  #{err}"
        end
      end
    end

    private

    def check_filename(filename)
      extention = filename.split('.').last
      return true if extention == 'yaml' || extention == 'yml'
      false
    end

    def check_data(yaml_data, errors_array)
      valid = check_not_empty(yaml_data, errors_array)
      valid &&= check_syntax_valid(yaml_data, errors_array)
      valid &&= check_overlapping_keys(yaml_data, errors_array)

      valid
    end

    def check_not_empty(yaml_data, errors_array)
      if yaml_data.empty?
        errors_array << 'The YAML should not be an empty string'
        false
      elsif yaml_data.strip.empty?
        errors_array << 'The YAML should not just be spaces'
        false
      else
        true
      end
    end

    def check_syntax_valid(yaml_data, errors_array)
      YAML.load(yaml_data)
      true
    rescue YAML::SyntaxError => e
      errors_array << e.message
      false
    end

    ###
    # Detects duplicate keys in Psych parsed data
    #
    class KeyOverlapDetector
      attr_reader :overlapping_keys

      def initialize
        @seen_keys = Set.new
        @key_components = []
        @last_key = []
        @overlapping_keys = Set.new
        @complex_type = []
        @array_positions = []
      end

      def parse(psych_parse_data)
        data_start = psych_parse_data.handler.root.children[0].children[0]
        hash_start('')
        parse_recurse(data_start)
        hash_end('')
      end

      private

      def parse_recurse(psych_parse_data, is_sequence = false)
        is_key = false
        psych_parse_data.children.each do |n|
          case n.class.to_s
          when 'Psych::Nodes::Scalar'
            is_key = !is_key unless is_sequence
            @last_key.push(n.value) if is_key
            add_value(n.value, @last_key.last) unless is_key
            msg = "Scalar: #{n.value}, key: #{is_key}, last_key: #{@last_key}"
            YamlLint.logger.debug { msg }
            @last_key.pop if !is_key && !is_sequence
          when 'Psych::Nodes::Sequence'
            YamlLint.logger.debug { "Sequence: #{n.children}" }
            array_start(@last_key.last)
            parse_recurse(n, true)
            array_end(@last_key.last)
            is_key = false
            @last_key.pop
          when 'Psych::Nodes::Mapping'
            YamlLint.logger.debug { "Mapping: #{n.children}" }
            hash_start(@last_key.last)
            parse_recurse(n)
            hash_end(@last_key.last)
            is_key = false
            @last_key.pop
          end
        end
      end

      def hash_start(key)
        YamlLint.logger.debug { "hash_start: #{key.inspect}" }

        case @complex_type.last
        when :hash
          @key_components.push(key)
        when :array
          @key_components.push(@array_positions.last)
          @array_positions[-1] += 1
        end

        @complex_type.push(:hash)
        check_for_overlap!
      end

      def hash_end(key)
        YamlLint.logger.debug { "hash_end: #{key.inspect}" }

        @key_components.pop
        @complex_type.pop
      end

      def array_start(key)
        YamlLint.logger.debug { "array_start: #{key.inspect}" }

        case @complex_type.last
        when :hash
          @key_components.push(key)
        when :array
          @key_components.push(@array_positions.last)
          @array_positions[-1] += 1
        end

        @complex_type.push(:array)
        @array_positions.push(0)
        check_for_overlap!
      end

      def array_end(key)
        YamlLint.logger.debug { "array_end: #{key.inspect}" }

        @key_components.pop
        @complex_type.pop
        @array_positions.pop
      end

      def add_value(value, key)
        YamlLint.logger.debug { "add_value: #{value.inspect}, #{key.inspect}" }

        case @complex_type.last
        when :hash
          @key_components.push(key)
          check_for_overlap!
          @key_components.pop
        when :array
          @key_components.push(@array_positions.last)
          check_for_overlap!
          @array_positions[-1] += 1
          @key_components.pop
        end
      end

      def check_for_overlap!
        full_key = @key_components.dup
        YamlLint.logger.debug { "Checking #{full_key.join('.')} for overlap" }

        return if @seen_keys.add?(full_key)
        YamlLint.logger.debug { "Overlapping key #{full_key.join('.')}" }
        @overlapping_keys << full_key
      end
    end

    def check_overlapping_keys(yaml_data, errors_array)
      overlap_detector = KeyOverlapDetector.new
      data = Psych.parser.parse(yaml_data)

      overlap_detector.parse(data)

      overlap_detector.overlapping_keys.each do |key|
        err_meg = "The same key is defined more than once: #{key.join('.')}"
        errors_array << err_meg
      end

      !!overlap_detector.overlapping_keys.empty?
    end
  end
end
