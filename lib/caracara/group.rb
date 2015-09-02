#
module Caracara
  # Group
  class Group
    # Tasks
    attr_reader :tasks

    # Initialize
    def initialize(tasks = [])
      @tasks = tasks
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
      # Each the steps
      @tasks.map do |task|
        # Compile the task
        task.compile args
      end
    end

    # Generate the SSH command
    def command(args = {}, escape = true)
      # Each tasks
      tasks = @tasks.map do |task|
        task.command args, false
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
      def init
        new @tasks
      end

    end
  end
end
