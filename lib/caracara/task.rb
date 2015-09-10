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
        # options = options.merge(@fixed_options[index]) unless @fixed_options[index].nil?
        options = Utils.merge(options, @fixed_options[index]) unless @fixed_options[index].nil?

        # Compile the mustache template
        Mustache.render step, options
      end
    end

    # Generate the SSH command
    def command(args = {}, escape = true)
      SSH.command compile(args), escape
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
