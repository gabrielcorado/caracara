#
module Caracara
  # Group
  class Group
    # Tasks
    attr_reader :tasks

    # Initialize
    def initialize(tasks = [], options = {})
      @tasks = tasks
      @options = options
    end

    # Tasks access
    def tasks
      # Map the tasks
      @tasks.map do |task|
        task
      end
    end

    # Compile the tasks
    def compile(args = {})
      # Merge options and args
      options = @options.merge args

      # Each the steps
      @tasks.map do |task|
        # Compile the task
        task.compile options
      end
    end

    # Generate the SSH command
    def command(escape = true)
      # Each tasks
      tasks = @tasks.map do |task|
        task.command @options, false
      end

      # Generate the full command
      SSH.command tasks, escape
    end

    # Static methods
    class << self
      # Tasks
      attr_reader :tasks

      # Set a new task to the group
      def task(command)
        # Check the type of the command
        if command.is_a? String
          task = Task.new [command]
        else
          task = command.init
        end

        # Init the tasks
        @tasks = [] if @tasks.nil?

        # Push it to the tasks
        @tasks.push task
      end

      # Init
      def init(options = {})
        new @tasks, options
      end

    end
  end
end
