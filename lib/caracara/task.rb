#
module Caracara
  # Task class
  class Task
    # Task steps
    @steps = []

    # Initialize
    def initialize(steps)
      @steps = steps
    end

    # Steps
    def steps
      @steps
    end

    # Compile the tasks
    def compile(args = {})
      # Each the steps
      @steps.map do |step|
        # Compile the mustache template
        Mustache.render step, args
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
        @steps.push cmd
      end

      def init
        # Create a new instance
        new @steps
      end
    end
  end
end
