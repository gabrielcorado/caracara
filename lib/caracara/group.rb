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
      options = Utils.merge @options, options

      # Get the tasks
      task = @tasks[name]

      # Compile the task
      task.compile options
    end

    # Compile all the tasks
    def compile_all(options = {})
      # Each tasks
      @tasks.keys.map do |name|
        # Compile the task
        compile name, options
      end
    end

    # Generate the SSH command
    def command(name, options = {}, ssh_command = true, escape = true)
      # Set options
      options = Utils.merge @options, options

      # Generate task command
      task = @tasks[name].command options, false

      # Do not return the SSH command
      return task unless ssh_command

      # Generate the full command
      SSH.command task, escape
    end

    # Generate all tasks commands
    def command_all(options = {}, escape = true)
      # Each tasks
      tasks = @tasks.keys.map do |name|
        # Compile the task
        command name, options, false
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
