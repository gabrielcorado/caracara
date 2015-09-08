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

    # Compile the tasks
    def compile(name, options = {})
      # Set options
      options = @options.merge options

      # Get the tasks
      task = @tasks[name]

      # Compile the task
      task.compile options
    end

      # Each the steps
      @tasks.map do |task|
        # Compile the task
        task.compile options
      end
    end

    # Generate the SSH command
    def command(name, options = {}, ssh_command = true, escape = true)
      # Set options
      options = @options.merge options

      # Generate task command
      task = @tasks[name].command options, false

      # Do not return the SSH command
      return task unless ssh_command

      # Generate the full command
      SSH.command task, escape
    end
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
      # @param {Symbol} name The task name
      # @param {Caracara::Task/String} task The task itself
      def task(name, command)
        # Check the type of the command
        if command.is_a? String
          task = Task.new [command]
        else
          task = command.init
        end

        # Init the tasks
        @tasks = {} if @tasks.nil?

        # Set the task
        @tasks[name] = task
      end

      # Init
      def init(options = {})
        new @tasks, options
      end

    end
  end
end
