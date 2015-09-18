#
module Caracara
  # Task class
  class Task
    # Task steps
    @steps = []

    # Fixed options
    @fixed_options = {}

    # Initialize
    def initialize(steps, fixed_options = {}, args = {})
      @steps = steps
      @fixed_options = fixed_options
      @options = args
    end

    # Steps
    def steps
      @steps
    end

    # Compile the tasks
    def compile(args = {})
      # Merge args with defult options
      options = Utils.merge @options, args

      # Each the steps
      @steps.map.with_index do |step, index|
        # Append with the fixed options
        options = Utils.merge(options, @fixed_options[index]) unless @fixed_options[index].nil?

        # Compile the mustache template
        Mustache.render step, compile_options(options, options)
      end
    end

    # Generate the SSH command
    def command(args = {}, escape = true)
      SSH.command compile(args), escape
    end

    private

    # Compile hash of options
    # @param {Hash} compile The hash that will be compiled using Mustache
    # @param {Hash} options Options used to compile this Hash
    # @return {Hash} A compiled hash with the same structure of the `compile` one
    def compile_options(compile, options)
      # Compiled options
      compiled_options = {}

      # Each options
      compile.each do |key, value|
        # Check if the value is another hash
        # Compile the content with the options
        compiled = if value.is_a?(Hash)
          compile_options value, options
        elsif value.is_a?(Array)
          value
        else
          Mustache.render value.to_s, options
        end

        # Put it into the compile_options
        compiled_options[key] = compiled
      end

      # Return the compile options
      compiled_options
    end

    # Static methods
    class << self
      # Static attributes
      attr_reader :steps, :fixed_options

      # Run steps inside a dir
      def dir(name, &blk)
        # Store the current steps and set a blank steps
        old, @steps = @steps, nil

        # Generate the block steps
        result = yield

        # Restore the old steps
        @steps = old

        # Put dir commands in the steps
        step "(cd #{name} && (#{result.join('\n')}))"
      end

      # Add a step
      def step(cmd, fixed_options = {})
        # Define the step
        @steps = [] if @steps.nil?

        # Define the step
        @fixed_options = {} if @fixed_options.nil?

        # Add a new step
        if cmd.is_a?(String)
          # Push step and get the index
          index = @steps.push(cmd).length - 1

          # Add fixed options
          @fixed_options[index] = fixed_options

          # Default return
          return @steps
        end

        # If it is another task
        cmd.steps.each do |task_cmd|
          # Push and get the index
          index = @steps.push(task_cmd).length - 1

          # Add fixed options
          @fixed_options[index] = fixed_options
        end

        # Default return
        @steps
      end

      # Initialize a task
      def init(args = {})
        # Create a new instance
        new @steps, @fixed_options, args
      end
    end
  end
end
