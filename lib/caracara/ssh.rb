# Include shellwords
require 'shellwords'

#
module Caracara
  # SSH class
  class SSH
    # Static methods
    class << self
      # Login command
      def login(user, host, options = {})
        # Basic command
        command = "ssh #{user}@#{host}"

        # Identity file
        command << " -i #{options[:key]}" unless options[:key].nil?

        # Port
        command << " -p #{options[:port]}" unless options[:port].nil?

        # Forward agent
        command << ' -A' if options[:forward_agent]

        # Check strict host key
        command << ' -o StrictHostKeyChecking=no'

        # Disable pseudo terminal
        command << ' -T'
      end

      # Escape the command
      def escape(cmd)
        Shellwords.escape cmd
      end

      # Generate a command
      def command(cmd, escape = true)
        # Joing commands
        cmd = cmd.join("\n") if cmd.is_a? Array

        # Escape the command
        cmd = escape(cmd) if escape

        # Return the command
        cmd
      end

      # Generate the SSH command
      def generate(user, host, cmd, ssh_options = {})
        "#{login(user, host, ssh_options)} -- #{command(cmd)}"
      end

      # Exec the SSH command
      def exec(cmd)
        # System the command
        result = `#{cmd}`

        # Return the status
        status = $?.to_i

        # Return the status `true` for success and `false` for error
        {
          result: result,
          status: !(status.is_a?(Fixnum) && status > 0)
        }
      end
    end
  end
end
