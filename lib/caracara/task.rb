#
module Caracara
  # Task class
  class Task
    # Task steps
    @steps = []

    # Initialize
    def initialize(steps, args = {})
      @steps = steps
      @options = args
    end

    # Steps
    def steps
      @steps
    end

    # Compile the tasks
    def compile(args = {})
      # Merge args with defult options
      options = @options.merge args

      # Each the steps
      @steps.map do |step|
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
      # Task steps
      attr_reader :steps

      # Run steps inside a dir
      def dir(name, &blk)
        # Store the current steps and set a blank steps
        old, @steps = @steps, nil

        # Generate the block steps
        result = yield

        # Restore the old steps
        @steps = old

        # Put dir commands in the steps
        @steps.push "(cd #{name} && (#{result.join('\n')}))"
      end

      # Add a step
      def step(cmd)
        # Define the step
        @steps = [] if @steps.nil?

        # Add a new step
        return @steps.push(cmd) if cmd.is_a?(String)

        # If it is another task
        cmd.steps.each do |task_cmd|
          @steps.push task_cmd
        end
      end

      # Initialize a task
      def init(args = {})
        # Create a new instance
        new @steps, args
      end
    end
  end
end
