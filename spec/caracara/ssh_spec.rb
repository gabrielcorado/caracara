# Include the helper
require 'spec_helper'

# Tests
describe 'SSH' do
  context 'login' do
    it 'should be generated without all the params' do
      # Generate the SSH command
      command = Caracara::SSH.login 'user', 'localhost'

      # Assertions
      expect(command).to eq('ssh user@localhost -o StrictHostKeyChecking=no -T')
    end

    it 'should be generated with all the param' do
      # Generate the SSH command
      command = Caracara::SSH.login 'user', 'localhost', key: '~/my-key', port: 22, forward_agent: true

      # Assertions
      expect(command).to eq('ssh user@localhost -i ~/my-key -p 22 -A -o StrictHostKeyChecking=no -T')
    end
  end

  context 'string command' do
    it 'should be generated with a string command' do
      # Generate command
      command = Caracara::SSH.command %{ls -la}

      # Assertions
      expect(command).to eq('ls\\ -la')
    end


    it 'should be generated with an array of commands' do
      # Generate commands
      commands = Caracara::SSH.command([
        'ls -la',
        'pwd'
      ])

      # Assertions
      expect(commands).to eq("ls\\ -la'\n'pwd")
    end
  end

  it 'should generate the SSH command' do
    # Generate command
    command = Caracara::SSH.generate 'user', 'localhost', %{ls -la}

    # Assertions
    expect(command).to eq('ssh user@localhost -o StrictHostKeyChecking=no -T -- ls\\ -la')
  end

  it 'should execute the SSH command' do
    # Generate command
    command = Caracara::SSH.generate 'ubuntu', 'localhost', %{ls -la}

    # Run the command
    result = Caracara::SSH.exec command

    # Assertions
    # it should return false because ssh localhost it not enable
    expect(result[:status]).to eq(false)
  end
end
