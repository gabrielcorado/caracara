# Include the helper
require 'spec_helper'

# Class definitions
class TaskSpec < Caracara::Task
  step 'mkdir {{folder.name}}/'
  step 'chown -R {{user}} {{folder.name}}'
  step 'chmod -R {{folder.permission}} {{folder.name}}/'
end

class TaskTwoSpec < Caracara::Task
  step 'mkdir {{folder.name}}/'
  step 'chown -R {{user}} {{folder.name}}'
  step 'chmod -R {{folder.permission}} {{folder.name}}/'
end

# Tests
describe 'Task' do
  # Initialize the task
  let(:task) { TaskSpec.init }

  it 'should return the steps' do
    # Get the steps
    steps = task.steps

    # Assertions
    expect(steps[0]).to eq('mkdir {{folder.name}}/')
    expect(steps[1]).to eq('chown -R {{user}} {{folder.name}}')
    expect(steps[2]).to eq('chmod -R {{folder.permission}} {{folder.name}}/')
  end

  it 'should compile the steps' do
    # Get the steps
    steps = task.compile user: 'ubuntu', folder: { name: 'niceFolder', permission: 755 }

    # Assertions
    expect(steps[0]).to eq('mkdir niceFolder/')
    expect(steps[1]).to eq('chown -R ubuntu niceFolder')
    expect(steps[2]).to eq('chmod -R 755 niceFolder/')
  end

  it 'should generate the SSH command' do
    # Command
    command = task.command user: 'ubuntu', folder: { name: 'niceFolder', permission: 755 }

    # Assertions
    expect(command).to eq("mkdir\\ niceFolder/'\n'chown\\ -R\\ ubuntu\\ niceFolder'\n'chmod\\ -R\\ 755\\ niceFolder/")
  end
end
