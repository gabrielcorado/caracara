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
      # @param {Symbol} name The task name
      # @param {Caracara::Task/String} task The task itself
      def task(*args)
        # Check if it two params
        if args[1].nil?
          # Set command
          name = nil
          command = args[0]
        else
          # Set command and name
          name = args[0]
          command = args[1]
        end

        # The task name cannot be :default
        raise 'The task name cannot be :default' if name === :default || name === 'default'

        # Check the type of the command
        if command.is_a? String
          task = Task.new [command]
        else
          task = command.init
        end

        # Init the tasks
        if @tasks.nil?
          @tasks = {
            default: []
          }
        end

        # Warn
        puts '\nThere is a task with the same name, the oldest one will be overrided\n' unless @tasks[name].nil?

        # Check the name
        if name.nil?
          # Push it to the tasks
          @tasks[:default].push task
        else
          @tasks[name] = task
        end
      end

      # Init
      def init(options = {})
        new @tasks, options
      end

    end
  end
end
