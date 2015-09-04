# Include the helper
require 'spec_helper'

# Class definitions
class TaskSpec < Caracara::Task
  step 'mkdir {{folder.name}}/'
  step 'chown -R {{user}} {{folder.name}}'
  step 'chmod -R {{folder.permission}} {{folder.name}}/'

  dir '{{folder.name}}' do
    step 'echo "{{text}}" > file.txt'
  end
end

class TaskTwoSpec < Caracara::Task
  step 'mkdir {{folder.name}}/'
  step 'chown -R {{user}} {{folder.name}}'
  step 'chmod -R {{folder.permission}} {{folder.name}}/'
end

# Tests
describe 'Task' do
  # Initialize the task
  let(:task) {
    TaskSpec.init user: 'ubuntu',
                  folder: {
                    name: 'niceFolder',
                    permission: 755
                  },
                  text: 'Some nice text!'
  }

  it 'should return the steps' do
    # Get the steps
    steps = task.steps

    # Assertions
    expect(steps[0]).to eq('mkdir {{folder.name}}/')
    expect(steps[1]).to eq('chown -R {{user}} {{folder.name}}')
    expect(steps[2]).to eq('chmod -R {{folder.permission}} {{folder.name}}/')
    expect(steps[3]).to eq('(cd {{folder.name}} && (echo "{{text}}" > file.txt))')
  end

  it 'should compile the steps' do
    # Get the steps
    steps = task.compile

    # Assertions
    expect(steps[0]).to eq('mkdir niceFolder/')
    expect(steps[1]).to eq('chown -R ubuntu niceFolder')
    expect(steps[2]).to eq('chmod -R 755 niceFolder/')
    expect(steps[3]).to eq('(cd niceFolder && (echo "Some nice text!" > file.txt))')
  end

  it 'should compile the steps using specific args' do
    # Get the steps
    steps = task.compile user: 'root',
                         folder: {
                           name: 'argsFolder',
                           permission: 655
                         }

    # Assertions
    expect(steps[0]).to eq('mkdir argsFolder/')
    expect(steps[1]).to eq('chown -R root argsFolder')
    expect(steps[2]).to eq('chmod -R 655 argsFolder/')
    expect(steps[3]).to eq('(cd argsFolder && (echo "Some nice text!" > file.txt))')
  end

  it 'should generate the SSH command' do
    # Command
    command = task.command

    # Assertions
    expect(command).to eq("mkdir\\ niceFolder/'\n'chown\\ -R\\ ubuntu\\ niceFolder'\n'chmod\\ -R\\ 755\\ niceFolder/'\n'\\(cd\\ niceFolder\\ \\&\\&\\ \\(echo\\ \\\"Some\\ nice\\ text\\!\\\"\\ \\>\\ file.txt\\)\\)")
  end
end
